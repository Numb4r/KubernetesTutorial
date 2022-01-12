#!/bin/sh

TARGET="`pwd`/markdown"
OUTPUT="`pwd`/main"
TMP="/tmp"
[ ! -d $OUTPUT ] && mkdir $OUTPUT
[ ! -d $TMP ] && mkdir $TMP
ARRAY=( 
    "${TARGET}/indice.md"
    "${TARGET}/Nodes.md" 
    "${TARGET}/ConfigMaps.md" 
    "${TARGET}/PersistentVolume.md"
    "${TARGET}/RollbackDeployment.md" 
    "${TARGET}/Referencias.md"
      )


pandoc -f markdown ${ARRAY[@]} metadata.yaml -s -t html -o $TMP/main.html


sed -i '/<header id="title-block-header">/,/<\/header>/d' $TMP/main.html # Comentar essa linha se for gerar um html 

pandoc -f html $TMP/main.html --pdf-engine=xelatex --highlight-style espresso -V colorlinks -V geometry:a4paper -V geometry:margin=1cm -t latex  -o $OUTPUT/main.pdf


# ls $TARGET | grep .md | cut -d . -f 1 | xargs -t -I {} pandoc -f markdown $TARGET/{}.md -s -t html -o $TMP/{}.html

# ls $html/ | grep .html | xargs -I {} sed -i "s/.md/.html/g" $html/{}
# ls $TMP | grep .html | cut -d . -f 1 | xargs -t -I {} pandoc -f html $TMP/{}.html --pdf-engine=xelatex -V colorlinks -t latex  -o $OUTPUT/{}.pdf
