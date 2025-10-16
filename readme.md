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

# why tho?

A couple of reasons i've found through the years:

- pywal integration: one common pitfal for pywal integration was/is that even if the colorscheme is
  able to perform dynamic reload when the base colors change like
  [neopywal](https://github.com/RedsXDD/neopywal.nvim)
  some other elements like the statusline colorscheme may not be reloaded so additional commands
  have to bee hooked on to the colorscheme change.

- bad vertical scrolling on splits: an old bug that has existed since neovim 0.5 and was "fixed" on
  neovim 0.6, it tends to happen more on a true xterm since neovim has some wrong assumptions about
  scroll handling, to simplify neovim expects the `sgmlp` and `sgmrp` sequences to be set when the
  environment variable of a true xterm `XTERM_VERSION` exists within the environment, for xterm to
  have those specific scrolling sequences it has to use the `decTerminalID` `vt420`, but that is
  usually NOT the default terminal id configured for xterm as distributions usually set it to `vt100`
  for compatibility while users tend to set it to `vt340` for sixel graphics support, the real fix
  is for neovim to use the `DECRQSS` control sequence to get the correct scrolling method instead
  relaying on env vars, but until that happens (still a bug in neovim 0.10, gotta check on 0.11 yet)
  the workaround is to use a neovim wrapper that unsets the `XTERM_VERSION` variable before running
  neovim, with nvim-wrap just put `unset XTERM_VERSION` inside your config and it will work.
