#!/bin/bash

# Verification script for DBML Zed Extension
# This script verifies that the extension is properly built and ready for installation

set -e

echo "🔍 DBML Zed Extension - Verification Script"
echo "==========================================="
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check functions
check_pass() {
    echo -e "${GREEN}✓${NC} $1"
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Track overall status
all_checks_passed=true

echo "1. Checking prerequisites..."
echo ""

# Check Rust
if command -v rustc &> /dev/null; then
    RUST_VERSION=$(rustc --version)
    check_pass "Rust is installed: $RUST_VERSION"
else
    check_fail "Rust is not installed. Install from https://rustup.rs/"
    all_checks_passed=false
fi

# Check cargo
if command -v cargo &> /dev/null; then
    CARGO_VERSION=$(cargo --version)
    check_pass "Cargo is available: $CARGO_VERSION"
else
    check_fail "Cargo is not available"
    all_checks_passed=false
fi

# Check wasm32-wasip1 target
if rustup target list --installed | grep -q "wasm32-wasip1"; then
    check_pass "wasm32-wasip1 target is installed"
else
    check_warn "wasm32-wasip1 target is not installed (will be installed during build)"
fi

echo ""
echo "2. Checking project structure..."
echo ""

# Check required files
files_to_check=(
    "src/dbml.rs"
    "extension.toml"
    "Cargo.toml"
    "build.sh"
    "languages/dbml/config.toml"
    "languages/dbml/highlights.scm"
    "README.md"
    "LICENSE-MIT"
    "LICENSE-APACHE"
)

for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        check_pass "Found: $file"
    else
        check_fail "Missing: $file"
        all_checks_passed=false
    fi
done

echo ""
echo "3. Checking build output..."
echo ""

# Check if extension has been built
if [ -d "extension" ]; then
    check_pass "Extension directory exists"
    
    if [ -f "extension/extension.wasm" ]; then
        WASM_SIZE=$(du -h extension/extension.wasm | cut -f1)
        check_pass "extension.wasm exists (size: $WASM_SIZE)"
    else
        check_warn "extension.wasm not found. Run ./build.sh to build"
    fi
    
    if [ -f "extension/extension.toml" ]; then
        check_pass "extension.toml copied to extension directory"
    else
        check_warn "extension.toml not in extension directory"
    fi
    
    if [ -d "extension/languages/dbml" ]; then
        check_pass "Language configuration copied"
    else
        check_warn "Language configuration not copied"
    fi
else
    check_warn "Extension directory not found. Run ./build.sh to build"
fi

# Check for distribution package
if [ -f "zed-dbml-extension.zip" ]; then
    ZIP_SIZE=$(du -h zed-dbml-extension.zip | cut -f1)
    check_pass "Distribution package exists (size: $ZIP_SIZE)"
else
    check_warn "Distribution package not found. Run ./build.sh to create"
fi

echo ""
echo "4. Checking language server..."
echo ""

# Check if dbml-language-server is installed
if command -v dbml-language-server &> /dev/null; then
    LS_VERSION=$(dbml-language-server --version 2>&1 || echo "unknown")
    check_pass "dbml-language-server is installed"
    if [[ ! "$LS_VERSION" =~ "unknown" ]]; then
        echo "   Version: $LS_VERSION"
    fi
else
    check_warn "dbml-language-server not found in PATH"
    echo "   This is OK - it will be installed automatically when the extension runs"
fi

# Check cargo bin directory
CARGO_BIN="${CARGO_HOME:-$HOME/.cargo}/bin"
if [ -f "$CARGO_BIN/dbml-language-server" ]; then
    check_pass "Language server binary found in cargo bin"
else
    check_warn "Language server not in cargo bin (will be installed on first use)"
fi

echo ""
echo "5. Documentation check..."
echo ""

docs_to_check=(
    "README.md"
    "CONTRIBUTING.md"
    "CHANGELOG.md"
)

for doc in "${docs_to_check[@]}"; do
    if [ -f "$doc" ]; then
        LINES=$(wc -l < "$doc")
        check_pass "$doc exists ($LINES lines)"
    else
        check_warn "Missing: $doc"
    fi
done

echo ""
echo "==========================================="
echo ""

if [ "$all_checks_passed" = true ]; then
    echo -e "${GREEN}All critical checks passed!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. If you haven't built yet, run: ./build.sh"
    echo "2. Install to Zed:"
    echo "   mkdir -p ~/.config/zed/extensions/dbml"
    echo "   cp -r extension/* ~/.config/zed/extensions/dbml/"
    echo "3. Restart Zed and open a .dbml file"
else
    echo -e "${RED}Some critical checks failed!${NC}"
    echo "Please fix the issues above before proceeding."
    exit 1
fi

echo ""
