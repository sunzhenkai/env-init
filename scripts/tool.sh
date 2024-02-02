# common tools
function tool::is_same_file() {
    if ! command -v vim > /dev/null 2>&1; then
        echo 'program md5sum not exits'
        return 1
    fi
    if [ -e "$1" -a -e "$2" ]; then
        r1=$(md5sum "$1" | awk '{print $1}')
        r2=$(md5sum "$2" | awk '{print $1}')
        if [ $r1 = $r2 ]; then 
            return 0
        else
            return 1
        fi
    else
        return 1
    fi
}

# package tool
function tool::os_type() {
    local os='unkown'
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        os='linux'
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        os='darwin'
    fi
    echo ${os}
}

function tool::cpu_arch() {
    echo $(uname -m)
}

function tool::cpu_arch_alias() {
    declare -A CPU_ARCH_ALIAS=(
        ["x86_64"]=amd64
    )
    als=${CPU_ARCH_ALIAS["$1"]}
    if [[ -z "$als" ]]; then
        echo "$1"
    else
        echo "$als"
    fi
}

function tool::check_install() {
    if [ -z "$ENV_INIT_DIR" ]; then
        return 1
    fi
    return 0
}

# tool::append_if_not_exists {file} {text}
function tool::append_if_not_exists() {
    (! grep -q "$2" $1)  && echo "append [ $2 ] into ${1}" && echo "$2" >> $1
}

# tool::append_to_env_profile {text}
function tool::append_to_env_profile() {
    [ ! -e "$ENV_INIT_ENV_FILE" ] && touch "$ENV_INIT_ENV_FILE"
    tool::append_if_not_exists "$ENV_INIT_ENV_FILE" "$1"
}

# tool::append_to_env_profile_lines <lines
function tool::append_to_env_profile_lines() {
    while read line; do
        tool::append_to_env_profile "$line"
    done
}

# tool::append_to_profiles {text}
function tool::append_to_profiles() {
    profiles='.bashrc .bash_profile .zshrc'
    for i in $profiles; do 
        [ -e "$HOME/$i" ] && tool::append_if_not_exists "$HOME/$i" "$1"
    done
}

# tool::download {url} {appname} {version}
function tool::download() {
    wget -O "$ENV_INSTALL_PACKAGE_DIR/$2-$3" "$1" 
}

# tool::tar_extract {appname} {version}
function tool::tar_extract() {
    mkdir -p "$ENV_INSTALL_DIR/$1-$2"
    tar -xf "$ENV_INSTALL_PACKAGE_DIR/$1-$2" --strip-components=1 -C "$ENV_INSTALL_DIR/$1-$2"
}

# tool::tar_extract {appname} {version}
function tool::zip_extract() {
    mkdir -p "$ENV_INSTALL_DIR/$1-$2"
    unzip -oj "$ENV_INSTALL_PACKAGE_DIR/$1-$2" -d "$ENV_INSTALL_DIR/$1-$2"
}

# tool::append_path {appname} {version} {subpath}
function tool::append_binary_path() {
    binary_path="$ENV_INSTALL_DIR/$1-$2/$3"
    env_file="$ENV_INIT_DIR/env"
    [ ! -e "$env_file" ] && touch "$env_file"
    tool::append_if_not_exists "$ENV_INIT_DIR/env" "export PATH=$binary_path:\$PATH"
}
