#!/bin/sh
# nohup time -p bash   8-run_tune_eval.sh ckb Layer > reports/8-ckb-Layer.txt & 

SCRIPTPATH=`pwd`
LANG=$1
BUILDTYPE=$2
CHECKPOINT=${LANG}${BUILDTYPE}
MODEL=${CHECKPOINT}_fast
FONTLIST=$SCRIPTPATH/langdata/$LANG.fontslist.txt

mkdir -p $SCRIPTPATH/reports
for PREFIX in $LANG ; do
    LISTEVAL=$SCRIPTPATH/data/$PREFIX/list.eval
    REPORTSPATH=$SCRIPTPATH/reports/$PREFIX-eval-${MODEL}
    rm -rf $REPORTSPATH
    mkdir $REPORTSPATH
    echo -e  "\n-----------------------------------------------------------------------------"  $PREFIX 
    while IFS= read -r FONTNAME
    do
        ### echo "$SCRIPTPATH" >  $REPORTSPATH/manifest-$PREFIX-"${FONTNAME// /_}".log
		echo -e "\n ******************** $PREFIX-${FONTNAME// /_} ********************\n"
        while IFS= read -r LSTMFNAME
        do
            if [[ "$LSTMFNAME" == *"${FONTNAME// /_}."* ]]; then
                  ### echo "${LSTMFNAME%.*}.tif" >> $REPORTSPATH/manifest-$PREFIX-"${FONTNAME// /_}".log
                  OMP_THREAD_LIMIT=1 tesseract "${LSTMFNAME%.*}.tif"  "${LSTMFNAME%.*}-"${MODEL} --psm 7 --oem 1  -l ${MODEL} --tessdata-dir $SCRIPTPATH/data  -c page_separator=''   1>/dev/null 2>&1
                  cat "${LSTMFNAME%.*}".gt.txt   >>  "$REPORTSPATH/gt-$PREFIX-"${FONTNAME// /_}".txt"
                  cat "${LSTMFNAME%.*}"-${MODEL}.txt   >>  "$REPORTSPATH/ocr-${MODEL}-$PREFIX-"${FONTNAME// /_}".txt"
            fi
        done < "$LISTEVAL"
         accuracy "$REPORTSPATH/gt-$PREFIX-"${FONTNAME// /_}".txt"  "$REPORTSPATH/ocr-${MODEL}-$PREFIX-"${FONTNAME// /_}".txt"  > "$REPORTSPATH/report_${MODEL}-$PREFIX-"${FONTNAME// /_}".txt"
        java -cp ~/ocrevaluation/ocrevaluation.jar  eu.digitisation.Main  -gt "$REPORTSPATH/gt-$PREFIX-${FONTNAME// /_}.txt"  -ocr "$REPORTSPATH/ocr-${TRAINEDDATAFILE%.*}-$PREFIX-${FONTNAME// /_}.txt"  -e UTF-8   -o "$REPORTSPATH/report_${TRAINEDDATAFILE%.*}-$PREFIX-${FONTNAME// /_}.html" 
        head -26 "$REPORTSPATH/report_${MODEL}-$PREFIX-"${FONTNAME// /_}".txt"
        echo -e "\n **************** Finished $FONTNAME **********************************\n"
        done < "$FONTLIST"
echo "Finished $PREFIX"
done 
