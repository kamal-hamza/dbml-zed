# Changelog

All notable changes to the DBML Zed Extension will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned Features
- Hover support for showing table and column information
- Code completion for table and column names
- Document formatting support
- Code snippets for common DBML patterns
- Support for workspace symbols

## [0.1.0] - 2025-10-11

### Added
- 🎉 Initial release of DBML Zed Extension
- ✨ Full syntax highlighting via Tree-sitter grammar
- 🔍 Go to Definition support for tables and enums
- 🔄 Rename Symbol support for tables, columns, and enums
- 🎨 Semantic token highlighting for enhanced readability
- 🚨 Real-time diagnostics and error reporting
- 📦 Automatic language server installation from crates.io
- 📚 Comprehensive documentation and examples
- 🔧 Cross-platform support (macOS, Linux, Windows)
- ⚙️ Automatic detection and installation of Rust toolchain requirements

### Language Server Features
- Full DBML parsing and validation
- Symbol table for tracking tables, columns, and enums
- Relationship validation
- Type checking for column references
- Syntax error detection and reporting

### Developer Experience
- Automatic installation on first use
- Clear error messages and troubleshooting guides
- Detailed logging for debugging
- Build script for easy development

### Documentation
- Complete README with installation instructions
- Contributing guidelines
- Troubleshooting section
- Example DBML files
- API documentation for developers

## Release Notes

### Version 0.1.0 - Initial Release

This is the first stable release of the DBML Zed Extension. It provides comprehensive support for DBML files in the Zed editor with the following highlights:

**Key Features:**
- Full syntax highlighting using the Tree-sitter grammar
- Language Server Protocol (LSP) integration for intelligent code features
- Automatic installation and management of the language server
- Cross-platform support

**Language Server:**
- Built with Rust for performance and reliability
- Published to crates.io as `dbml-language-server`
- Provides diagnostics, go-to-definition, and rename capabilities
- Semantic tokens for enhanced syntax highlighting

**Getting Started:**
1. Install Rust if not already installed: https://rustup.rs/
2. Install the extension in Zed
3. Open a `.dbml` file
4. The language server will install automatically

**Known Limitations:**
- No hover support yet (planned for 0.2.0)
- No code completion yet (planned for 0.2.0)
- No formatting support yet (planned for 0.3.0)

**Feedback:**
Please report any issues or feature requests on GitHub:
https://github.com/kamal-hamza/dbml-zed/issues

---

## Future Roadmap

### Version 0.2.0 (Planned)
- Hover support with documentation
- Code completion for tables and columns
- Signature help for relationships
- Improved diagnostics with quick fixes

### Version 0.3.0 (Planned)
- Document formatting
- Code folding support
- Workspace symbols
- Document symbols outline

### Version 0.4.0 (Planned)
- Code snippets
- Refactoring commands
- Import/export validation
- Schema visualization integration

---

[Unreleased]: https://github.com/kamal-hamza/dbml-zed/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/kamal-hamza/dbml-zed/releases/tag/v0.1.0
