# nvim-wrap

here 2 scripts are provided:
- nvim-wrap
- nvim-send

`nvim-wrap`: a paper thin wrapper to ensure that every instance of neovim we launch will always be
    listening to the pipe that `nvim-send` sends commands to, you can use this wrapper to set
    and unset environment variables if you want or to launch neovim with another wrapper, your
    imagination is the limit.

`nvim-send`: sends neovim commands into a pipe (by default `/tmp/nvim/nvim.PID.pipe`), if you
    provide the script with arguments it will send them like a single command, if you do not it
    will instead run the `send_comms` function which can be overriden from the config with whatever
    you want inside.

installation:
```sh
# clone the repo
git clone https://github.com/eylles/nvim-wrap.git
# to install just run
make install clean
# by default this will put both scripts in:
#     $HOME/.local/bin
```

Now add some alias like this to your shell's rc (bashrc, zshrc, .profile)
```sh
alias nvim="nvim-wrap"
```

or even link the nvim-wrap script to `/usr/bin/editor` if you are using the debian alternatives
system, just edit the `config.mk` and change PREFIX to `/usr/local`, install and then run this
command to register `nvim-wrap` onto the alternatives system:

```sh
sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/nvim-wrap 30
```

have fun!!!


## where do this comes from?

These scripts are a more general version from the
 [nvim-colo-reload](https://github.com/eylles/pywal-extra/tree/master/scripts/nvim-colo-reload)
 scripts found in the pywal-extra repo.
