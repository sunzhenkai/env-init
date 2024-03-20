#!/bin/bash
set -e
# basic check
_BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source "${_BASE}/../../scripts/tool.sh"
[ ! tool::check_install ] && exit 1

# basic information
VERSION='v0.0.1'

# functions
function usage() {
    cat <<EOF
Usage: ii $APP [args]

Args
    -i  install
EOF
}

function install() {
    echo "[$APP] Install. [version=$VERSION]"
    tool::download_github_release $APP sunzhenkai $APP $VERSION
    tool::tar_extract $APP $VERSION build
    tool::mv_by_stage $APP $VERSION build
}

TASK="install"
while getopts ":ibv:" opt; do
    case $opt in
    i) TASK="install" ;;
    v) VERSION=$OPTARG ;;
    *) usage ;;
    esac
done

$TASK