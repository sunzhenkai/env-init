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
    -c  config
EOF
}

function install() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/sunzhenkai/vcpkg-base/main/scripts/install_vcpkg_pure.sh)"
  tool::append_to_env_profile "export VCPKG_ROOT=${HOME}/.local/vcpkg"
  tool::append_to_env_profile "export PATH=${VCPKG_ROOT}:$PATH"
}

function config() {
  echo "config: not implement"
}

TASK="install"
while getopts ":icv:" opt; do
  case $opt in
  i) TASK="install" ;;
  v) VERSION=$OPTARG ;;
  *)
    usage
    TASK="notask"
    ;;
  esac
done

$TASK
