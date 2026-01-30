#!/bin/bash
# url: https://github.com/subframe7536/maple-font/releases/download/v7.9/MapleMono-CN-unhinted.zip
set -e
# basic check
_BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source "${_BASE}/../../scripts/tool.sh"
[ ! tool::pre_install_check ] && exit 1

# basic information
# functions
function usage() {
  cat <<EOF
Usage: ii $APP [args]

Args
    -i  install
    -c  config
EOF
}

function install() {
    local FONT_URL="https://github.com/subframe7536/maple-font/releases/download/v7.9/MapleMono-NF-CN-unhinted.zip"
    
    local TEMP_DIR=$(mktemp -d)
    local FONT_DIR
    
    echo "Downloading font file..."
    curl -L -o "${TEMP_DIR}/MapleMono-CN-unhinted.zip" "${FONT_URL}"
    
    echo "Extracting font file..."
    unzip "${TEMP_DIR}/MapleMono-CN-unhinted.zip" -d "${TEMP_DIR}"
    
    # Detect system and set font directory
    if [[ "$(uname)" == "Darwin" ]]; then
        # macOS
        FONT_DIR="$HOME/Library/Fonts"
    elif [[ -f "/etc/lsb-release" ]] && grep -q "Ubuntu" "/etc/lsb-release"; then
        # Ubuntu
        FONT_DIR="$HOME/.local/share/fonts"
        mkdir -p "${FONT_DIR}"
    elif [[ -f "/etc/arch-release" ]]; then
        # Arch Linux
        FONT_DIR="$HOME/.local/share/fonts"
        mkdir -p "${FONT_DIR}"
    else
        echo "Unsupported system"
        rm -rf "${TEMP_DIR}"
        exit 1
    fi
    
    echo "Installing fonts to ${FONT_DIR}..."
    find "${TEMP_DIR}" -name "*.ttf" -o -name "*.otf" | xargs -I {} cp "{}" "${FONT_DIR}/"
    
    # Refresh font cache for Linux systems
    if [[ "$(uname)" != "Darwin" ]]; then
        echo "Refreshing font cache..."
        fc-cache -f -v
    fi
    
    echo "Font installation completed successfully!"
    rm -rf "${TEMP_DIR}"
}

function config() {
  :
}

TASK="install"
while getopts ":icv:" opt; do
  case $opt in
  i) TASK="install" ;;
  c) TASK="config" ;;
  v) VERSION=$OPTARG ;;
  *) usage ;;
  esac
done

$TASK