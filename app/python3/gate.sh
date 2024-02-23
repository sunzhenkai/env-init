#!/bin/bash
set -e
# basic check
_BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source "${_BASE}/../../scripts/tool.sh"
[ ! tool::check_install ] && exit 1

# basic information
VERSION='3.12.2'

# functions
function usage() {
    cat <<EOF
Usage: ii $APP [args]

Args
    -i  install
    -b  build from source
    -v  set version
EOF
}

function install() {
    echo "[$APP] Install from pre-build binary is not support [version=$VERSION]"
}

function clean() {
    echo "[$APP] clean."
}

function build() {
    DOWNLOAD_URL="https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tar.xz"
    tool::download $DOWNLOAD_URL $APP $VERSION
    tool::tar_extract $APP $VERSION build
    source_dir=$(tool::get_extract_dir $APP $VERSION build)
    install_dir=$(tool::get_install_dir $APP $VERSION)
    cd "$source_dir" || exit 1
    ./configure --with-pydebug --prefix="$install_dir"
    make -j
    make install -j
    tool::update_install_link $APP $VERSION
    tool::append_binary_path $APP bin
    clean
    exit 0
}

TASK="install"
while getopts ":ibv:" opt; do
    case $opt in
    i) TASK="install" ;;
    b) TASK="build" ;;
    v) VERSION=$OPTARG ;;
    *) usage ;;
    esac
done

$TASK