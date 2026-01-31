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
  echo "Installing mise..."
  brew install mise
  echo "mise installation completed!"
}

function install_app() {
  mise install $1@$2
  mise use -g $1@$2
}

function config() {
  echo "Configuring mise applications..."
  install_app golang 1.24.9
  # install_app zellij latest
  install_app python 3.13.3
  install_app cmake 3.31.7
  install_app nodejs latest
  echo "mise configuration completed!"
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