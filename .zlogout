#!/bin/zsh
#
# zlogout: zsh 終了時の設定
#
################################################################################

#========================================
# 環境依存のカスタマイズ読み込み

case ${OSTYPE} in
    cygwin*) # Cygwin用設定
        source ${ZDOTDIR}/.zlogout.cygwin
        ;;
    msys*) # MSYS2用設定
        source ${ZDOTDIR}/.zlogout.msys
        ;;
    linux*) # Linux用設定
        source ${ZDOTDIR}/.zlogout.linux
        ;;
esac
