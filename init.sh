#!/bin/bash
_BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
source "$_BASE/scripts/tool.sh"
set -x
export ENV_INIT_DIR="$HOME/.env-init"
export ENV_INIT_ENV_FILE="$ENV_INIT_DIR/env"
export ENV_INSTALL_DIR="$ENV_INIT_DIR/app"
export ENV_INSTALL_PACKAGE_DIR="$ENV_INIT_DIR/packages"
export PATH="$_BASE/bin":$PATH
export ENV_INIT_COMMAND=ienv
export ENV_INIT_CODE=$_BASE

function EnvInit() {
    mkdir -p "${ENV_INSTALL_DIR}"
    mkdir -p "${ENV_INSTALL_PACKAGE_DIR}"
    
    # init env file
    tool::append_to_env_profile "export HOME=\"$HOME\""
    tool::append_to_env_profile 'export ENV_INIT_DIR="$HOME/.env-init"'
    tool::append_to_env_profile 'export ENV_INIT_ENV_FILE="$ENV_INIT_DIR/env"'
    tool::append_to_env_profile 'export ENV_INSTALL_DIR="$ENV_INIT_DIR/app"'
    tool::append_to_env_profile 'export ENV_INSTALL_PACKAGE_DIR="$ENV_INIT_DIR/packages"'
    tool::append_to_env_profile "export ENV_INIT_CODE=$_BASE"
    tool::append_to_env_profile "alias envi=\"cd $_BASE\""
    tool::append_to_env_profile "export PATH=$_BASE/bin:\$PATH"

    tool::append_to_env_profile_lines < "$_BASE"/env/profile
    tool::append_to_env_profile_lines < "$_BASE/env/profile_$(tool::os_type)"
    # [ -e "$_BASE/env/profile_$(tool::os_type)" ] && tool::append_to_env_profile_lines < "$_BASE/env/profile_$(tool::os_type)"
}

function InitEnvCommand {
    # append env activate command to profiles
    tool::append_to_profiles "alias ${ENV_INIT_COMMAND}=\"source ${ENV_INIT_ENV_FILE}\" "
}

function InitEnvSource {
    tool::append_to_profiles "source \"${ENV_INIT_ENV_FILE}\""
}

