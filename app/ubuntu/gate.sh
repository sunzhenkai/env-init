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
  sudo ln -fs /usr/bin/gcc-$GCC_VERSION /usr/bin/gcc
  sudo ln -fs /usr/bin/g++-$GCC_VERSION /usr/bin/g++

  # zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  # homebrew
  if ! command -v brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo >>$HOME/.zshrc
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>$HOME/.zshrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
  brew install openjdk@17 cmake ninja bison flex htop nvim go ripgrep
  brew install yazi ffmpeg sevenzip jq poppler fd ripgrep fzf zoxide imagemagick font-symbols-only-nerd-font
  brew install fish starship gitui
  echo "" >>~/.zshrc
  echo 'eval "$(starship init zsh)"' >>~/.zshrc

  # nvm
  if ! command -v nvm; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    echo '' >>~/.zshrc
    echo 'export NVM_DIR="$HOME/.nvm"' >>~/.zshrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' >>~/.zshrc
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >>~/.zshrc
    source ~/.zshrc
  fi
  nvm install --lts
  npm install -g yarn

  # env
  pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
  echo "" >>~/.zshrc
  echo "export CC=/usr/bin/gcc-$GCC_VERSION" >>~/.zshrc
  echo "export CXX=/usr/bin/g++-$GCC_VERSION" >>~/.zshrc
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
