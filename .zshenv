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

## lvのオプション
### -c: ANSIエスケープシーケンスの色付けなどを有効にする。
### -l: 1行が長く折り返されていても1行として扱う。
###     コピーしたときに余計な改行を入れない
export LV="-c -l"

## lessのオプション
### -F: ファイル全体が最初の画面に収まるように終了する
### -i: ドキュメント内検索する時に検索ワードに大文字が入ってない限り
###     大文字小文字を区別しない
### -M: 自分が見てる行数やそのパーセンテージや開いてるファイル名を表示する
### -R: ANSIエスケープシーケンスの色付けなどを有効にする。
### -S: 1行が画面に入りきらない場合に折り返さない
### -X: 表示させていた画面をそのまま残す
export LESS="-F -i -M -R -S -X"

## zsh 設定ファイル用ディレクトリの設定
export ZDOTDIR="${HOME}/.zsh.d"

#========================================
# 環境依存のカスタマイズ読み込み

case ${OSTYPE} in
    cygwin*) # Cygwin用設定
        source ${ZDOTDIR}/.zshenv.cygwin
        ;;
    msys*) # MSYS2用設定
        source ${ZDOTDIR}/.zshenv.msys
        ;;
    linux*) # Linux用設定
        source ${ZDOTDIR}/.zshenv.linux
        ;;
esac
