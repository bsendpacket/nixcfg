#!/usr/bin/env bash

VIRTUALENVS_DIR="$HOME/.virtualenvs"

# Ensure the venv directory exists
mkdir -p "$VIRTUALENVS_DIR"

# Activate venv
activate() {
  local env_name="$1"
  local env_path="$VIRTUALENVS_DIR/$env_name"

  # venv name is required
  if [ -z "$env_name" ]; then
    echo "Usage: activate <env-name>"
    return 1
  fi

  # Deactivate any currently active venvs
  [ "$(declare -f deactivate)" ] && deactivate

  # Resolve the venv path
  env_path="$(readlink -f "$env_path")"

  # Does the venv exist?
  if [ -z "$env_path" ] || [ ! -d "$env_path" ]; then
    echo "Environment '$env_name' not found."
    return 1
  fi

  # Setup environment variables
  export VIRTUAL_ENV_NAME="$env_name"
  export VIRTUAL_ENV="$env_path"

  # Add the environment bin to PATH
  export _OLD_VIRTUAL_PATH="$PATH"
  export PATH="$VIRTUAL_ENV/bin:$PATH"

  # Backup and update prompt
  export _OLD_VIRTUAL_PS1="${PS1:-}"
  export PS1="($VIRTUAL_ENV_NAME) ${_OLD_VIRTUAL_PS1}"

  # Deactivate current venv
  deactivate() {
    export PATH="$_OLD_VIRTUAL_PATH"
    export PS1="$_OLD_VIRTUAL_PS1"
    unset VIRTUAL_ENV VIRTUAL_ENV_NAME _OLD_VIRTUAL_PATH _OLD_VIRTUAL_PS1
    unset -f deactivate
  }
}
