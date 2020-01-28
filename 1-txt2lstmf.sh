#!/bin/bash
# SINGLE line images using text2image - ckb20
# nohup bash -x 1-txt2lstmf.sh  ckb20 > 1-ckb20.log & 

unicodefontdir=/home/ubuntu/.fonts/ckb
prefix=gt/$1
rm -rf ${prefix} ${prefix}-200
mkdir  ${prefix} ${prefix}-200

traininginput=langdata/$1.txt
fontlist=langdata/ckb.fontslist.txt
fontcount=$(wc -l < "$fontlist")
linecount=$(wc -l < "$traininginput")
perfontcount=$(( linecount / fontcount))
numlines=1
numfiles=$(( perfontcount / numlines))

# files created by script during processing
trainingtext=/tmp/$1-train.txt
fonttext=/tmp/$1-file-train.txt
linetext=/tmp/$1-line-train.txt

cp ${traininginput} ${trainingtext} 
 
 while IFS= read -r fontname
     do
        head -$perfontcount ${trainingtext} > ${fonttext}
        sed -i  "1,$perfontcount d"  ${trainingtext}
        for cnt in $(seq 1 $numfiles) ; do
            head -$numlines ${fonttext} > ${linetext}
             sed -i  "1,$numlines  d"  ${fonttext}
             OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir" --text="${linetext}" --strip_unrenderable_words=false --xsize=2500 --ysize=300  --leading=32 --margin=12 --exposure=0  --font="$fontname"   --outputbase="$prefix"/"${fontname// /_}.300.$cnt.exp0" 
            cp "$linetext" "$prefix"/"${fontname// /_}.300.$cnt.exp0".gt.txt
            OMP_THREAD_LIMIT=1  tesseract "$prefix"/"${fontname// /_}.300.$cnt.exp0".tif "$prefix"/"${fontname// /_}.300.$cnt.exp0" -l ara --psm 13 --dpi 300 lstm.train  
             OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir" --text="${linetext}" --strip_unrenderable_words=false --xsize=2500 --ysize=300  --leading=32 --margin=12 --exposure=0  --font="$fontname"  --resolution=200  --outputbase=$prefix-200/"${fontname// /_}.200.$cnt.exp0" 
            cp "$linetext" $prefix-200/"${fontname// /_}.200.$cnt.exp0".gt.txt
            OMP_THREAD_LIMIT=1  tesseract $prefix-200/"${fontname// /_}.200.$cnt.exp0".tif $prefix-200/"${fontname// /_}.200.$cnt.exp0" -l ara --psm 13 --dpi 200 lstm.train  
         done
        ls -1  $prefix/*${fontname// /_}.*.lstmf > data/all-${fontname// /_}-$1-lstmf
        ls -1  $prefix-200/*${fontname// /_}.*.lstmf > data/all-${fontname// /_}-$1-200-lstmf
        echo "Done with ${fontname// /_}"
     done < "$fontlist"
echo "All Done"


