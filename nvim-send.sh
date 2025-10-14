#!/bin/sh

myname="${0##*/}"

nv_bin="/usr/bin/nvim"
pipe_loc="${XDG_RUNTIME_DIR:-/tmp}/nvim"

config_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/nvim-send"
config_file="${config_dir}/configrc"

config_dir_nvw="${XDG_CONFIG_HOME:-${HOME}/.config}/nvim-wrap"
config_nvw="${config_dir_nvw}/configrc"

nvim_send () {
    for pipe_instance in "${pipe_loc}"/nvim.*.pipe; do
        $nv_bin --server "$pipe_instance" --remote-send ":${*}<CR>"
    done
}

send_comms () {
    :
}

# loading the config here means the user can overwrite any of the functions
if [ -f "$config_file" ]; then
    . "$config_file"
else
    if [ ! -d "$config_dir" ]; then
        mkdir -p "$config_dir"
    fi
    cat << __HEREDOC__ >> "$config_file"
# vim: ft=sh
# ${myname} config file

# this function can be overridden here with anything you want inside
# it will be executed if the script is ran without arguments
send_comms () {
    :
}
__HEREDOC__
fi

if [ -f "$config_nvw" ]; then
    . "$config_nvw"
fi

if [ "$#" -gt 0 ]; then
    nvim_send "$@"
else
    send_comms
fi
