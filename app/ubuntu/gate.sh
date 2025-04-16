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
  echo "install: not implement"
}

function config() {
  RELEASE=$(lsb_release -a | grep Release)
  if [[ "$RELEASE" =~ "22.04" ]]; then
    GCC_VERSION=11
  else
    GCC_VERSION=13
  fi
  sudo apt install -y tmux curl wget pkg-config gcc g++ zsh
  sudo apt install -y git autoconf automake binutils bison findutils flex gawk
  sudo apt install -y gcc-$GCC_VERSION g++-$GCC_VERSION gettext grep gzip libtool m4 make patch pkgconf sed texinfo
  sudo apt install -y python3-pip python3-virtualenv python3-venv
  sudo apt install -y gdb wget curl vim zip unzip tar xz-utils
  sudo apt install -y build-essential procps patch
  sudo apt install -y imagemagick libmagickwand-dev
  sudo ln -fs /usr/bin/gcc-$GCC_VERSION /usr/bin/gcc
  sudo ln -fs /usr/bin/g++-$GCC_VERSION /usr/bin/g++

  # env
  pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
}

TASK="install"
while getopts ":icv:" opt; do
  case $opt in
  c) TASK="config" ;;
  v) VERSION=$OPTARG ;;
  *) usage ;;
  esac
done

$TASK
