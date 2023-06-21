#!/bin/bash
set -x
BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

#### download vundle
if [ ! -e ~/.vim/bundle/Vundle.vim ]; then
    echo "download Vundle.vim"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

#### cp vimrc
n=1
while [ -e ~/.vimrc.back${n} ]
do
    n=$((n+1))
done
if [ -e "${BASE}/vimrc" ]; then
    [ -e ~/.vimrc ] && mv ~/.vimrc ~/.vimrc.back${n}
    cp "${BASE}/vimrc" ~/.vimrc
fi
#vim -c PluginInstall -c q -c q
vim  +PluginInstall +qall
# vim --clean '+source ~/.vimrc' +PluginInstall +qall
