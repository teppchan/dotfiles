#!/usr/bin/env zsh

HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history        #日付を保存
setopt share_history           #他の端末と履歴をシェア
setopt hist_ignore_all_dups    #重複削除
setopt hist_reduce_blanks      #空白削除
setopt hist_ignore_space       #先頭スペースは無視
function history-all { history -E l }

bindkey '^P' history-beginning-search-backward # 先頭マッチのヒストリサーチ
bindkey '^N' history-beginning-search-forward # 先頭マッチのヒストリサーチ

zstyle ':completion:*:default' menu select=1
autoload -U compinit
compinit

#補完のときに大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select=1

#C-s, C-qを無効化する
setopt no_flow_control

setopt noauto_menu

alias ls='ls -G'
alias ll='ls -la'
alias lf='ls -Fa'
alias lr='ls -atrl'
alias la='ls -a'
function flr(){
    repeat 1000; do
        lr $1 | tail -30
        sleep 1
    done
}

alias rm='rm -i'
alias more=less
alias j=jobs

#typo
alias sl=ls
alias mroe=more

export PATH=/usr/loca/bin:$PATH               #Homebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH #Nodebrew
export PATH=$PATH:$HOME/.rvm/bin              #RVM

