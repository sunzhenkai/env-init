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
  # nvm
  if ! command -v nvm; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    # echo '' >>~/.zshrc
    # echo 'export NVM_DIR="$HOME/.nvm"' >>~/.zshrc
    # echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' >>~/.zshrc
    # echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >>~/.zshrc
    # source ~/.zshrc
  fi
  if [ "$NVM_DIR" == "" ]; then
    export NVM_DIR="$HOME/.nvm"
    . "$NVM_DIR/nvm.sh"
  fi
  nvm install --lts
  npm install -g yarn
}

function config() {
  echo "config"
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
