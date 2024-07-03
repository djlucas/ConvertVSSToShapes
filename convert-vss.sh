#! /bin/bash

VSS_DIR=./VSS
EXPORT=./Export
TEMPDIR=$(mktemp -d)

mkdir -p ${EXPORT}/{sheets,shapes}

for file in ${VSS_DIR}/*.vss
do
    name=$(echo ${file} | sed -e 's@\./VSS/@@' -e "s@'@@g" -e 's@ (US units)@@' -e 's@ @_@g' -e 's@\.vss@@')
    sheetname=$(echo "${name}" | sed 's@_@ @g')
    echo "${name}"
    mkdir -p ${EXPORT}/shapes/${name}
    /usr/bin/vss2svg-conv -i "${file}" -o ${EXPORT}/shapes/${name} -s 7

    echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > ${EXPORT}/sheets/${name}.sheet
    echo "<sheet xmlns=\"http://www.lysator.liu.se/~alla/dia/dia-sheet-ns\">" >> ${EXPORT}/sheets/${name}.sheet
    echo "  <name>${sheetname}</name>" >> ${EXPORT}/sheets/${name}.sheet
    echo "  <description>${name}</description>" >> ${EXPORT}/sheets/${name}.sheet
    echo "  <contents>" >> ${EXPORT}/sheets/${name}.sheet

    for file in `find ${EXPORT}/shapes/${name} -name "*.svg"`
    do
        echo "Processing ${file}..."
        NAME=$(basename ${file} | sed 's@\.svg@@')
        DIR=$(dirname ${file})
	DNAME=$(echo $NAME | sed 's@_@ @g')
	dbus-run-session inkscape --export-plain-svg=${TEMPDIR}/${NAME}.svg ${file} 2>/dev/null
        rsvg-convert -a -w 18 ${TEMPDIR}/${NAME}.svg -o ${DIR}/${NAME}.png
        cat ${TEMPDIR}/${NAME}.svg | xsltproc --stringparam icon-file ${NAME}.png svg2shape.xslt - > ${DIR}/${NAME}.shape
	sed "s@<name/>@<name>${DNAME}</name>@" -i ${DIR}/${NAME}.shape
        rm -f ${file} ${TEMPDIR}/${NAME}.svg
	echo "    <object name=\"${DNAME}\"><description>${DNAME}</description></object>" >> ${EXPORT}/sheets/${name}.sheet
    done
    echo "  </contents>" >> ${EXPORT}/sheets/${name}.sheet
    echo "</sheet>" >> ${EXPORT}/sheets/${name}.sheet
done

rm -rf ${TEMPDIR}
