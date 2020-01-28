#!/bin/bash
# SINGLE line images using text2image - don't split file among fonts - ckb20
#  text with no numbers or punctuation 
# nohup bash -x 1-txt2lstmf-all.sh  ckb20 > 1-ckb20.log & 

unicodefontdir=/home/ubuntu/.fonts/ckb
MODEL=$1
prefix=gt/$MODEL
rm -rf ${prefix} ${prefix}-200
mkdir  ${prefix} ${prefix}-200

traininginput=langdata/$MODEL.txt
fontlist=langdata/ckballfonts.fontslist.txt
fontcount=$(wc -l < "$fontlist")
linecount=$(wc -l < "$traininginput")

# files created by script during processing
fonttext=/tmp/$MODEL-file-train.txt
linetext=/tmp/$MODEL-line-train.txt

 while IFS= read -r fontname
     do
        cp ${traininginput} ${fonttext}
        for cnt in $(seq 1 $linecount) ; do
            head -1 ${fonttext} > ${linetext}
             sed -i  "1,1  d"  ${fonttext}
             OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir" --text="${linetext}" --strip_unrenderable_words=false --xsize=2500 --ysize=300  --leading=32 --margin=12 --exposure=0  --font="$fontname"   --outputbase="$prefix"/"${fontname// /_}.300.$cnt.exp0" 
            cp "$linetext" "$prefix"/"${fontname// /_}.300.$cnt.exp0".gt.txt
            OMP_THREAD_LIMIT=1  tesseract "$prefix"/"${fontname// /_}.300.$cnt.exp0".tif "$prefix"/"${fontname// /_}.300.$cnt.exp0" -l ara --psm 13 --dpi 300 lstm.train  
             OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir" --text="${linetext}" --strip_unrenderable_words=false --xsize=2500 --ysize=300  --leading=32 --margin=12 --exposure=0  --font="$fontname"  --resolution=200  --outputbase=$prefix-200/"${fontname// /_}.200.$cnt.exp0" 
            cp "$linetext" $prefix-200/"${fontname// /_}.200.$cnt.exp0".gt.txt
            OMP_THREAD_LIMIT=1  tesseract $prefix-200/"${fontname// /_}.200.$cnt.exp0".tif $prefix-200/"${fontname// /_}.200.$cnt.exp0" -l ara --psm 13 --dpi 200 lstm.train  
         done
        ls -1  $prefix/*${fontname// /_}.*.lstmf > data/all-${fontname// /_}-$MODEL-lstmf
        ls -1  $prefix-200/*${fontname// /_}.*.lstmf > data/all-${fontname// /_}-$MODEL-200-lstmf
        echo "Done with ${fontname// /_}"
     done < "$fontlist"
echo "All Done"
