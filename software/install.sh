#!/bin/bash

set -x

bash_profile=~/.bash_profile
# software_dir=~/.software
[ ! -e "${bash_profile}" ] && touch "${bash_profile}" 

appendIfNotExsits() {
    (! grep -q "$2" $1)  && echo "[ $2 ] not exists" && echo "$2" >> $1
}

# mvToNext() {
# 	n=1
# 	while [ -e "${1}.back${n}" ]; do
# 	    n=$((n+1))
# 	done
# 	mv "$1" "$1.back${n}"
# }

# appendIfNotExsits ${bash_profile} "alias vim='mvim -v'"
# appendIfNotExsits ${bash_profile} "alias ll='ls -lGh'"
# appendIfNotExsits ${bash_profile} "export PATH=$software_dir/thrift-0.5.0/bin:\$PATH"
# appendIfNotExsits ${bash_profile} "export PATH=$software_dir/protoc-3.5.1-osx-x86_64/bin:\$PATH"


