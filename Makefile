# Makefile for DBML Zed Extension

.PHONY: all build install clean test lint format help verify-component

# Default target
all: build

# Build the extension
build:
	@echo "🔧 Building DBML Zed Extension..."
	@cargo build --release --target wasm32-wasip1

	@echo "🧩 Converting Wasm module to component..."
	@mkdir -p extension/languages/dbml
	# RUST_LOG=trace wasm-tools component new target/wasm32-wasip1/release/zed_dbml.wasm -o extension/extension.wasm
	@cp extension.toml extension/
	@cp -r languages/dbml/* extension/languages/dbml/
	@echo "✅ Build complete!"

# Install to Zed extensions directory (Unix/macOS)
install: build
	@echo "📦 Installing to Zed..."
	@mkdir -p $(HOME)/.config/zed/extensions/dbml
	@cp -r extension/* $(HOME)/.config/zed/extensions/dbml/
	@echo "✅ Installed! Restart Zed to load the extension."

# Install to Zed extensions directory (Windows)
install-windows: build
	@echo "📦 Installing to Zed (Windows)..."
	@mkdir -p $(APPDATA)/Zed/extensions/dbml
	@cp -r extension/* $(APPDATA)/Zed/extensions/dbml/
	@echo "✅ Installed! Restart Zed to load the extension."

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	@cargo clean
	@rm -rf extension/
	@rm -f zed-dbml-extension.zip
	@echo "✅ Clean complete!"

# Run tests
test:
	@echo "🧪 Running tests..."
	@cargo test
	@echo "✅ Tests complete!"

# Lint with clippy
lint:
	@echo "🔍 Running clippy..."
	@cargo clippy -- -D warnings
	@echo "✅ Lint complete!"

# Format code
format:
	@echo "✨ Formatting code..."
	@cargo fmt
	@echo "✅ Format complete!"

# Check formatting
format-check:
	@echo "🔍 Checking code formatting..."
	@cargo fmt -- --check
	@echo "✅ Format check complete!"

# Create distribution package
package: build
	@echo "📦 Creating distribution package..."
	@cd extension && zip -r ../zed-dbml-extension.zip . -q
	@echo "✅ Package created: zed-dbml-extension.zip"

# Verify the extension structure
verify:
	@echo "🔍 Verifying extension structure..."
	@test -f extension/extension.wasm || (echo "❌ extension.wasm not found" && exit 1)
	@test -f extension/extension.toml || (echo "❌ extension.toml not found" && exit 1)
	@test -f extension/languages/dbml/config.toml || (echo "❌ config.toml not found" && exit 1)
	@test -f extension/languages/dbml/highlights.scm || (echo "❌ highlights.scm not found" && exit 1)
	@echo "✅ Extension structure verified!"

# Verify that the built wasm is a valid component
verify-component:
	@echo "🔍 Checking if extension.wasm is a valid component..."
	@wasm-tools print extension/extension.wasm | grep -q "(component" && echo "✅ Valid WebAssembly component!" || (echo "❌ Not a component!" && exit 1)

# Development watch mode (requires cargo-watch)
watch:
	@echo "👀 Watching for changes..."
	@cargo watch -x 'build --release --target wasm32-wasip1' -s 'make install'

# Check if required tools are installed
check-tools:
	@echo "🔍 Checking required tools..."
	@command -v rustc >/dev/null 2>&1 || (echo "❌ Rust not installed" && exit 1)
	@command -v cargo >/dev/null 2>&1 || (echo "❌ Cargo not installed" && exit 1)
	@rustup target list --installed | grep -q wasm32-wasip1 || (echo "❌ wasm32-wasip1 target not installed. Run: rustup target add wasm32-wasip1" && exit 1)
	@command -v wasm-tools >/dev/null 2>&1 || (echo "❌ wasm-tools not installed. Run: cargo install wasm-tools" && exit 1)
	@command -v node >/dev/null 2>&1 || echo "⚠️  Node.js not installed (optional for language server)"
	@command -v npm >/dev/null 2>&1 || echo "⚠️  npm not installed (optional for language server)"
	@echo "✅ All required tools are installed!"

# Install wasm32-wasip1 target
install-wasm-target:
	@echo "📦 Installing wasm32-wasip1 target..."
	@rustup target add wasm32-wasip1
	@echo "✅ wasm32-wasip1 target installed!"

# Show help
help:
	@echo "DBML Zed Extension - Available Commands"
	@echo ""
	@echo "  make build               - Build the extension"
	@echo "  make install             - Build and install to Zed (Unix/macOS)"
	@echo "  make install-windows     - Build and install to Zed (Windows)"
	@echo "  make clean               - Remove build artifacts"
	@echo "  make test                - Run tests"
	@echo "  make lint                - Run clippy linter"
	@echo "  make format              - Format code with rustfmt"
	@echo "  make format-check        - Check code formatting"
	@echo "  make package             - Create distribution zip"
	@echo "  make verify              - Verify extension structure"
	@echo "  make verify-component    - Check if built wasm is a valid component"
	@echo "  make watch               - Watch and rebuild on changes"
	@echo "  make check-tools         - Check if required tools are installed"
	@echo "  make install-wasm-target - Install wasm32-wasip1 target"
	@echo "  make help                - Show this help message"
	@echo ""
