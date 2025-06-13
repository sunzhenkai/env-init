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
  ID="$(tool::os_id)"
  echo "--- install docker ($ID) ---"
  case "$ID" in
  arch)
    sudo pacman -S docker docker-compose docker-buildx
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
    ;;
  *)
    echo "Your system ($ID) is not supported by this script. Please install dependencies manually."
    exit 1
    ;;
  esac
}

TASK="install"
while getopts ":i:" opt; do
  case $opt in
  i) TASK="install" ;;
  *) usage ;;
  esac
done

$TASK
