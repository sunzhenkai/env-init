#!/bin/bash

cur_path="${PWD}/$(dirname $0)"
source ${cur_path}/../lib/tool.sh
os="$(tool::os_type)"
echo "$os"

# mvToNext() {
# 	n=1
# 	while [ -e "${1}.back${n}" ]; do
# 	    n=$((n+1))
# 	done
# 	mv "$1" "$1.back${n}"
# }

# [ ! -e software ] && echo "software dirctory not exists" && exit 1
# [ -e ~/.software ] && echo "~/.software already exists" && mvToNext ~/.software

# cp -r software ~/.software

# bash ~/.software/install.sh

#### install softwares
triggerOSXInstall() {
    brew install tree
    brew install git
    brew install tmux
    brew install macvim
    brew install wget
    brew tap AdoptOpenJDK/openjdk && brew cask install adoptopenjdk8
}

if [ "darwin" == "$os" ]; then
   triggerOSXInstall 
else
   echo "unsupport os type ${os}"
fi

