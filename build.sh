#!/bin/bash

# Build script for DBML Zed Extension
# This script builds the extension and prepares it for installation

set -e  # Exit on error

echo "🔧 Building DBML Zed Extension..."

# Check if Rust is installed
if ! command -v rustc &> /dev/null; then
    echo "❌ Error: Rust is not installed. Please install Rust from https://rustup.rs/"
    exit 1
fi

# Check if wasm32-wasip1 target is installed
if ! rustup target list --installed | grep -q "wasm32-wasip1"; then
    echo "📦 Installing wasm32-wasip1 target..."
    rustup target add wasm32-wasip1
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
cargo clean

# Build the extension
echo "🏗️  Building extension (this may take a moment)..."
cargo build --release --target wasm32-wasip1

# Check if build was successful
if [ ! -f "target/wasm32-wasip1/release/zed_dbml.wasm" ]; then
    echo "❌ Build failed: WASM file not found"
    exit 1
fi

# Create extension directory structure
echo "📁 Creating extension directory structure..."
mkdir -p extension
mkdir -p extension/languages/dbml

# Copy files to extension directory
echo "📋 Copying extension files..."
cp target/wasm32-wasip1/release/zed_dbml.wasm extension/extension.wasm
cp extension.toml extension/
cp -r languages/dbml/* extension/languages/dbml/

# Create a zip file for distribution
echo "📦 Creating distribution package..."
cd extension
zip -r ../zed-dbml-extension.zip . -q
cd ..

echo "✅ Build complete!"
echo ""
echo "Extension files are in the 'extension' directory"
echo "Distribution package: zed-dbml-extension.zip"
echo ""
echo "To install in Zed:"
echo "1. Open Zed"
echo "2. Navigate to ~/.config/zed/extensions/ (or equivalent on your OS)"
echo "3. Create a 'dbml' directory"
echo "4. Copy the contents of the 'extension' directory there"
echo "5. Restart Zed"
