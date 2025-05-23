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
    -i  install
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
  # utils
  brew install watch fswatch
  brew install htop wget curl
  brew install bat the_silver_searcher perl universal-ctags
  brew install luarocks hunspell tectonic ghostscript
  brew install yazi ffmpeg sevenzip jq poppler zoxide imagemagick chafa resvg
  #brew install font-symbols-only-nerd-font
  brew install pngpaste
  brew install asdf
  brew install tmux zsh
  # shell
  brew install nushell fish starship
  # git
  brew install lazygit gitui
  # editor
  brew install nvim fd fzf ripgrep
  # c/c++
  brew install pkg-config ninja bear ctags valgrind llvm make cmake gcc clangd
  # java
  brew install openjdk@17 bison flex htop
  # go.
  # NOTE: Install go by asdf
  brew install gotests
}

TASK="install"
while getopts ":icv:" opt; do
  case $opt in
  c) TASK="config" ;;
  i) TASK="install" ;;
  v) VERSION=$OPTARG ;;
  *) usage ;;
  esac
done

$TASK
