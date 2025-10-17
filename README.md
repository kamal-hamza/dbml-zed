# DBML Zed Extension

A comprehensive [Zed](https://zed.dev) extension for [DBML (Database Markup Language)](https://dbml.dbdiagram.io/) with full Language Server Protocol (LSP) support.

## Features

**Syntax Highlighting** - Full syntax highlighting for DBML files via Tree-sitter grammar (Highlights from [Helix DBML](https://github.com/helix-editor/helix/blob/c9b484097b045a34b709131fc62e87ba21789d1a/runtime/queries/dbml/highlights.scm)).
**Go to Definition** - Jump to table and enum definitions.
**Rename Symbol** - Rename tables, columns, and enums throughout your project.
**Semantic Tokens** - Advanced semantic highlighting for better code readability.
**Diagnostics** - Real-time error detection and reporting.
**IntelliSense** - Code completion and intelligent suggestions.

## Requirements

- **Rust Toolchain**: The extension requires the Rust toolchain (cargo) to install the language server
- **Zed Editor**: Version 0.140.0 or higher

## Installation

### Prerequisites

First, ensure you have the Rust toolchain installed:

```bash
# Install Rust via rustup (if not already installed)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Verify installation
cargo --version
```

### Install the Extension

#### Option 1: Install from Zed Extensions (Coming Soon)

Once published to the Zed extensions marketplace:

1. Open Zed
2. Open the command palette (`Cmd+Shift+P` on macOS, `Ctrl+Shift+P` on Linux/Windows)
3. Type "zed: extensions" and select it
4. Search for "DBML"
5. Click "Install"

#### Option 2: Manual Installation (Current Method)

1. **Clone or download this repository**

```bash
git clone https://github.com/kamal-hamza/dbml-zed.git
cd dbml-zed
```

2. **Build the extension**

```bash
./build.sh
```

3. **Install to Zed**

```bash
# On macOS/Linux
mkdir -p ~/.config/zed/extensions/dbml
cp -r extension/* ~/.config/zed/extensions/dbml/

# On Windows
# mkdir %APPDATA%\Zed\extensions\dbml
# xcopy /E /I extension %APPDATA%\Zed\extensions\dbml
```

4. **Restart Zed**

Close and reopen Zed for the extension to be loaded.

### First-Time Setup

On the first time you open a `.dbml` file:

1. The extension will automatically detect if the language server is installed
2. If not found, it will automatically install `dbml-language-server` from [crates.io](https://crates.io/crates/dbml-language-server)
3. This process may take a few minutes on the first run

You can monitor the installation progress in Zed's LSP panel:

- Open the command palette
- Type "lsp: status" and select it

## Usage

### Supported File Extensions

- `.dbml` - DBML database schema files

### Example DBML File

Create a file named `schema.dbml`:

```dbml
// Define a table
Table users {
  id integer [primary key]
  username varchar(255) [not null, unique]
  email varchar(255) [not null, unique]
  created_at timestamp [default: `now()`]
  role user_role [not null, default: 'user']
}

// Define an enum
Enum user_role {
  admin
  moderator
  user
}

// Define a table with foreign key
Table posts {
  id integer [primary key]
  title varchar(255) [not null]
  content text
  user_id integer [ref: > users.id]
  created_at timestamp [default: `now()`]
}

// Define relationships
Ref: posts.user_id > users.id [delete: cascade]
```

### Language Server Features

#### Go to Definition

- Place cursor on a table name or enum name
- Press `F12` or right-click and select "Go to Definition"
- Jump directly to the definition

#### Rename Symbol

- Place cursor on a table name, column name, or enum name
- Press `F2` or right-click and select "Rename Symbol"
- Type the new name and press Enter
- All references will be updated

#### Diagnostics

- Syntax errors are highlighted in real-time
- Hover over errors to see detailed messages
- Check the Problems panel for a list of all issues

#### Semantic Highlighting

- Keywords: `Table`, `Enum`, `Ref`, etc.
- Table names highlighted differently from columns
- Enum names and members have distinct colors
- Data types stand out for quick identification

## Language Server Architecture

This extension uses the [`dbml-language-server`](https://crates.io/crates/dbml-language-server), a Rust-based LSP implementation that provides:

- **Fast parsing** - Written in Rust using the [Chumsky](https://github.com/zesterer/chumsky) parser combinator library
- **Incremental analysis** - Only re-analyzes changed files
- **Low memory footprint** - Efficient data structures for large schemas
- **Cross-platform** - Works on macOS, Linux, and Windows

### Language Server Installation

The extension automatically manages the language server installation:

1. **Check**: Looks for an existing `dbml-language-server` binary in:
    - `~/.cargo/bin/` (default cargo install location)
    - System PATH

2. **Install**: If not found, runs:

    ```bash
    cargo install dbml-language-server --version 0.1.0
    ```

3. **Cache**: Remembers the installation location for faster startup

## Troubleshooting

### Language Server Not Starting

**Symptom**: No LSP features (go to definition, diagnostics, etc.)

**Solution**:

1. Check that Rust is installed: `cargo --version`
2. Try manually installing the language server:
    ```bash
    cargo install dbml-language-server --version 0.1.0 --force
    ```
3. Check Zed's LSP logs:
    - Open command palette → "lsp: status"
    - Look for any error messages

### Extension Not Loading

**Symptom**: DBML files have no syntax highlighting

**Solution**:

1. Verify the extension is installed:
    ```bash
    ls ~/.config/zed/extensions/dbml
    ```
2. Check for the following files:
    - `extension.toml`
    - `extension.wasm`
    - `languages/dbml/config.toml`
3. Restart Zed

### Build Errors

**Symptom**: `./build.sh` fails

**Solution**:

1. Ensure Rust is up to date:
    ```bash
    rustup update
    ```
2. Install the wasm32-wasip1 target:
    ```bash
    rustup target add wasm32-wasip1
    ```
3. Clean and rebuild:
    ```bash
    cargo clean
    ./build.sh
    ```

## Development

### Building from Source

```bash
# Clone the repository
git clone https://github.com/kamal-hamza/dbml-zed.git
cd dbml-zed

# Build the extension
./build.sh

# The built extension will be in the 'extension' directory
```

### Project Structure

```
dbml-zed/
├── src/
│   └── dbml.rs              # Extension implementation
├── languages/
│   └── dbml/
│       ├── config.toml      # Language configuration
│       └── highlights.scm   # Syntax highlighting queries
├── extension.toml           # Extension manifest
├── Cargo.toml              # Rust dependencies
└── build.sh                # Build script
```

### Testing

```bash
# Run tests (when available)
cargo test

# Test the extension in Zed
# 1. Build the extension
./build.sh

# 2. Install locally
mkdir -p ~/.config/zed/extensions/dbml
cp -r extension/* ~/.config/zed/extensions/dbml/

# 3. Open a .dbml file in Zed
zed test.dbml
```

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

### Areas for Contribution

- 🐛 Bug fixes
- ✨ New features
- 📚 Documentation improvements
- 🧪 Test coverage
- 🎨 Improved syntax highlighting

### Development Guidelines

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Related Projects

- **[dbml-language-server](https://github.com/kamal-hamza/dbml-language-server)** - The LSP implementation
- **[tree-sitter-dbml](https://github.com/dynamotn/tree-sitter-dbml)** - Tree-sitter grammar for DBML
- **[DBML Documentation](https://dbml.dbdiagram.io/)** - Official DBML documentation

## License

This project is licensed under either of:

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE) or http://www.apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

at your option.

## Credits

- **Author**: Hamza Kamal (kamal.hamza@outlook.com)
- **Language Server**: Built with [tower-lsp](https://github.com/ebkalderon/tower-lsp)
- **Grammar**: Based on [tree-sitter-dbml](https://github.com/dynamotn/tree-sitter-dbml)
- **Editor**: Built for [Zed](https://zed.dev)

## Changelog

### Version 0.1.0 (2025-10-11)

- 🎉 Initial release
- ✨ Syntax highlighting via Tree-sitter
- 🔍 Go to definition support
- 🔄 Rename symbol support
- 🎨 Semantic token highlighting
- 🚨 Real-time diagnostics
- 📦 Automatic language server installation
