#!/bin/sh

TARGET="`pwd`/markdown"
OUTPUT="`pwd`/main"
TMP="/tmp"
[ ! -d $OUTPUT ] && mkdir $OUTPUT
ls $TARGET | grep .md | cut -d . -f 1 | xargs -t -I {} pandoc -f markdown $TARGET/{}.md -o $TMP/{}.html
ls $TMP | grep .html | cut -d . -f 1 | xargs -t -I {} pandoc -f html $TMP/{}.html --pdf-engine=xelatex -V colorlinks  -o $OUTPUT/{}.pdf