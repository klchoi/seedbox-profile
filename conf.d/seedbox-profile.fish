function _seedbox_profile_install -e seedbox-profile_install -e seedbox-profile_update
  # backup original file
  set -S | while read -L line
    string match -q -r '^\$(?<var>_seedbox_profile_(?<filename>\w+))' -- $line || continue
    set filename ~/(string unescape -n --style=var $filename)
    echo '>' $filename
    mkdir -p (path dirname $filename)
    test -f $filename -a ! -f $filename.bak && mv $filename $filename.bak
    echo $$var | sed -e '/./,$!d' -e:a -e '/^\n*$/{$d;N;ba' -e '}' > $filename
  end
end

set -g _seedbox_profile__2E_profile '
# without it terminal will unable to display/process unicode file name
export LC_CTYPE=en_US.UTF-8

# set PATH so it includes user’s private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ] ; then
    SESSION_TYPE=remote/ssh
else
    case $(ps -o comm= -p "$PPID") in
        sshd|*/sshd)
            SESSION_TYPE=remote/ssh
            ;;
    esac
fi

if [ "$SESSION_TYPE" = remote/ssh ]; then
    # default shell
    if [ -x "$HOME/.local/bin/fish" ] ; then
        export SHELL=$HOME/.local/bin/fish
    fi

    # attach tmux
    if [ -x "$HOME/.local/bin/tmux" ] ; then
        export TERM=xterm
        exec $HOME/.local/bin/tmux -u new-session -As ssh
    fi  
fi
'
