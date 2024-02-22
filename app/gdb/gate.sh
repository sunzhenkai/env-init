#!/bin/bash
set -e
# basic check
_BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source "${_BASE}/../../scripts/tool.sh"
[ ! tool::check_install ] && exit 1

# basic information
VERSION='14.1'

# functions
function usage() {
    cat <<EOF
Usage: ii gdb [args]

Args
    -i  install
EOF
}

function install() {
    echo "[$APP] Install [version=$VERSION]"
}

function clean() {
    echo "[$APP] clean."
}

function build() {
    DOWNLOAD_URL="https://ftp.gnu.org/gnu/gdb/gdb-$VERSION.tar.gz"
    tool::download $DOWNLOAD_URL $APP $VERSION
    tool::tar_extract $APP $VERSION build
    source_dir=$(tool::get_extract_dir $APP $VERSION build)
    install_dir=$(tool::get_install_dir $APP $VERSION)
    cd "$source_dir" || exit 1
    ./configure \
        --with-gmp="$(tool::get_root_install_dir)/gmp" \
        --with-mpfr="$(tool::get_root_install_dir)/mpfr" \
        --prefix="$install_dir"
    make -j
    make install -j
    ln -s "$install_dir" "$(tool::get_root_install_dir)/$APP"
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