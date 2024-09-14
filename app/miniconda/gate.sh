#!/bin/bash
# APP: setted in parent scope

set -e
# basic check
_BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source "${_BASE}/../../scripts/tool.sh"
[ ! tool::pre_install_check ] && exit 1

# functions
function usage() {
    cat <<EOF
Usage: ii miniconda [args]

Args
    -i  install
    -e  new environment name
EOF
}

function config() {
    [[ -z "$ENV_NAME" ]] && FATAL "empty ENV_NAME"

    local INSTALL_DIR=$(tool::get_install_dir $APP $VERSION)
    if [[ -e "$INSTALL_DIR" ]]; then
        ${INSTALL_DIR}/bin/conda create -n $ENV_NAME --channel=conda-forge
    else
        conda create -n $ENV_NAME --channel=conda-forge
    fi
    tool::append_to_env_profile "conda activate $ENV_NAME"
}

function install() {
    local DOWNLOAD_URL=https://repo.anaconda.com/miniconda/Miniconda3-${VERSION}-Linux-x86_64.sh
    local DOWNLOAD_FILE=$(tool::get_download_file $APP $VERSION)
    local INSTALL_DIR=$(tool::get_install_dir $APP $VERSION)

    tool::download $DOWNLOAD_URL $APP $VERSION
    mkdir -p ${INSTALL_DIR}
    bash ${DOWNLOAD_FILE} -b -u -p ${INSTALL_DIR}
    rm ${DOWNLOAD_FILE}

    command -v bash >/dev/null && ${CONDA_DIR}/bin/conda init bash
    command -v zsh >/dev/null && ${CONDA_DIR}/bin/conda init zsh

    tool::append_binary_path $APP bin
    config
}

function build() {
    echo "[$APP] Build is not support [version=$VERSION]"
    exit 1
}

TASK="usage"
VERSION=latest
while getopts ":ib:e:v:" opt; do
    case $opt in
    i) TASK="install" ;;
    b) TASK="build" ;;
    e) ENV_NAME=$OPTARG ;;
    v) VERSION=$OPTARG ;;
    *) usage ;;
    esac
done

$TASK