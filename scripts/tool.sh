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

function tool::check_install() {
    if [ -z "$NV_INIT_DIR" ]; then
        return 1
    fi
    return 0
}

# tool::append_if_not_exists {file} {text}
function tool::append_if_not_exists() {
    (! grep -q "$2" $1)  && echo "text [ $2 ] not exists in file ${1}" && echo "$2" >> $1
}

# tool::append_env_profile {text}
function tool::append_env_profile() {
    [ ! -e "$ENV_INIT_ENV_FILE" ] && touch "$ENV_INIT_ENV_FILE"
    tool::append_if_not_exists "$ENV_INIT_ENV_FILE" "$1"
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

# tool::append_path {appname} {version} {subpath}
function tool::append_binary_path() {
    binary_path="$ENV_INSTALL_DIR/$1-$2/$3"
    env_file="$ENV_INIT_DIR/env"
    [ ! -e "$env_file" ] && touch "$env_file"
    tool::append_if_not_exists "$ENV_INIT_DIR/env" "export PATH=$binary_path:\$PATH"
}