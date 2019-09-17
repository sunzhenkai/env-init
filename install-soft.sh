#!/bin/bash

set -x

[ ! -e software ] && echo "software dirctory not exists" && exit 1
[ -e ~/.software ] && echo "~/.software already exists" && mv ~/.software ~/.software-back

cp -r software ~/.software

bash ~/.software/install.sh
