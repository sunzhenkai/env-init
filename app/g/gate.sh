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
    -i install
    -u update
EOF
}

function install() {
  curl -sSL https://git.io/g-install | bash
}

function config() {
}

function update() {
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
}

TASK="install"
while getopts ":icu:" opt; do
  case $opt in
  i) TASK="install" ;;
  c) TASK="config" ;;
  u) TASK="update" ;;
  *) usage ;;
  esac
done

$TASK
