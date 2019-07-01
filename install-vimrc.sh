#!/bin/bash

#### download vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

#### cp vimrc
cp ~/.vimrc ~/.vimrc-back
cp vimrc ~/.vimrc
