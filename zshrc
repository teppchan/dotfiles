# -*- coding:utf-8-unix -*-
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

setopt chase_links

########################################
# 環境変数
########################################

#シェル設定変数
#history
HISTFILE=~/.zsh-history
HISTSIZE=500000
SAVEHIST=500000

########################################
# Aliases
########################################
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

if [ `uname` = Linux ]; then
    alias bc='bc -lq'
fi

alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias lf='ls -aF'
alias ll='ls -lasF'
alias la='ls -aF'
alias lr='ls -atlr'
function lt(){
    ls -tr $@|tail -1
}

alias h='history'
#alias c=cat
alias ox='od -Ax -tx1'
alias tf='tail -F'
alias tmore=tf
alias tmroe=tmore
alias r=lr

if hash less 2> /dev/null; then
    alias more='less'
fi

alias today="date +%Y%m%d"
alias now="date +%Y%m%d_%H%M"

#typos
alias maek='make'
alias alais='alias'
alias csl='clear'
alias sl=ls
alias mroe=more
alias pdw=pwd

alias xterm='xterm -sb'
# 現在実行中のジョブを表示。
function j { jobs -l; }

function ff(){
    find . -name $1
}

function ducks(){
    du -cks * | sort -g
}
alias dusk=ducks

alias nmore='less -N'
alias nmroe=nmore

#reduce some comments
function rmore () {
    LESSOPEN='|egrep -v "^ *//" %s' less $*
}
alias rmroe=rmore

function hmore () {
    LESSOPEN='|hexdump -C %s' less $*
}
alias hmroe=hmore

function flr ()
{
    for f in `seq 1 1000`; do
        lr $* | tail
        sleep 1
        echo
    done
}

# INCISIVEで、`assert -summary -final' したlogファイルから、そのサマリだけ抜き出す
function ext_assert() {
    if [ $# = 0 ]; then
        echo "ext_assert <file> [<file> ...]"
        return
    fi
    if [ $# = 1 ]; then
        cat $1 | sed -n '/^  Disabled Finish Failed   Assertion Name /,/^  Total Assertions/p' | awk '$3!=0'
        return
    fi

    for f in $*; do
        echo $f
        cat $f | sed -n '/^  Disabled Finish Failed   Assertion Name /,/^  Total Assertions/p' | awk '$3!=0'
        echo
    done
}

function paste_hexdump() {
    paste =(hexdump -C $1) =(hexdump -C $2)
}
function diff_hexdump() {
    if [ $# = 2 ]; then
        diff =(hexdump -C $1) =(hexdump -C $2)
    else
        diff $1 =(hexdump -C $2) =(hexdump -C $3)
    fi
}
###############################
## emacsclient
##############################
function estart() {
    if ! emacsclient -e 0 > /dev/null 2>&1; then
        cd > /dev/null 2>&1
        #emacs --daemon -q -l ~/.emacs.d/init.el
        emacs --daemon
        cd - > /dev/null 2>&1
    fi
}

alias ec='emacsclient -nw'
alias ew='emacsclient -c'
alias ekill="emacsclient -e '(kill-emacs)'"
alias erestart="emacsclient -e '(kill-emacs)' && estart"

#export EDITOR='emacsclient -nw'

estart

#############################
## githubに送らない記述
##############################
[[ -f ~/etc/zshrc.local ]] && source ~/etc/zshrc.local
