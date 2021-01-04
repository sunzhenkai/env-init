#!/bin/bash
set -x

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
[ -e ~/.vimrc ] && mv ~/.vimrc ~/.vimrc.back${n}
cp vim/vimrc ~/.vimrc


vim -c PluginInstall -c q -c q
