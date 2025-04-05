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
  # homebrew
  if ! command -v brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo >>$HOME/.zshrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>$HOME/.zshrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
}

function config() {
  brew install openjdk@17 cmake ninja bison flex htop nvim go ripgrep
  # yazi
  brew install yazi ffmpeg sevenzip jq poppler fd ripgrep fzf zoxide imagemagick font-symbols-only-nerd-font
  brew install lazygit gitui
  brew install gotests
  brew install nushell fish starship
  echo "" >>~/.zshrc
  echo 'eval "$(starship init zsh)"' >>~/.zshrc
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
