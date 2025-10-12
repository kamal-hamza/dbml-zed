#!/bin/bash

# Installation script for DBML Zed Extension
# Installs the extension to the Zed extensions directory

set -e

echo "📦 DBML Zed Extension - Installation Script"
echo "=========================================="
echo ""

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Determine the Zed extensions directory based on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    ZED_EXTENSIONS_DIR="$HOME/Library/Application Support/Zed/extensions"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    ZED_EXTENSIONS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zed/extensions"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    # Windows
    ZED_EXTENSIONS_DIR="$APPDATA/Zed/extensions"
else
    echo -e "${YELLOW}⚠${NC} Unknown OS type: $OSTYPE"
    echo "Please manually install to your Zed extensions directory"
    exit 1
fi

DBML_EXTENSION_DIR="$ZED_EXTENSIONS_DIR/dbml"

echo -e "${BLUE}ℹ${NC} Target directory: $DBML_EXTENSION_DIR"
echo ""

# Check if extension is built
if [ ! -d "extension" ] || [ ! -f "extension/extension.wasm" ]; then
    echo -e "${YELLOW}⚠${NC} Extension not built. Building now..."
    ./build.sh
    echo ""
fi

# Create Zed extensions directory if it doesn't exist
if [ ! -d "$ZED_EXTENSIONS_DIR" ]; then
    echo "Creating Zed extensions directory..."
    mkdir -p "$ZED_EXTENSIONS_DIR"
fi

# Check if extension is already installed
if [ -d "$DBML_EXTENSION_DIR" ]; then
    echo -e "${YELLOW}⚠${NC} DBML extension is already installed."
    read -p "Do you want to overwrite it? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    echo "Removing old installation..."
    rm -rf "$DBML_EXTENSION_DIR"
fi

# Create extension directory
echo "Creating extension directory..."
mkdir -p "$DBML_EXTENSION_DIR"

# Copy extension files
echo "Copying extension files..."
cp -r extension/* "$DBML_EXTENSION_DIR/"

# Verify installation
if [ -f "$DBML_EXTENSION_DIR/extension.wasm" ]; then
    echo ""
    echo -e "${GREEN}✓${NC} Installation successful!"
    echo ""
    echo "Extension installed to: $DBML_EXTENSION_DIR"
    echo ""
    echo "Next steps:"
    echo "1. Restart Zed editor"
    echo "2. Open a .dbml file"
    echo "3. The language server will install automatically on first use"
    echo ""
    echo "To test the extension:"
    echo "  zed test.dbml"
    echo ""
else
    echo -e "${RED}✗${NC} Installation failed!"
    echo "Extension files were not copied correctly."
    exit 1
fi
