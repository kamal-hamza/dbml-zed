use std::fs;
use zed_extension_api::{self as zed, LanguageServerId, Result, Worktree};

struct DbmlExtension {
    cached_binary_path: Option<String>,
}

impl DbmlExtension {
    fn new() -> Self {
        Self {
            cached_binary_path: None,
        }
    }

    /// Checks if Node.js and npm are available in the system PATH
    fn check_for_node(&self) -> Result<bool> {
        let node_result = zed::Command::new("node")
            .args(vec!["--version".to_string()])
            .output();

        if node_result.is_err() {
            return Ok(false);
        }

        let npm_result = zed::Command::new("npm")
            .args(vec!["--version".to_string()])
            .output();

        Ok(npm_result.is_ok())
    }

    /// Displays a user-friendly notification when Node.js is not found
    fn notify_node_missing(&self, language_server_id: &LanguageServerId) {
        zed::set_language_server_installation_status(
            language_server_id,
            &zed::LanguageServerInstallationStatus::Failed(
                "Node.js is required but not found. Please install Node.js from https://nodejs.org to enable DBML language server features.".to_string()
            ),
        );
    }

    /// Checks if @dbml/cli is installed globally
    fn is_dbml_cli_installed(&self) -> Result<bool> {
        let check_result = zed::Command::new("npm")
            .args(vec![
                "list".to_string(),
                "-g".to_string(),
                "@dbml/cli".to_string(),
                "--depth=0".to_string(),
            ])
            .output()?;

        Ok(check_result.status == Some(0))
    }

    /// Installs @dbml/cli globally using npm
    fn install_dbml_cli(&self, language_server_id: &LanguageServerId) -> Result<()> {
        zed::set_language_server_installation_status(
            language_server_id,
            &zed::LanguageServerInstallationStatus::Downloading,
        );

        let install_result = zed::Command::new("npm")
            .args(vec![
                "install".to_string(),
                "-g".to_string(),
                "@dbml/cli".to_string(),
            ])
            .output()?;

        if install_result.status != Some(0) {
            let stderr = String::from_utf8_lossy(&install_result.stderr);
            let error_msg = format!(
                "Failed to install @dbml/cli: {}. Common solutions:\n\
                 - Check your internet connection\n\
                 - Verify npm is configured correctly\n\
                 - Try running 'npm install -g @dbml/cli' manually\n\
                 - Check npm permissions (you may need sudo on Unix systems)",
                stderr.trim()
            );

            zed::set_language_server_installation_status(
                language_server_id,
                &zed::LanguageServerInstallationStatus::Failed(error_msg.clone()),
            );

            return Err(error_msg.into());
        }

        Ok(())
    }

    /// Gets the path to the npm global installation directory
    fn get_npm_global_root(&self) -> Result<String> {
        let npm_root_result = zed::Command::new("npm")
            .args(vec!["root".to_string(), "-g".to_string()])
            .output()?;

        if npm_root_result.status != Some(0) {
            return Err("Failed to locate npm global root directory".into());
        }

        let npm_root = String::from_utf8_lossy(&npm_root_result.stdout)
            .trim()
            .to_string();

        Ok(npm_root)
    }

    /// Locates the dbml binary in the npm global installation
    fn find_dbml_binary(&self, npm_root: &str) -> Result<String> {
        // Primary path: npm_root/@dbml/cli/bin/dbml
        let primary_path = format!("{}/@dbml/cli/bin/dbml", npm_root);
        if fs::metadata(&primary_path).map_or(false, |stat| stat.is_file()) {
            return Ok(primary_path);
        }

        // Alternative path: npm_root/node_modules/@dbml/cli/bin/dbml
        let alt_path = format!("{}/node_modules/@dbml/cli/bin/dbml", npm_root);
        if fs::metadata(&alt_path).map_or(false, |stat| stat.is_file()) {
            return Ok(alt_path);
        }

        // Try to find via which/where command
        #[cfg(target_os = "windows")]
        let which_cmd = "where";
        #[cfg(not(target_os = "windows"))]
        let which_cmd = "which";

        let which_result = zed::Command::new(which_cmd)
            .args(vec!["dbml".to_string()])
            .output();

        if let Ok(output) = which_result {
            if output.status == Some(0) {
                let path = String::from_utf8_lossy(&output.stdout)
                    .trim()
                    .lines()
                    .next()
                    .unwrap_or("")
                    .to_string();

                if !path.is_empty() && fs::metadata(&path).map_or(false, |stat| stat.is_file()) {
                    return Ok(path);
                }
            }
        }

        Err("@dbml/cli was installed but the binary could not be found. Try running 'npm install -g @dbml/cli' manually.".into())
    }

    /// Main function to get or install the language server binary
    fn language_server_binary_path(
        &mut self,
        language_server_id: &LanguageServerId,
        _worktree: &Worktree,
    ) -> Result<String> {
        // Check cache first
        if let Some(path) = &self.cached_binary_path {
            if fs::metadata(path).map_or(false, |stat| stat.is_file()) {
                return Ok(path.clone());
            } else {
                // Cache is stale, clear it
                self.cached_binary_path = None;
            }
        }

        // Check for Node.js/npm
        if !self.check_for_node()? {
            self.notify_node_missing(language_server_id);
            return Err(
                "Node.js is not installed. The extension will provide syntax highlighting only."
                    .into(),
            );
        }

        zed::set_language_server_installation_status(
            language_server_id,
            &zed::LanguageServerInstallationStatus::CheckingForUpdate,
        );

        // Check if @dbml/cli is installed
        if !self.is_dbml_cli_installed()? {
            // Install it automatically
            self.install_dbml_cli(language_server_id)?;
        }

        // Get npm global root
        let npm_root = self.get_npm_global_root()?;

        // Find the dbml binary
        let binary_path = self.find_dbml_binary(&npm_root)?;

        // Cache the path
        self.cached_binary_path = Some(binary_path.clone());

        zed::set_language_server_installation_status(
            language_server_id,
            &zed::LanguageServerInstallationStatus::None,
        );

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

        Ok(zed::Command {
            command: binary_path,
            args: vec!["lsp".into()],
            env: Default::default(),
        })
    }
}

zed::register_extension!(DbmlExtension);
