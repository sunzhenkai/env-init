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
  echo "not impl"
  return 1
}

function config() {
  npm install -g @mermaid-js/mermaid-cli
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
