#!/bin/bash
set -e
# basic check
_BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source "${_BASE}/../../scripts/tool.sh"
[ ! tool::pre_install_check ] && exit 1

# basic information

VERSION='0.10.1'
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
  DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/v${VERSION}/nvim-linux64.tar.gz"
  tool::download $DOWNLOAD_URL $APP $VERSION
  tool::tar_extract $APP $VERSION install
  tool::update_install_link $APP $VERSION
  tool::append_binary_path $APP bin
}

function config() {
  [[ -e "$HOME/.config/nvim" ]] && mv "$HOME/.config/nvim" "$HOME/.config/nvim-$(date +%s)"
  git clone --recursive https://github.com/sunzhenkai/nvim.git "$HOME/.config/nvim"
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
