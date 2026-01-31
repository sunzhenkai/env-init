#!/bin/bash
# basic check
_BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source "${_BASE}/../../scripts/tool.sh"
[ ! tool::pre_install_check ] && exit 1

# basic information

# Define applications and their versions
declare -a MISE_APPS=(
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
  echo "Installing mise..."
  brew install mise
  echo "mise installation completed!"
}

function install_app() {
  mise install $1@$2
  mise use -g $1@$2
}

function uninstall_app() {
  if mise list | grep -q "^$1"; then
    echo "Uninstalling $1..."
    mise uninstall $1@$2
    echo "$1 uninstalled successfully!"
  else
    echo "$1 is not installed via mise"
  fi
}

function config() {
  echo "Configuring mise applications..."
  for app_info in "${MISE_APPS[@]}"; do
    app=$(echo $app_info | cut -d':' -f1)
    version=$(echo $app_info | cut -d':' -f2)
    install_app $app $version
  done
  echo "mise configuration completed!"
}

function uninstall() {
  echo "Uninstalling mise and its installed applications..."
  if command -v mise >/dev/null; then
    for app_info in "${MISE_APPS[@]}"; do
      app=$(echo $app_info | cut -d':' -f1)
      version=$(echo $app_info | cut -d':' -f2)
      echo "Uninstalling $app..."
      uninstall_app $app $version
    done
    brew uninstall mise
    echo "mise and its applications uninstalled successfully!"
  else
    echo "mise is not installed"
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