function FATAL() {
    echo "ERROR: $@"
    exit 1
}

function WARN() {
    echo "WARN $@"
}

# common tools
function tool::is_same_file() {
    if ! command -v vim >/dev/null 2>&1; then
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

function tool::pre_install_check() {
    if [ -z "$ENV_INIT_DIR" ]; then
        return 1
    fi
    return 0
}

# tool::append_if_not_exists {file} {text}
function tool::append_if_not_exists() {
    (! grep -q "$2" $1) && echo "append [ $2 ] into ${1}" && echo "$2" >>$1
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

function tool::get_root_install_dir() {
    echo "$ENV_INSTALL_DIR/install"
}

# tool::ln_to_bin {appname} {version} {subpath}
function tool::ln_to_bin() {
    local binary_path="$(tool::get_install_dir $1 $2)/$3"
    ln -s ${binary_path} ${ENV_INIT_BIN}/
}

# tool::append_path {appname} {subpath}
function tool::append_binary_path() {
    if [[ -n "$2" ]]; then
        binary_path="$(tool::get_root_install_dir)/$1/$2"
    else
        binary_path="$(tool::get_root_install_dir)/$1"
    fi
    env_file="$ENV_INIT_DIR/env"
    [ ! -e "$env_file" ] && touch "$env_file"
    tool::append_if_not_exists "$ENV_INIT_DIR/env" "export PATH=$binary_path:\$PATH"
}

########## download & build ##########

# get package dir by stage
# tool::get_package_dir {appname} {version} {stage}
function tool::get_package_dir() {
    echo "$ENV_INSTALL_PACKAGE_DIR/$3/$1-$2"
}

# tool::get_download_file {appname} {version} ${suffix}
function tool::get_download_file() {
    echo "$ENV_INSTALL_PACKAGE_DIR/download/$1-$2$3"
}

# tool::get_extract_dir {appname} {version} {stage}
function tool::get_extract_dir() {
    echo "$ENV_INSTALL_DIR/$3/$1-$2"
}

# tool::get_install_dir {appname} {version}
function tool::get_install_dir() {
    echo "$(tool::get_root_install_dir)/$1-$2"
}

# tool::mv_by_stage {appname} {version} {stage}
function tool::mv_by_stage() {
    source_dir=$(tool::get_extract_dir $1 $2 $3)
    install_dir=$(tool::get_install_dir $1 $2)
    mkdir -p "$install_dir"
    echo "[$1] move by stage. [from=$source_dir, to=$install_dir]"
    mv "$source_dir"/* "$install_dir"/
}

# tool::update_install_link {appname} {version}
function tool::update_install_link() {
    ln -s "$(tool::get_root_install_dir)/$1-$2" "$(tool::get_root_install_dir)/$1"
}

# tool::download {url} {appname} {version} 
function tool::download() {
    dest=$(tool::get_package_dir $2 $3 download)
    [ -e "$dest" ] && echo "[$2] skip download [version=$3, dest=$dest]" && return
    mkdir -p "$ENV_INSTALL_PACKAGE_DIR/download/"
    wget --no-check-certificate -O "$dest" "$1"
    echo "[$2] downloading done. [version=$3, dest=$dest]"
}

# tool::download_github_release {appname} {user} {project} {version} 
function tool::download_github_release() {
    _URL=https://github.com/$2/$3/archive/refs/tags/$4.tar.gz
    tool::download $_URL $1 $4
}

# tool::tar_extract {appname} {version} {stage}
function tool::tar_extract() {
    [ -n "$stage" ] && echo "[tool::tar_extract] stage not specified" && return 1
    from=$(tool::get_package_dir $1 $2 download)
    dest=$(tool::get_extract_dir $1 $2 $3)
    echo "[$1] extract [dest=${dest}]"
    mkdir -p "$dest"
    tar -xf "$from" --strip-components=1 -C "$dest"
}

# tool::tar_extract {appname} {version} {stage}
function tool::zip_extract() {
    [ -n "$stage" ] && echo "[tool::zip_extract] stage not specified" && return 1
    from=$(tool::get_package_dir $1 $2 download)
    dest=$(tool::get_extract_dir $1 $2 $3)
    echo "[$1] extract [dest=${dest}]"
    mkdir -p "$dest"
    unzip -oj "$from" -d "$dest"
}
