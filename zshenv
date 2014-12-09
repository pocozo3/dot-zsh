#!/bin/zsh
#
# zshenv: 全ての zsh 実行時の設定
#
################################################################################

#========================================
# 環境変数

## 重複したパスを登録しない。
typeset -U path
## (N-/): 存在しないディレクトリは登録しない。
path=(/usr/local/bin(N-/)
      /usr/bin(N-/)
      /bin(N-/)
      $path)

## ページャの設定
if type lv > /dev/null 2>&1; then
    ## lvを優先する。
    export PAGER="lv"
else
    ## lvがなかったらlessを使う。
    export PAGER="less"
fi

## エディタの設定
export EDITOR="emacsclient"

## zsh 設定ファイル用ディレクトリの設定
export ZDOTDIR="${HOME}/.zsh.d"

#========================================
# 環境依存のカスタマイズ読み込み

case ${OSTYPE} in
    cygwin*) # Windows用設定
        source ${HOME}/zshenv.cygwin
        ;;
    linux*) # Linux用設定
        source ${HOME}/zshenv.linux
        ;;
esac

