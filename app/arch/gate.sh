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
    -g  gui config
EOF
}

function install() {
  echo "install: not implement"
}

function gui() {
  yay -Sy google-chrome kitty wezterm
  # font
  paru -Sy maplemononl-cn # maplemono-cn-unhinted
}

function config() {
  sudo pacman -Sy gdb cmake ninja texinfo make less which base-devel procps-ng curl file git sed gawk bind \
    fzf pkg-config mariadb-clients traceroute wireguard-tools \
    noto-fonts-cjk wqy-microhei adobe-source-han-sans-otc-fonts
  # yay
  cd /tmp
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si
  # pura
  cd /tmp
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
}

TASK="install"
while getopts ":cg" opt; do
  case $opt in
  c) TASK="config" ;;
  g) TASK="gui" ;;
  *) usage ;;
  esac
done

$TASK
