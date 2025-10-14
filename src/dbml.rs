use zed_extension_api::{self as zed, LanguageServerId, Result, Worktree};

const SERVER_VERSION: &str = "0.1.0";

struct DbmlExtension {
    cached_binary_path: Option<String>,
}

impl DbmlExtension {
    fn new() -> Self {
        Self {
            cached_binary_path: None,
        }
    }

    /// Get the binary filename based on the platform
    fn get_binary_name(&self) -> &'static str {
        #[cfg(target_os = "windows")]
        return "dbml-language-server.exe";

        #[cfg(not(target_os = "windows"))]
        return "dbml-language-server";
    }

    /// Check if cargo is available
    fn check_cargo_available(&self) -> bool {
        let result = zed::Command::new("cargo")
            .args(vec!["--version".to_string()])
            .output();

        if let Ok(output) = result {
            eprintln!(
                "[DBML Extension] cargo --version: {}",
                String::from_utf8_lossy(&output.stdout)
            );
            output.status == Some(0)
        } else {
            eprintln!("[DBML Extension] cargo not found");
            false
        }
    }

    /// Install the language server using cargo install
    fn install_language_server(&self, language_server_id: &LanguageServerId) -> Result<String> {
        eprintln!("[DBML Extension] Installing dbml-language-server from crates.io...");

        zed::set_language_server_installation_status(
            language_server_id,
            &zed::LanguageServerInstallationStatus::Downloading,
        );

        // Install the language server using cargo install
        let install_result = zed::Command::new("cargo")
            .args(vec![
                "install".to_string(),
                "dbml-language-server".to_string(),
                "--version".to_string(),
                SERVER_VERSION.to_string(),
                "--force".to_string(),
            ])
            .output();

        match install_result {
            Ok(output) => {
                eprintln!(
                    "[DBML Extension] cargo install output: {}",
                    String::from_utf8_lossy(&output.stdout)
                );
                eprintln!(
                    "[DBML Extension] cargo install stderr: {}",
                    String::from_utf8_lossy(&output.stderr)
                );

                if output.status != Some(0) {
                    let error_msg = format!(
                        "Failed to install dbml-language-server. Error: {}",
                        String::from_utf8_lossy(&output.stderr)
                    );

                    zed::set_language_server_installation_status(
                        language_server_id,
                        &zed::LanguageServerInstallationStatus::Failed(error_msg.clone()),
                    );

                    return Err(error_msg.into());
                }
            }
            Err(e) => {
                let error_msg = format!("Failed to run cargo install: {:?}", e);
                zed::set_language_server_installation_status(
                    language_server_id,
                    &zed::LanguageServerInstallationStatus::Failed(error_msg.clone()),
                );
                return Err(error_msg.into());
            }
        }

        // Use 'which' to find the installed binary
        eprintln!("[DBML Extension] Locating installed binary with 'which'...");

        #[cfg(target_os = "windows")]
        let which_cmd = "where";
        #[cfg(not(target_os = "windows"))]
        let which_cmd = "which";

        let which_result = zed::Command::new(which_cmd)
            .args(vec![self.get_binary_name().to_string()])
            .output();

        let binary_path = match which_result {
            Ok(output) if output.status == Some(0) => {
                let path = String::from_utf8_lossy(&output.stdout)
                    .trim()
                    .lines()
                    .next()
                    .unwrap_or("")
                    .to_string();

                if path.is_empty() {
                    return Err("Failed to locate installed language server binary".into());
                }

                path
            }
            _ => {
                return Err("Failed to locate installed language server binary".into());
            }
        };

        eprintln!(
            "[DBML Extension] Language server installed at: {}",
            binary_path
        );

        zed::set_language_server_installation_status(
            language_server_id,
            &zed::LanguageServerInstallationStatus::None,
        );

        Ok(binary_path)
    }

    /// Try to find an existing installation of the language server
    fn find_existing_binary(&self) -> Option<String> {
        eprintln!("[DBML Extension] Searching for existing binary...");

        // Use 'which' to find the binary in PATH
        #[cfg(target_os = "windows")]
        let which_cmd = "where";
        #[cfg(not(target_os = "windows"))]
        let which_cmd = "which";

        let which_result = zed::Command::new(which_cmd)
            .args(vec![self.get_binary_name().to_string()])
            .output();

        if let Ok(output) = which_result {
            if output.status == Some(0) {
                let path = String::from_utf8_lossy(&output.stdout)
                    .trim()
                    .lines()
                    .next()
                    .unwrap_or("")
                    .to_string();

                if !path.is_empty() {
                    eprintln!("[DBML Extension] Found binary in PATH: {}", path);
                    return Some(path);
                }
            }
        }

        eprintln!("[DBML Extension] No existing binary found");
        None
    }

    /// Main function to get or install the language server binary
    fn language_server_binary_path(
        &mut self,
        language_server_id: &LanguageServerId,
        _worktree: &Worktree,
    ) -> Result<String> {
        eprintln!("[DBML Extension] ========== Starting language_server_binary_path ==========");

        // Check cache first
        if let Some(path) = &self.cached_binary_path {
            eprintln!("[DBML Extension] ✓ Using cached binary path: {}", path);
            return Ok(path.clone());
        }

        zed::set_language_server_installation_status(
            language_server_id,
            &zed::LanguageServerInstallationStatus::CheckingForUpdate,
        );

        // Try to find existing binary
        if let Some(existing_path) = self.find_existing_binary() {
            eprintln!(
                "[DBML Extension] ✓ Using existing binary: {}",
                existing_path
            );
            self.cached_binary_path = Some(existing_path.clone());

            zed::set_language_server_installation_status(
                language_server_id,
                &zed::LanguageServerInstallationStatus::None,
            );

            return Ok(existing_path);
        }

        // Check if cargo is available
        if !self.check_cargo_available() {
            let error_msg =
                "Rust toolchain (cargo) not found. Please install Rust from https://rustup.rs/\n\n\
                           The extension will provide syntax highlighting only.";

            zed::set_language_server_installation_status(
                language_server_id,
                &zed::LanguageServerInstallationStatus::Failed(error_msg.to_string()),
            );

            return Err(error_msg.into());
        }

        // Install the language server
        let binary_path = self.install_language_server(language_server_id)?;

        // Cache the path
        self.cached_binary_path = Some(binary_path.clone());

        eprintln!("[DBML Extension] ========== Finished successfully ==========");
        Ok(binary_path)
    }
}

impl zed::Extension for DbmlExtension {
    fn new() -> Self {
        Self::new()
    }

    fn language_server_command(
        &mut self,
        language_server_id: &LanguageServerId,
        worktree: &Worktree,
    ) -> Result<zed::Command> {
        let binary_path = self.language_server_binary_path(language_server_id, worktree)?;

        eprintln!("[DBML Extension] Starting language server: {}", binary_path);

        Ok(zed::Command {
            command: binary_path,
            args: vec![],
            env: Default::default(),
        })
    }
}

zed::register_extension!(DbmlExtension);
