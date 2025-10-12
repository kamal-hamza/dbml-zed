# Contributing to DBML Zed Extension

Thank you for your interest in contributing to the DBML Zed Extension! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Making Changes](#making-changes)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Style Guidelines](#style-guidelines)

## Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code. Please be respectful and constructive in all interactions.

## Getting Started

### Prerequisites

- **Rust**: Latest stable version (install via [rustup](https://rustup.rs/))
- **Zed Editor**: Version 0.140.0 or higher
- **Git**: For version control

### Areas for Contribution

We welcome contributions in the following areas:

- 🐛 **Bug Fixes**: Fix issues reported in the issue tracker
- ✨ **New Features**: Add new language server capabilities
- 📚 **Documentation**: Improve README, guides, and code comments
- 🧪 **Testing**: Add test cases and improve test coverage
- 🎨 **Syntax Highlighting**: Enhance Tree-sitter highlighting queries
- 🔧 **Developer Experience**: Improve build scripts and tooling

## Development Setup

1. **Fork the repository** on GitHub

2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR-USERNAME/dbml-zed.git
   cd dbml-zed
   ```

3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/kamal-hamza/dbml-zed.git
   ```

4. **Install dependencies** (Rust target):
   ```bash
   rustup target add wasm32-wasip1
   ```

5. **Build the extension**:
   ```bash
   ./build.sh
   ```

6. **Install locally for testing**:
   ```bash
   mkdir -p ~/.config/zed/extensions/dbml
   cp -r extension/* ~/.config/zed/extensions/dbml/
   ```

## Making Changes

### Creating a Branch

Create a descriptive branch name for your changes:

```bash
git checkout -b feature/add-hover-support
# or
git checkout -b fix/syntax-highlighting-bug
# or
git checkout -b docs/improve-installation-guide
```

### Branch Naming Convention

- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation changes
- `refactor/` - Code refactoring
- `test/` - Test additions or modifications
- `chore/` - Maintenance tasks

### Project Structure

```
dbml-zed/
├── src/
│   └── dbml.rs              # Main extension implementation
├── languages/
│   └── dbml/
│       ├── config.toml      # Language configuration
│       └── highlights.scm   # Syntax highlighting queries
├── extension.toml           # Extension manifest
├── Cargo.toml              # Rust dependencies
├── build.sh                # Build script
└── README.md               # User documentation
```

### Key Files to Understand

1. **`src/dbml.rs`**
   - Extension entry point
   - Language server management
   - Binary installation logic

2. **`languages/dbml/highlights.scm`**
   - Tree-sitter highlighting queries
   - Defines syntax highlighting rules

3. **`extension.toml`**
   - Extension metadata
   - Language server configuration
   - Required capabilities

4. **`languages/dbml/config.toml`**
   - Language settings (tab size, comments, brackets)
   - Auto-formatting options

## Testing

### Manual Testing

1. **Build the extension**:
   ```bash
   ./build.sh
   ```

2. **Install to Zed**:
   ```bash
   mkdir -p ~/.config/zed/extensions/dbml
   cp -r extension/* ~/.config/zed/extensions/dbml/
   ```

3. **Test in Zed**:
   - Open or create a `.dbml` file
   - Test syntax highlighting
   - Test LSP features:
     - Go to definition (F12)
     - Rename symbol (F2)
     - View diagnostics
     - Semantic highlighting

4. **Check logs**:
   - Open Zed's command palette
   - Type "lsp: status" to view language server status
   - Check for errors or warnings

### Test Cases to Consider

- ✅ Extension loads without errors
- ✅ Syntax highlighting works for all DBML constructs
- ✅ Language server installs automatically
- ✅ Go to definition navigates correctly
- ✅ Rename symbol updates all references
- ✅ Diagnostics show syntax errors
- ✅ Works on different operating systems

## Submitting Changes

### Before Submitting

1. **Test your changes thoroughly**
2. **Update documentation** if needed
3. **Ensure code builds without warnings**:
   ```bash
   cargo clippy
   ./build.sh
   ```
4. **Format your code**:
   ```bash
   cargo fmt
   ```

### Creating a Pull Request

1. **Commit your changes**:
   ```bash
   git add .
   git commit -m "feat: add hover support for table definitions"
   ```

2. **Push to your fork**:
   ```bash
   git push origin feature/add-hover-support
   ```

3. **Create a Pull Request** on GitHub:
   - Go to your fork on GitHub
   - Click "Compare & pull request"
   - Fill in the PR template
   - Link any related issues

### Pull Request Guidelines

- **Title**: Use conventional commit format
  - `feat:` for new features
  - `fix:` for bug fixes
  - `docs:` for documentation
  - `refactor:` for code refactoring
  - `test:` for test additions
  - `chore:` for maintenance

- **Description**: Include:
  - What changes were made
  - Why the changes were necessary
  - How to test the changes
  - Any breaking changes
  - Screenshots if applicable

- **Link Issues**: Reference related issues using `#issue-number`

### Example PR Description

```markdown
## Description
Adds hover support to show table and column information when hovering over identifiers.

## Changes
- Added `hover` method to language server
- Updated extension to handle hover requests
- Added documentation strings to hover content

## Testing
1. Open a `.dbml` file in Zed
2. Hover over a table name
3. Verify tooltip shows table information

## Related Issues
Closes #42
```

## Style Guidelines

### Rust Code Style

- Follow standard Rust naming conventions
- Use `cargo fmt` for formatting
- Use `cargo clippy` for linting
- Add comments for complex logic
- Use descriptive variable names

### Example

```rust
// Good
fn find_existing_binary(&self) -> Option<String> {
    let cargo_home = std::env::var("CARGO_HOME")
        .or_else(|_| {
            std::env::var("HOME")
                .map(|home| format!("{}/.cargo", home))
        })
        .unwrap_or_else(|_| ".cargo".to_string());
    
    // ... rest of implementation
}

// Avoid
fn feb(&self) -> Option<String> {
    let ch=std::env::var("CARGO_HOME").or_else(|_|std::env::var("HOME").map(|h|format!("{}/.cargo",h))).unwrap_or_else(|_|".cargo".to_string());
    // ...
}
```

### Documentation

- Add doc comments for public APIs
- Keep README.md up to date
- Document non-obvious code with inline comments
- Provide examples in documentation

### Commit Messages

Follow conventional commit format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

Example:
```
feat(lsp): add hover support for table definitions

Implemented hover provider that shows table information including
columns, indexes, and notes when hovering over table names.

Closes #42
```

## Getting Help

- 💬 **Discussions**: Use GitHub Discussions for questions
- 🐛 **Issues**: Report bugs via GitHub Issues
- 📧 **Email**: Contact maintainer at kamal.hamza@outlook.com

## Recognition

Contributors will be recognized in:
- The README.md contributors section
- Release notes for their contributions
- GitHub's contributor graph

Thank you for contributing to the DBML Zed Extension! 🎉
