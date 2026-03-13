#!/bin/sh

myname="${0##*/}"

nv_bin="/usr/bin/nvim"
pipe_loc="${XDG_RUNTIME_DIR:-/tmp}/nvim"

config_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/nvim-send"
config_file="${config_dir}/configrc"

config_dir_nvw="${XDG_CONFIG_HOME:-${HOME}/.config}/nvim-wrap"
config_nvw="${config_dir_nvw}/configrc"

nvim_send () {
    for pipe_instance in "${pipe_loc}"/nvim.*; do
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

version=@VERSION@

show_help () {
    printf '%s\n\t%s\n' "${myname}:" \
                        "send messages to every nvim rpc server"
    printf '%s\n\t%s\n' "Version:" "$version"
    printf '%s\n\t%s\n' "Usage:" \
                        "${myname} -v | -h | [ nvim commands ]"
    printf '%s\n\t%s\n' "    -h" \
                        "print out this help message, 'help' and '--help' are supported too"
    printf '%s\n\t%s\n' "    -v" \
                        "print out the version, 'version' and '--version' are supported too"
    printf '\n%s\n'     "About:"
    printf '\t%s\n'     "$myname is a neovim wrapper script intended to broadcast the given commands"
    printf '\t%s\n'     "to every nvim instance with an rpc pipe registered under a set location."
    printf '\t%s\n'     "The default location is set on: \${XDG_RUNTIME_DIR:-/tmp}/nvim"
    printf '\t%s\n'     "altho the configuration for nvim-wrap will be used to determine the dir"
    printf '\t%s\n'     "containing the rpc socket for each neovim instance, which by convention on"
    printf '\t%s\n'     "both scripts are given the name 'nvim.PID.pipe' where 'PID' is the process"
    printf '\t%s\n'     "id of each instance."
    printf '\n%s\n'     "Configuration:"
    printf '\t%s\n'     "The $myname base configuration is generated upon first run, it will be"
    printf '\t%s'       "located by default at: "
    printf '%s\n'       "\${XDG_CONFIG_HOME:-\${HOME}/.config}/nvim-send/configrc"
    printf '\t%s'       "on this system that expands to: "
    printf '%s\n'       "$config_file"
    printf '\t%s\n'     "the configuration file for nvim-wrap is also loaded blindly to get the set"
    printf '\t%s\n'     "value for the \$pipe_loc variable."
    printf '\n%s\n'     "For more information please check the manual page for nvim-wrap(1)"
    exit 0
}

case "$1" in
    help|-h|--help)
        show_help
        ;;
    version|-v|--version)
        printf "%s\n" "nvim-send $version"
        exit 0
        ;;
esac

if [ -f "$config_nvw" ]; then
    . "$config_nvw"
fi

if [ "$#" -gt 0 ]; then
    nvim_send "$@"
else
    send_comms
fi
