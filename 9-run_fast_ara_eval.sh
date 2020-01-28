#!/bin/sh
# nohup time -p bash  9-run_fast_ara_eval.sh Arabic ckb > reports/9-Arabic.txt & 

SCRIPTPATH=`pwd`
LANG=$2
MODEL=$1
FASTMODEL=fast_${MODEL}
FONTLIST=$SCRIPTPATH/langdata/$LANG.fontslist.txt

mkdir -p $SCRIPTPATH/reports
for PREFIX in $LANG  ; do
    LISTEVAL=$SCRIPTPATH/data/$PREFIX/list.eval
    REPORTSPATH=$SCRIPTPATH/reports/$PREFIX-eval-${FASTMODEL}
    rm -rf $REPORTSPATH
    mkdir $REPORTSPATH
    echo -e  "\n-----------------------------------------------------------------------------"  $PREFIX 
    while IFS= read -r FONTNAME
    do
        ### echo "$SCRIPTPATH" > $REPORTSPATH/manifest-$PREFIX-"${FONTNAME// /_}".log
		echo -e "\n ********************Arabic ***** $PREFIX-${FONTNAME// /_} ********************\n"
        while IFS= read -r LSTMFNAME
        do
            if [[ "$LSTMFNAME" == *"${FONTNAME// /_}."* ]]; then
                  ### echo "${LSTMFNAME%.*}.tif" >> $REPORTSPATH/manifest-$PREFIX-"${FONTNAME// /_}".log
                  OMP_THREAD_LIMIT=1 tesseract "${LSTMFNAME%.*}.tif"  "${LSTMFNAME%.*}-"${FASTMODEL} --psm 7 --oem 1  -l ${FASTMODEL} --tessdata-dir $SCRIPTPATH/data  -c page_separator=''   1>/dev/null 2>&1
                  cat "${LSTMFNAME%.*}".gt.txt   >>  "$REPORTSPATH/gt-$PREFIX-${FONTNAME// /_}.txt"
                  cat "${LSTMFNAME%.*}"-${FASTMODEL}.txt   >>  "$REPORTSPATH/ocr-${FASTMODEL}-$PREFIX-${FONTNAME// /_}.txt"
            fi
        done < "$LISTEVAL"
        ocrevalutf8 accuracy "$REPORTSPATH/gt-$PREFIX-${FONTNAME// /_}.txt"  "$REPORTSPATH/ocr-${FASTMODEL}-$PREFIX-${FONTNAME// /_}.txt"  > "$REPORTSPATH/report_${FASTMODEL}-$PREFIX-${FONTNAME// /_}.txt"
        java -cp ~/ocrevaluation/ocrevaluation.jar  eu.digitisation.Main  -gt "$REPORTSPATH/gt-$PREFIX-${FONTNAME// /_}.txt"  -ocr "$REPORTSPATH/ocr-${FASTMODEL}-$PREFIX-${FONTNAME// /_}.txt"   -e UTF-8   -o "$REPORTSPATH/report_${FASTMODEL}-$PREFIX-${FONTNAME// /_}.html"  1>/dev/null 2>&1
        head -26 "$REPORTSPATH/report_${FASTMODEL}-$PREFIX-${FONTNAME// /_}.txt"
        cat "$REPORTSPATH/gt-$PREFIX-${FONTNAME// /_}.txt"  >> $REPORTSPATH/gt-$PREFIX-ALL.txt 
        cat "$REPORTSPATH/ocr-${FASTMODEL}-$PREFIX-${FONTNAME// /_}.txt"  >> $REPORTSPATH/ocr-${FASTMODEL}-$PREFIX-ALL.txt 
        echo -e  "\n-----------------------------------------------------------------------------"  
        echo "Finished $FONTNAME"
        done < "$FONTLIST"
        java -cp ~/ocrevaluation/ocrevaluation.jar  eu.digitisation.Main  -gt $REPORTSPATH/gt-$PREFIX-ALL.txt  -ocr $REPORTSPATH/ocr-${FASTMODEL}-$PREFIX-ALL.txt  -e UTF-8   -o "$REPORTSPATH/report_${FASTMODEL}-$PREFIX-ALL.html"      1>/dev/null 2>&1
        echo -e  "\n-----------------------------------------------------------------------------" 
echo "Finished $PREFIX"
done 

egrep 'Arabic|Accuracy$|Digits|Punctuation' reports/9-Arabic.txt > reports/9-Arabic-summary.txt
