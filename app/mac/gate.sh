#!/bin/bash
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
  echo "Installing macOS applications..."
  # font, install
  ii font -i
  # homebrew, install
  ii homebrew -i
  # neovim, install
  ii neovim -i
  # qwen, install
  ii qwen -i
  # nvm, install
  ii nvm -i
  # uv, install
  ii uv -i
  echo "Installation completed!"
}

function config() {
  echo "Configuring macOS applications..."
  # homebrew, config
  brew update
  brew upgrade
  # zsh, config
  ii zsh -c
  # homebrew, config (additional)
  brew cleanup
  echo "Configuration completed!"
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