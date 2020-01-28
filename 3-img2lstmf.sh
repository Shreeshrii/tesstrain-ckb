#!/bin/bash
# nohup bash  3-img2lstmf.sh ckb > 3-ckb.log & 
# psm 13 for single line images

export PYTHONIOENCODING=utf8
ulimit -s 65536
SCRIPTPATH=`pwd`
MODEL=$1
fontlist=langdata/$MODEL.fontslist.txt
while IFS= read -r fontname
     do
        prefix=gt/$MODEL-"${fontname// /_}"
        my_files=$(ls "$prefix"/*${fontname// /_}.*.tif)
        for my_file in ${my_files}; do
            echo  "${my_file}"
            python3 $SCRIPTPATH/generate_wordstr_box.py -t "${my_file%.*}".gt.txt  -i  "${my_file}" --rtl > "${my_file%.*}".box
            OMP_THREAD_LIMIT=1  tesseract "${my_file}" "${my_file%.*}" -l ara --psm 13 --dpi 200  lstm.train    1>/dev/null 2>&1
        done
        ls -1  "$prefix"/*${fontname// /_}.*.lstmf > $SCRIPTPATH/data/all-${fontname// /_}-$MODEL-lstmf
        echo "Done with ${fontname// /_}"
     done < "$fontlist"

echo "All Done"
