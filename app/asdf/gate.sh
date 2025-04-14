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
  brew instal asdf
}

function install_app() {
  asdf plugin add $1
  asdf install $1 $2
  asdf set -u $1 $2
}

function config() {
  install_app golang latest
  install_app zellij latest
  install_app python 3.13.3
  install_app cmake 3.31.7
  install_app nodejs latest
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
