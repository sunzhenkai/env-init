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
EOF
}

function install() {
  if command -v brew; then
    brew install qwen-code
  elif command -v npm; then
    npm install -g @qwen-code/qwen-code@latest
  fi
}

TASK="install"
while getopts ":icv:" opt; do
  case $opt in
  i) TASK="install" ;;
  *) usage ;;
  esac
done

$TASK
