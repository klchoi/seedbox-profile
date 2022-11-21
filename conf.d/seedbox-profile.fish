function _seedbox_profile_install -e seedbox-profile_install -e seedbox-profile_update
  # backup original file
  if test ! -f $HOME/.profile.bak -a -f $HOME/.profile
    mv $HOME/.profile $HOME/.profile.bak
  end
  echo "

# without it terminal will unable to display/process unicode file name
export LC_CTYPE=en_US.UTF-8

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# default shell
if [ -x "$HOME/.local/bin/fish ] ; then
    export SHELL=$HOME/.local/bin/fish
fi

if [ -x "$HOME/.local/bin/tmux ] ; then
    export TERM=xterm
    exec $HOME/.local/bin/tmux -u new-session -As ssh
fi

" > $HOME/.profile
end
