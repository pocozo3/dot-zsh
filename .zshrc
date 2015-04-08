#!/bin/zsh
#
# zshrc: インタラクティブな zsh 実行時の設定
#
################################################################################

#========================================
# 基本設定

## 環境変数
export LANG="ja_JP.UTF-8"

## プラグイン等のパスを追加。
fpath=(${ZDOTDIR}/zsh-completions/src $fpath)

## 色を使えるようにする。
autoload -Uz colors
colors

## フック関数をロードする。
autoload -Uz add-zsh-hook

#========================================
# 色の設定

## LS_COLORS の設定をする。
### git@github.com:seebi/dircolors-solarized.git
eval $(dircolors ${ZDOTDIR}/dircolors-solarized/dircolors.256dark)

#========================================
# コマンドライン編集に関する設定

## Emacsキーバインドを使う。
bindkey -e

## 単語の区切り文字を指定する。
autoload -Uz select-word-style
select-word-style default
### ここで指定した文字は単語区切りとみなされる。
### / も区切りと扱うので、^w でディレクトリ１つ分を削除できる。
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

## 範囲指定できるようにする。
### 例 : mkdir {1-3} で フォルダ1, 2, 3を作れる。
setopt brace_ccl

## コマンドラインでの#以降をコメントと見なす。
setopt interactive_comments

## 範囲指定できるようにする
### 例 : mkdir {1-3} で フォルダ1, 2, 3を作れる
setopt brace_ccl

#========================================
# ディレクトリ移動に関する設定

## ディレクトリ名だけでcdする。
setopt auto_cd
## cdで移動してもpushdと同じようにディレクトリスタックに追加する。
setopt auto_pushd
## カレントディレクトリ中に指定されたディレクトリが見つからなかった場合に
### 移動先を検索するリスト。
cdpath=(~)
## ディレクトリが変わったらディレクトリスタックを表示。
chpwd_functions=($chpwd_functions dirs)
## 同じディレクトリを pushd しない。
setopt pushd_ignore_dups

#========================================
# コマンド履歴に関する設定

## 履歴を保存するファイル
HISTFILE=~/.zsh_history
## メモリ上の履歴数。
HISTSIZE=100000
## 保存する履歴数
SAVEHIST=$HISTSIZE

## zshプロセス間で履歴を共有する。
setopt share_history
## 履歴ファイルにコマンドラインだけではなく実行時刻と実行時間も保存する。
setopt extended_history
## 同じコマンドラインを連続で実行した場合は履歴に登録しない。
setopt hist_ignore_dups
## すでに同じコマンドがある場合は履歴に登録しない。
setopt hist_ignore_all_dups
## 重複するコマンドが保存される時、古い方を削除する。
setopt hist_save_no_dups
## すぐに履歴ファイルに追記する。
setopt inc_append_history
## スペースで始まるコマンドラインは履歴に追加しない。
setopt hist_ignore_space
## 履歴関連のコマンドは履歴に追加しない。
setopt hist_no_store

## マッチしたコマンド履歴を表示できるようにする。
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

## 履歴のインクリメンタルサーチ。
bindkey "^r" history-incremental-pattern-search-backward
bindkey "^s" history-incremental-pattern-search-forward

#========================================
# 補完機能・ファイル名グロブに関する設定

## 補完機能を有効化する。
autoload -Uz compinit
compinit -u

## 補完侯補をメニューから選択する。
### select=2: 補完候補を一覧から選択する。
###           ただし、補完候補が2つ以上なければすぐに補完する。
### interactive: 補完候補を一覧から選択する。
###              補完候補メニューの中からインタラクティブに選択する。
zstyle ':completion:*:default' menu select interactive

## 補完候補がなければより曖昧に候補を探す。
### m:{a-z}={A-Z}: 小文字を大文字に変えたものでも補完。
### r:|[._-]=*: 「.」「_」「-」の前にワイルドカード「*」があるものとして補完。
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=* l:|=*'

### 補完候補をキャッシュする。
zstyle ':completion:*' use-cache yes

## 詳細な情報を使う。
zstyle ':completion:*' verbose yes
zstyle ':completion:*' word yes

## 補完方法の設定。指定した順番に実行する。
### _oldlist 前回の補完結果を再利用する。
### _complete: 補完する。
### _match: globを展開しないで候補の一覧から補完する。
### _ignored: 補完候補にださないと指定したものも補完候補とする。
### _approximate: 似ている補完候補も補完候補とする。
### _prefix: カーソル以降を無視してカーソル位置までで補完する。
### _expand: グロブや変数の展開を行う。
###          もともとあった展開と比べて、細かい制御が可能。
### _history: 履歴から補完を行う。
zstyle ':completion:*' completer _oldlist _expand _complete _match _prefix _approximate _list _history

## 展開する前に補完候補上にカーソルを出す。
bindkey "^I" menu-complete
## Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)。
bindkey '^[[Z' reverse-menu-complete

## カーソル位置で補完する。
setopt complete_in_word
## 補完時にヒストリを自動的に展開する。
setopt hist_expand
## --prefix=~/localというように「=」の後でも
### 「~」や「=コマンド」などのファイル名展開を行う。
setopt magic_equal_subst
## カッコの対応などを自動的に補完。
setopt auto_param_keys
## ディレクトリ名の補完で末尾に/を自動的に付加。
setopt auto_param_slash
## パスの最後の/を削除しない。
setopt noautoremoveslash
## カーソル位置は保持したままファイル名一覧を順次その場で表示。
setopt always_last_prompt
## 補完候補一覧でファイルの種別を識別マーク(ls -F の記号)表示。
setopt list_types

## globを展開しないで候補の一覧から補完する。
setopt glob_complete
## 辞書順ではなく数字順に並べる。
setopt numeric_glob_sort
## 拡張globを有効にする。
### glob中で「(#...)」という書式で指定する。
setopt extended_glob
## globでパスを生成したときに、パスがディレクトリだったら最後に「/」をつける。
setopt mark_dirs
## 明確なドットの指定なしで.から始まるファイルをマッチ。
setopt globdots

## 補完リストの表示指定。
### 詳細な情報を使う。
zstyle ':completion:*' verbose yes
### LS_COLORS を補完候補に適用する。
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
### 補完候補のリスト項目名
zstyle ':completion:*' group-name ''
zstyle ':completion:*' auto-description "%{${fg[yellow]}%}%S%B%Specify:%s%{${fg[yellow]}%} %d%b%{${reset_color}%}"
zstyle ':completion:*:descriptions' format "%{${fg[green]}%}%S%BCompleting:%s%{${fg[green]}%} %d%b%{${reset_color}%}"
zstyle ':completion:*:messages' format "%{${fg[yellow]}%}%B%d%b%{${reset_color}%}"
zstyle ':completion:*:warnings' format "%{${fg[red]}%}%S%BNo matches for:%s%{${fg[yellow]}%} %d%b%{${reset_color}%}"
zstyle ':completion:*:corrections' format "%{${fg[yellow]}%}%B%d %{${fg[red]}%}(errors: %e)%b%{${reset_color}%}"
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*' list-prompt "%{${fg[blue]}%}%S%BAt %p: Hit TAB for more, or the character to insert%b%s%{${reset_color}%}"
zstyle ':completion:*' select-prompt "%{${fg[blue]}%}%S%BScrolling active: current selection at %p%b%s%{${reset_color}%}"
### manの補完をセクション番号別に表示させる。
zstyle ':completion:*:manuals' separate-sections true
### オブジェクトファイルとか中間ファイルとかはfileとして補完させない。
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'

#========================================
# バージョン管理システム情報取得の設定

## バージョン管理システム情報取得の有効化。
autoload -Uz vcs_info
## gitのみ有効にする
zstyle ':vcs_info:*' enable git
## commitしていない変更をチェックする
zstyle ':vcs_info:git:*' check-for-changes true
## commitしていないstageがあることを示す文字列
zstyle ':vcs_info:git:*' stagedstr '+'
## addしていない変更があることを示す文字列
zstyle ':vcs_info:git:*' unstagedstr '-'
## gitリポジトリに対して、変更情報とリポジトリ情報を表示する
zstyle ':vcs_info:*' formats \
       '%{%F{green}%}%c%{%f%}%{%F{red}%}%u%{%f%}(%{%F{white}%K{green}%}%s%{%f%k%})-[%{%F{white}%K{blue}%}%b%{%f%k%}]'
## gitリポジトリに対して、コンフリクトなどの情報を表示する
zstyle ':vcs_info:*' actionformats \
       '%{%F{white}%K{green}%}%c%{%f%k%}%{%F{white}%K{red}%}%u%{%f%k%}(%{%F{white}%K{green}%}%s%{%f%k%})-<%{%F{black}%K{white}%}%r%{%f%k%}>-[%{%F{white}%K{blue}%}%b%{%f%k%}|%{%F{white}%K{red}%}%a%{%f%k%}]'

#========================================
# プロンプトの設定

## プロンプト内で変数展開・コマンド置換・算術演算を実行する。
setopt prompt_subst
## プロンプト内で「%」文字から始まる置換機能を有効にする。
setopt prompt_percent
## コピペしやすいようにコマンド実行後は右プロンプトを消す。
setopt transient_rprompt

## プロンプトの作成
### ↓のようにする。
###   -(user@debian)-(0)-<2011/09/01 00:54>---------------[/home/user]-
###   -[84](0)%                                                    [~]
### プロンプトバーの左側
###   %{%B%}...%{%b%}: 「...」を太字にする。
###   %{%F{cyan}%}...%{%f%}: 「...」をシアン色の文字にする。
###   %n: ユーザ名
###   %m: ホスト名（完全なホスト名ではなくて短いホスト名）
###   %{%B%F{white}%(?.%K{green}.%K{red})%}%?%{%f%k%b%}:
###                           最後に実行したコマンドが正常終了していれば
###                           太字で白文字で緑背景にして異常終了していれば
###                           太字で白文字で赤背景にする。
###   %{%F{white}%}: 白文字にする。
###     %(x.true-text.false-text): xが真のときはtrue-textになり
###                                偽のときはfalse-textになる。
###       ?: 最後に実行したコマンドの終了ステータスが0のときに真になる。
###       %K{green}: 緑景色にする。
###       %K{red}: 赤景色を赤にする。
###   %?: 最後に実行したコマンドの終了ステータス
###   %{%k%}: 背景色を元に戻す。
###   %{%f%}: 文字の色を元に戻す。
###   %{%b%}: 太字を元に戻す。
###   %D{%Y/%m/%d %H:%M}: 日付。「年/月/日 時:分」というフォーマット。
prompt_bar_left_self="(%{%B%}%n%{%b%}%{%F{cyan}%}@%{%f%}%{%B%}%m%{%b%})"
###   ssh でのログイン時はアンダーラインを引く。
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
    prompt_bar_left_self="%{%U%}(%{%B%}%n%{%b%}%{%F{cyan}%}@%{%f%}%{%B%}%m%{%b%})%{%u%}"
;
prompt_bar_left_status="(%{%B%F{white}%(?.%K{green}.%K{red})%}%?%{%k%f%b%})"
prompt_bar_left_date="<%{%B%}%D{%Y/%m/%d %H:%M}%{%b%}>"
prompt_bar_left="-${prompt_bar_left_self}-${prompt_bar_left_status}-${prompt_bar_left_date}-"
### プロンプトバーの右側
###   %{%B%K{magenta}%F{white}%}...%{%f%k%b%}:
###       「...」を太字のマゼンタ背景の白文字にする。
###   %d: カレントディレクトリのフルパス（省略しない）
prompt_bar_right="-[%{%B%K{magenta}%F{white}%}%d%{%f%k%b%}]-"
### 2行目左にでるプロンプト。
###   %h: ヒストリ数。
###   %(1j,(%j),): 実行中のジョブ数が1つ以上ある場合だけ「(%j)」を表示。
###     %j: 実行中のジョブ数。
###   %{%B%}...%{%b%}: 「...」を太字にする。
###   %#: 一般ユーザなら「%」、rootユーザなら「#」になる。
case ${UID} in
    0)
        prompt_left="-[%h]%(1j,(%j),)%{%B%F{red}%}%#%{%f%}%{%b%} "
        ;;
    *)
        prompt_left="-[%h]%(1j,(%j),)%{%B%F{white}%}%#%{%f%}%{%b%} "
        ;;
esac

## プロンプト表示用サポート関数
### プロンプトフォーマットを展開した後の文字数を返す。
### (日本語未対応)
count_prompt_characters()
{
    ### print:
    ###   -P: プロンプトフォーマットを展開する。
    ###   -n: 改行をつけない。
    ### sed:
    ###   -e $'s/\e\[[0-9;]*m//g': ANSIエスケープシーケンスを削除。
    ### wc:
    ###   -c: 文字数を出力する。
    ### sed:
    ###   -e 's/ //g':
    ###       *BSDやMac OS Xのwcは数字の前に空白を出力するので削除する。
    print -n -P -- "$1" | sed -e $'s/\e\[[0-9;]*m//g' | wc -m | sed -e 's/ //g'
}

### プロンプトを更新する。
update_prompt()
{
    ### プロンプトバーの左側の文字数を数える。
    ### 左側では最後に実行したコマンドの終了ステータスを使って
    ### いるのでこれは一番最初に実行しなければいけない。そうし
    ### ないと、最後に実行したコマンドの終了ステータスが消えて
    ### しまう。
    local bar_left_length=$(count_prompt_characters "$prompt_bar_left")
    ### プロンプトバーに使える残り文字を計算する。
    ### $COLUMNSにはターミナルの横幅が入っている。
    local bar_rest_length=$[COLUMNS - bar_left_length]
    local bar_left="$prompt_bar_left"
    ### パスに展開される「%d」を削除。
    local bar_right_without_path="${prompt_bar_right:s/%d//}"
    ### 「%d」を抜いた文字数を計算する。
    local bar_right_without_path_length=$(count_prompt_characters "$bar_right_without_path")
    ### パスの最大長を計算する。
    ###   $[...]: 「...」を算術演算した結果で展開する。
    local max_path_length=$[bar_rest_length - bar_right_without_path_length]
    ### パスに展開される「%d」に最大文字数制限をつける。
    ###   %d -> %(C,%${max_path_length}<...<%d%<<,)
    ###     %(x,true-text,false-text):
    ###         xが真のときはtrue-textになり偽のときはfalse-textになる。
    ###         ここでは、「%N<...<%d%<<」の効果をこの範囲だけに限定させる
    ###         ために用いているだけなので、xは必ず真になる条件を指定している。
    ###       C: 現在の絶対パスが/以下にあると真。なので必ず真になる。
    ###       %${max_path_length}<...<%d%<<:
    ###          「%d」が「${max_path_length}」カラムより長かったら、
    ###          長い分を削除して「...」にする。最終的に「...」も含めて
    ###          「${max_path_length}」カラムより長くなることはない。
    bar_right=${prompt_bar_right:s/%d/%(C,%${max_path_length}<...<%d%<<,)/}
    ### 「${bar_rest_length}」文字分の「-」を作っている。
    ### どうせ後で切り詰めるので十分に長い文字列を作っているだけ。
    ### 文字数はざっくり。
    local separator="${(l:${bar_rest_length}::-:)}"
    ### プロンプトバー全体を「${bar_rest_length}」カラム分にする。
    ###   %${bar_rest_length}<<...%<<:
    ###     「...」を最大で「${bar_rest_length}」カラムにする。
    bar_right="%${bar_rest_length}<<${separator}${bar_right}%<<"
    ### プロンプトバーと左プロンプトを設定
    ###   "${bar_left}${bar_right}": プロンプトバー
    ###   $'\n': 改行
    ###   "${prompt_left}": 2行目左のプロンプト
    PROMPT="${bar_left}${bar_right}"$'\n'"${prompt_left}"
    ### 右プロンプト
    ###   %{%B%F{white}%K{green}}...%{%k%f%b%}:
    ###       「...」を太字で緑背景の白文字にする。
    ###   %~: カレントディレクトリのフルパス（可能なら「~」で省略する）
    RPROMPT="[%{%B%F{white}%K{magenta}%}%~%{%k%f%b%}]"
    ### バージョン管理システムの情報を取得する。
    LANG=en_US.UTF-8 vcs_info >&/dev/null
    #### バージョン管理システムの情報があったら右プロンプトに表示する。
    if [ -n "$vcs_info_msg_0_" ]; then
        RPROMPT="${vcs_info_msg_0_}-${RPROMPT}"
    fi
}

## コマンド実行前に呼び出されるフック。
add-zsh-hook precmd update_prompt

#========================================
# その他の設定

## 日本語ファイル名を表示可能にする。
setopt print_eight_bit
## C-sでの検索が潰されてしまうため、出力停止・開始用にC-s/C-qを使わない。
setopt no_flow_control
## ^Dでログアウトしないようにする。
setopt ignore_eof
## beep を鳴らさない
setopt no_beep
## 補完候補表示時にビープ音を鳴らさない。
setopt nolistbeep

#========================================
# エイリアスの設定

## lsコマンドの設定
alias ls='ls -aF --color=auto'
alias la='ls -laFh --color=auto --group-directories-first'

## 単位を見やすくする
alias du='du -h'
alias df='df -h'
alias history='history -i'

## ファイル操作を確認する。
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

## lvの設定
if [ "$PAGER" != "lv" ]; then
    ### lvがなくてもlvでページャーを起動する。
    alias lv="$PAGER"
else
    alias lv='lv'
fi

## grepの設定
### grepのバージョンを検出。
grep_version="$(grep --version | head -n 1 | sed -e 's/^[^0-9.]*\([0-9.]*\)[^0-9.]*$/\1/')"
### バイナリファイルにはマッチさせない。
MY_GREP_OPTIONS="--binary-files=without-match"
### 拡張子が.tmpのファイルは無視する。
MY_GREP_OPTIONS="--exclude=\*.tmp $MY_GREP_OPTIONS"
### 管理用ディレクトリを無視する。
if grep --help 2>&1 | grep -q -- --exclude-dir; then
    MY_GREP_OPTIONS="--exclude-dir=.svn $MY_GREP_OPTIONS"
    MY_GREP_OPTIONS="--exclude-dir=.git $MY_GREP_OPTIONS"
    MY_GREP_OPTIONS="--exclude-dir=.deps $MY_GREP_OPTIONS"
    MY_GREP_OPTIONS="--exclude-dir=.libs $MY_GREP_OPTIONS"
fi
### 可能なら色を付ける。
if grep --help 2>&1 | grep -q -- --color; then
    MY_GREP_OPTIONS="--color=auto $MY_GREP_OPTIONS"
fi
alias grep="grep $MY_GREP_OPTIONS"

## Emacsの設定
### emacsclient
alias emc='emacsclient'
### emacs をターミナル上で開く
alias emacsnw='TERM=xterm-16color emacs -nw'

## Gitの設定
alias g='git'

## グローバルエイリアス
alias -g L="|& $PAGER"
alias -g G='| grep'
alias -g H='| head'
alias -g T='| tail'
alias -g S='| sed'
alias -g N='| nkf -w'

#========================================
# zshrc のコンパイル設定

## .zshrc.zwc が存在する、かつ .zshrc の方が新しい時に自動コンパイルする。
if [ ${ZDOTDIR}/.zshrc -nt ${ZDOTDIR}/.zshrc.zwc ]; then
   zcompile ${ZDOTDIR}/.zshrc
fi

#========================================
# 環境依存のカスタマイズ読み込み

case ${OSTYPE} in
    cygwin*) # Windows用設定
        source ${ZDOTDIR}/.zshrc.cygwin
        ;;
    linux*) # Linux用設定
        source ${ZDOTDIR}/.zshrc.linux
        ;;
esac
