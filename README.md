# Descript

重装系统后，配置及软件初始化，包括

- vim 配置
- 本地软件
- 远程软件

# Vim

```shell
# 安装vbundle
$ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
$ bash vim install-vimrc.sh
```

## Software

**MAC**

```shell
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# openjdk
$ brew tap AdoptOpenJDK/openjdk
$ brew cask install adoptopenjdk8
# remove
$ brew cask remove adoptopenjdk8

# others
$ brew install macvim git maven

# install local software
$ bash software/install-soft.sh  # install local software & remote by brew
```

# Environment

```shell
# append bash profile 
$ bash env/merge-profile
$ source ~/.bash_profile
```

