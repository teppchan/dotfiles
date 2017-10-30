#!/usr/bin/env zsh

#$Id: $

#グループwも許可
umask 002

stty stop undef  #C-sの停止を止める

#completion
zstyle ':completion:*:default' menu select=1
autoload -U compinit
compinit

zstyle :compinstall filename '~/.zshrc'

# Path
export PATH=${HOME}/usr/bin:$PATH
export PATH=${HOME}/mybin:$PATH
export LD_LIBRARY_PATH=${HOME}/usr/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${HOME}/usr/lib64:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=${HOME}/usr/lib/pkgconfig
export MANPATH=${HOME}/usr/share/man:/usr/share/man

# linuxbrew
export PATH="$HOME/.linuxbrew/bin:$PATH"
export MANPATH="$(brew --prefix)/share/man:$MANPATH"
export INFOPATH="$(brew --prefix)/share/info:$INFOPATH"

# Golang
export GOPATH=${HOME}/.go

# Rust
export PATH=$HOME/.cargo/bin:$PATH

# Ruby in rbenv
[[ -d ~/.rbenv ]] && \
export PATH=${HOME}/.rbenv/bin:${PATH} && \
eval "$(rbenv init -)"

#シェル設定変数
#history
HISTFILE=~/.zsh-history
HISTSIZE=500000
SAVEHIST=500000

export PAGER=less
#export PAGER=lv
export LESS='-X -i -P ?f%f:(stdin).  ?lb%lb?L/%L..  [?eEOF:?pb%pb\%..]'
export LESSOPEN="| $HOME/etc/lesspipe.sh %s"
#export JLESSCHARSET=japanese-euc
#export XMODIFIERS="@im=kinput2"

bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall

typeset -U fpath
fpath=($fpath ~/etc/zsh)

autoload -Uz compinit
compinit
# End of lines added by compinstall

setopt auto_cd              # コマンドが省略されていたら cd とみなす
#setopt AUTO_PUSHD      # cd 時にOldDir を自動的にスタックに積む
#setopt correct             # コマンドのスペルチェック
setopt auto_name_dirs       # よく判らん
setopt auto_remove_slash    # 補完が/で終って、つぎが、語分割子か/かコマンド
                # の後(; とか & )だったら、補完末尾の/を取る
setopt extended_history     # ヒストリに時刻情報もつける
setopt extended_glob        # グロブで、特殊文字"#,~,^"を使う、
setopt FUNCTION_ARGZERO     #  $0 にスクリプト名/シェル関数名を格納
setopt APPEND_HISTORY

setopt hist_ignore_dups         # 前のコマンドと同じならヒストリに入れない
setopt hist_ignore_space    # 空白ではじまるコマンドをヒストリに保持しない
setopt HIST_IGNORE_ALL_DUPS     # 重複するヒストリを持たない
setopt HIST_NO_FUNCTIONS    # 関数定義をヒストリに入れない
setopt HIST_NO_STORE        # history コマンドをヒストリに入れない
setopt HIST_REDUCE_BLANKS   # 履歴から冗長な空白を除く
setopt MULTIOS          # 名前付きパイプ的に入出力を複数開ける
setopt NUMERIC_GLOB_SORT    # グロブの数のマッチを辞書式順じゃなくって数値の順
setopt prompt_subst         # プロンプト文字列で各種展開を行なう
setopt no_promptcr              # 改行コードで終らない出力もちゃんと出力する
setopt pushd_ignore_dups    # ディレクトリスタックに、同じディレクトリを入れない
#setopt rm_star_silent      # rm * とかするときにクエリしない
setopt no_beep          # ZLE のエラーでビープしない
#setopt cdable_vars         # cd の引数のdir がないとき ~をつけてみる
setopt SHARE_HISTORY        # 複数プロセスで履歴を共有
setopt SHORT_LOOPS      # loop の短縮形を許す
setopt sh_word_split        # よく判らん
#setopt RC_EXPAND_PARAM         # {}をbash ライクに展開
setopt TRANSIENT_RPROMPT    # 右プロンプトに入力がきたら消す
unsetopt automenu               # メニューで選ぶのうっとおしい
setopt physical                 # 物理的なパスを使用

setopt nocheckjobs              # 終了時にjobが走ってることを確認しない

# Ctrl-D でログアウトするのを抑制する。
setopt  ignore_eof

# グロブがマッチしないときエラーにしない
# http://d.hatena.ne.jp/amt/20060806/ZshNoGlob
#setopt null_glob

# デバッグ用 コマンドラインがどのように展開されたか表示
#setopt xtrace

# 小文字に対して大文字も補完する
# http://www.ex-machina.jp/zsh/index.cgi?FAQ%40zsh%A5%B9%A5%EC#l1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

#途中まで入力した文字から検索
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^P" up-line-or-beginning-search
bindkey "^N" down-line-or-beginning-search

#aliases
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

if [ -x `which less` ]; then
    alias more='less'
fi

alias today="date +%Y%m%d"
alias now="date +%Y%m%d_%H%M"


function diffn(){
    diff -y $* | cat -n
}
function pasten(){
    paste $* | cat -n
}

function eg() {
    egrep -v "^\s*//" $1
}


if [ -x /usr/bin/vim ]; then
    alias vi='vim -X'
    alias view='vim -X -R'
fi
export EDITOR=vi

#typos
alias maek='make'
alias alais='alias'
alias csl='clear'
alias sl=ls
alias mroe=more
alias pdw=pwd

alias xterm='xterm -sb'
#alias emacs='XMODIFIERS=@im=none emacs --no-site-file'

alias -g L='| less'
alias -g M='| more'
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g W='| wc'
alias -g S='| sed'
alias -g A='| awk'
alias -g W='| wc'
alias -g ...='../..'


#http://www.aperiodic.net/phil/prompt/

THRESHOLD_LOAD=100
function hostload {
    ONE=$(LANG=C uptime | sed -e "s/.*load average: \(.*\...\), \(.*\...\), \(.*\...\)/\1/" -e "s/ //g")
    ONEHUNDRED=$(echo -e "scale=0 \n $ONE/0.01 \nquit \n" | \bc)
    if [ $ONEHUNDRED -gt $THRESHOLD_LOAD ]
        then
        HOST_COLOUR='1;31'
        # ライトレッド
    else
        HOST_COLOUR='1;34'
        # ライトブルー
    fi
}


function disk_left() {
    df -hP `pwd`|sed -e '1d;s/.* \([0-9]\+.\+\) \+\([0-9]\+%\) .*/\2% \1/'
}


function precmd(){
    hostload

    disk_left=`disk_left`

    if [[ "$TERM" = "screen" &&  ${#TMUX} -eq 0 ]]; then
    screen -X title $(print -P %~)
    fi
}

preexec () {
    if [[ "$TERM" == "screen" && ${#TMUX} -eq 0 ]]; then
    local CMD=${1[(wr)^(*=*|sudo|-*)]}
    echo -ne "\ek$CMD\e\\"
    fi
}

PROMPT=`echo -n '%{\e]2;[${WINDOW}] ${HOSTNAME} : %(5~,%-2~/.../%2~,%~) \a%}\n%{\e[34m%}%n%{\e[00m%}@%B%{\e[${HOST_COLOUR}m%}${HOSTNAME} %{\e[00m%}%b%S%/ [${disk_left}]%s\n%# ' `



#http://0xcc.net/blog/archives/000032.html
#http://d.hatena.ne.jp/amt/20060804/zsh


# 現在実行中のジョブを表示。
function j { jobs -l; }

function ff(){
    find . -name $1
}

function ducks(){
    du -cks * | sort -g
}
alias dusk=ducks

function nmore(){
    LESSOPEN='|cat -n %s' less $*
}
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

function setenv()
{
    if [ $# -ne 2 ] ; then
        echo "setenv: Too few arguments"
    else
        export $1="$2"
    fi
}

function monew () {
    less `\ls -t $*`
}

function flr ()
{
    for f in `seq 1 1000`; do
        lr $* | tail
        sleep 1
        echo
    done
}


#動作中のプロセスから，誰がこのマシンを使っているか調べる
#alias lu="ps -edf|cut -f 1 -d ' '|sort -u|sed -e '/UID/d;/bin/d;/daemon/d;/nscd/d;/root/d;/ntp/d;/rpc/d;/rpcuser/d;/smmsp/d;/wnn/d;/xfs/d'"
function lu(){
    local tmp="`ypcat passwd|cut -d ':' -f 1|sed -e '/lsf/d'`"
    local tmp=`echo $tmp|sed -e "s/ /|/g"`
    ps -edf|cut -f 1 -d ' '|egrep $tmp|sort -u
}


[[ -f ~/etc/zshrc.local ]] && source ~/etc/zshrc.local

