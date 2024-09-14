#!/bin/bash
set -e
# basic check
_BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source "${_BASE}/../../scripts/tool.sh"
[ ! tool::pre_install_check ] && exit 1

# basic information
VERSION='v1.12.1'

# functions
function usage() {
    cat <<EOF
Usage: ii $APP [args]

Args
    -i  install
EOF
}

function install() {
    DOWNLOAD_URL="https://github.com/ninja-build/ninja/releases/download/${VERSION}/ninja-linux.zip"

    tool::download $DOWNLOAD_URL $APP $VERSION
    tool::zip_extract $APP $VERSION install
    tool::update_install_link $APP $VERSION
    tool::append_binary_path $APP 
    tool::append_binary_path $APP bin
}

TASK="install"
while getopts ":iv:" opt; do
    case $opt in
    i) TASK="install" ;;
    v) VERSION=$OPTARG ;;
    *) usage ;;
    esac
done

$TASK
