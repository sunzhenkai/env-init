#!/bin/bash

set -x

mvToNext() {
	n=1
	while [ -e "${1}.back${n}" ]; do
	    n=$((n+1))
	done
	mv "$1" "$1.back${n}"
}

[ ! -e software ] && echo "software dirctory not exists" && exit 1
[ -e ~/.software ] && echo "~/.software already exists" && mvToNext ~/.software

cp -r software ~/.software

bash ~/.software/install.sh
