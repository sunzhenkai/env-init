#!/bin/bash
# basic check
_BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source "${_BASE}/../../scripts/tool.sh"
[ ! tool::pre_install_check ] && exit 1

# basic information

# Define applications and their versions
declare -a ASDF_APPS=(
  "golang:1.24.9"
  "python:3.13.3"
  "cmake:3.31.7"
  "nodejs:latest"
)

# functions
function usage() {
  cat <<EOF
Usage: ii $APP [args]

Args
    -i  install
    -c  config
    -u  uninstall
EOF
}

function install() {
  brew install asdf
}

function install_app() {
  asdf plugin add $1
  asdf install $1 $2
  asdf set -u $1 $2
}

function uninstall_app() {
  if asdf plugin list | grep -q "^$1$"; then
    echo "Uninstalling $1..."
    asdf uninstall $1 --all
    asdf plugin remove $1
    echo "$1 uninstalled successfully!"
  else
    echo "$1 is not installed via asdf"
  fi
}

function config() {
  for app_info in "${ASDF_APPS[@]}"; do
    app=$(echo $app_info | cut -d':' -f1)
    version=$(echo $app_info | cut -d':' -f2)
    install_app $app $version
  done
}

function uninstall() {
  echo "Uninstalling asdf and its installed applications..."
  if command -v asdf >/dev/null; then
    for app_info in "${ASDF_APPS[@]}"; do
      app=$(echo $app_info | cut -d':' -f1)
      echo "Uninstalling $app..."
      uninstall_app $app
    done
    brew uninstall asdf
    echo "asdf and its applications uninstalled successfully!"
  else
    echo "asdf is not installed"
  fi
}

TASK="install"
while getopts ":icuv:" opt; do
  case $opt in
  i) TASK="install" ;;
  c) TASK="config" ;;
  u) TASK="uninstall" ;;
  v) VERSION=$OPTARG ;;
  *) usage ;;
  esac
done

$TASK
