#!/bin/sh

myname="${0##*/}"

# you can change this on config to the correct path on your system
nv_bin="/usr/bin/nvim"

pipe_loc="${XDG_RUNTIME_DIR:-/tmp}/nvim"

config_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/nvim-wrap"
config_file="${config_dir}/configrc"

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

# neovim binary
nv_bin="${nv_bin}"

# pipe directory
pipe_loc="${pipe_loc}"
__HEREDOC__
fi

version=@VERSION@

show_help () {
    printf '%s\n\t%s\n' "${myname}:" \
                        "nvim wrapper"
    printf '%s\n\t%s\n' "Version:" "$version"
    printf '%s\n\t%s\n' "Usage:" \
                        "${myname} -v | -h | [ nvim flags and files ]"
    printf '%s\n\t%s\n' "    -h" \
                        "print out this help message, 'help' and '--help' are supported too"
    printf '%s\n\t%s\n' "    -v" \
                        "print out the version, 'version' and '--version' are supported too"
    printf '\n%s\n'     "About:"
    printf '\t%s\n'     "$myname is a neovim wrapper intended to explicitly set the location of the"
    printf '\t%s\n'     "neovim rpc pipe socket in a user configurable location, it also allows for"
    printf '\t%s\n'     "setting, unsetting and otherwise modifiying the environment variables"
    printf '\t%s\n'     "neovim is launched with through the configuration."
    printf '\n%s\n'     "Configuration:"
    printf '\t%s\n'     "The $myname base configuration is generated upon first run, it will be"
    printf '\t%s'       "located by default at: "
    printf '%s\n'       "\${XDG_CONFIG_HOME:-\${HOME}/.config}/nvim-wrap/configrc"
    printf '\t%s'       "on this system that expands to: "
    printf '%s\n'       "$config_file"
    printf '\n%s\n'     "For more information please check the manual page for nvim-wrap(1)"
    exit 0
}

case "$1" in
    help|-h|--help)
        show_help
        ;;
    version|-v|--version)
        printf "%s\n" "nvim-wrap $version"
        $nv_bin --version
        exit 0
        ;;
esac

mypid="$$"

# make pipe dir
if [ ! -d "$pipe_loc" ]; then
    mkdir -p "$pipe_loc"
fi

pipe_file="${pipe_loc}/nvim.${mypid}.pipe"

exec $nv_bin --listen "$pipe_file" "$@"
