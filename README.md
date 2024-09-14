# Descript
Tools for initialize your favorite environment.

# Install
```shell
git clone git@github.com:sunzhenkai/env-init.git
cd env-init
./activate
```
# Usage
```shell
ii cmake       # install cmake
ii python3 -b  # install python3 form source code
```

# Apps
```shell
$ ii ls
[√] cmake
[√] gcc
[√] gdb
[√] gmp
[√] homebrew
[√] kata
[√] mpfr
[√] ninja
[√] oss
[√] python3
[√] vim
```

# TODO
## Apps To Support
- [x] python3
- [x] gcc/g++
- [x] gdb
- [x] bazel
- [x] miniconda

## Features
- build from source
- prebuild & upload & download
- resolve dependencies

# DEV
## Steps 
- download
- extract[optional]
- install
- append path

## Path Info
- Install Dir: `$HOME/.local/env-init`
- Packages: `$HOME/.local/env-init/packages/{download,build,install}`