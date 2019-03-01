#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# Browser
#

if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

#
# Editors
#

export EDITOR='nano'
export VISUAL='nano'
export PAGER='less'

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

export PATH=/usr/bin:/usr/sbin:/bin:/sbin
export PATH=${HOME}/usr/bin:${PATH}
export PATH=${HOME}/mybin:$PATH
export MANPATH=${HOME}/usr/share/man:/usr/share/man

# linuxbrew
if [[ -d ~/.linuxbrew ]] then
   export PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
   export MANPATH="$(brew --prefix)/share/man:$MANPATH"
   export INFOPATH="$(brew --prefix)/share/info:$INFOPATH"
   export HOMEBREW_NO_ANALYTICS=1
   export HOMEBREW_MAKE_JOBS=6
fi

if [ -e /etc/redhat-release ]; then
    if [ `cat /etc/redhat-release | awk '{print $7 >= 7}'` -eq 1 ]; then
        export PATH=${HOME}/usr/emacs26_rhel7/bin:${PATH}
    else
        export PATH=${HOME}/usr/emacs26/bin:${PATH}
    fi
fi

# pyenv
[[ -d ~/.pyenv ]] && \
    export PYENV_ROOT="$HOME/.pyenv"    && \
    export PATH="$PYENV_ROOT/bin:$PATH" && \
    eval "$(pyenv init -)"

# Ruby in rbenv
[[ -d ~/.rbenv ]] && \
    export PATH=${HOME}/.rbenv/bin:${PATH} && \
    eval "$(rbenv init -)"

# goenv
[[ -d ~/.goenv ]] && \
    export PATH=${HOME}/.goenv/bin:$PATH && \
    eval "$(~/.goenv/bin/goenv init -)"

# Golang
export GOPATH=${HOME}/.go
export PATH=$GOPATH/bin:$PATH

# Rust
[[ -d ~/.cargo ]] && \
    export PATH=~/.cargo/bin:$PATH

#
# Less
#

#export LESS='-F -g -i -M -R -S -w -X -z-4'
export LESS='-X -i -W -I -R -M -P ?f%f:(stdin).  ?lb%lb?L/%L..  [?eEOF:?pb%pb\%..]'

#if (( $#commands[(i)lesspipe(|.sh)] )); then
#  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
#fi
export LESSOPEN="| $HOME/etc/lesspipe.sh %s"

