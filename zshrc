#!/bin/zsh
#
# zshrc: インタラクティブな zsh 実行時の設定
#
################################################################################

#========================================
# 基本設定

## 環境変数
export LANG="ja_JP.UTF-8"

## 色を使えるようにする。
autoload -Uz colors
colors

## フック関数をロードする。
autoload -Uz add-zsh-hook

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

#========================================
# ディレクトリ移動に関する設定

## ディレクトリ名だけでcdする。
setopt auto_cd

## cdで移動してもpushdと同じようにディレクトリスタックに追加する。
setopt auto_pushd

## カレントディレクトリ中に指定されたディレクトリが見つからなかった場合に
## 移動先を検索するリスト。
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
# 補完機能に関する設定

## 補完機能を有効化する。
autoload -Uz compinit
compinit

## 補完侯補をメニューから選択する。
### select=2: 補完候補を一覧から選択する。
###           ただし、補完候補が2つ以上なければすぐに補完する。
zstyle ':completion:*:default' menu select=2

## 補完候補がなければより曖昧に候補を探す。
### m:{a-z}={A-Z}: 小文字を大文字に変えたものでも補完する。
### r:|[._-]=*: 「.」「_」「-」の前にワイルドカード「*」があるものとして補完する。
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=* l:|=*'

#========================================
# 色の設定 (ls・補完候補)

## LS_COLORS の設定をする。
### git@github.com:seebi/dircolors-solarized.git
eval $(dircolors ${ZDOTDIR}/dircolors-solarized/dircolors.256dark)

## LS_COLORS を補完候補に適用する。
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

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

#========================================
# エイリアスの設定

## ls系
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

#========================================
# 環境依存のカスタマイズ読み込み

case ${OSTYPE} in
    cygwin*) # Windows用設定
        source ${ZDOTDIR}/zshrc.cygwin
        ;;
    linux*) # Linux用設定
        source ${ZDOTDIR}/zshrc.linux
        ;;
esac
