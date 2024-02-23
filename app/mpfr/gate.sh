#!/bin/bash
set -e
# basic check
_BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source "${_BASE}/../../scripts/tool.sh"
[ ! tool::check_install ] && exit 1

# basic information
VERSION='4.2.1'

# functions
function usage() {
    cat <<EOF
Usage: ii $APP [args]

Args
    -i  install
EOF
}

function install() {
    echo "[$APP] Install from pre-build binary is not support [version=$VERSION]"
}

function build() {
    DOWNLOAD_URL="https://www.mpfr.org/mpfr-current/mpfr-$VERSION.tar.xz"
    tool::download $DOWNLOAD_URL $APP $VERSION
    tool::tar_extract $APP $VERSION build
    source_dir=$(tool::get_extract_dir $APP $VERSION build)
    install_dir=$(tool::get_install_dir $APP $VERSION)
    cd "$source_dir" || exit 1
    gmp_path="$(tool::get_install_dir)/gmp"
    export LIBRARY_PATH=$gmp_path/lib:$LIBRARY_PATH
    export CPFLAGS="-I${gmp_path}/include/gmp.h $CPFLAGS"
    export CFLAGS="-I${gmp_path}/include/gmp.h $CFLAGS"
    export CXXFLAGS="-I${gmp_path}/include/gmp.h $CXXFLAGS"
    export LDFLAGS="-L${gmp_path}/lib $LDFLAGS"
    ./configure --prefix="$install_dir"
    make -j
    make install -j
    tool::update_install_link $APP $VERSION
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
