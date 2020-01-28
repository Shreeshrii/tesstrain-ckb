#!/bin/bash
# SINGLE line images using text2image - delete generated box file
# nohup bash 2-txt2img.sh ckb  > 2-ckb.log & 

unicodefontdir=/home/ubuntu/.fonts/ckb
MODEL=$1

traininginput=langdata/$MODEL.training_text
fontlist=langdata/$MODEL.fontslist.txt
fontcount=$(wc -l < "$fontlist")
linecount=$(wc -l < "$traininginput")
perfontcount=$(( linecount / fontcount))
numlines=1
numfiles=$(( perfontcount / numlines))

# files created by script during processing
trainingtext=/tmp/$MODEL-train.txt
fonttext=/tmp/$MODEL-file-train.txt
linetext=/tmp/$MODEL-line-train.txt

cp ${traininginput} ${trainingtext} 
 
 while IFS= read -r fontname
     do
        prefix=gt/$MODEL-"${fontname// /_}"
        rm -rf ${prefix}
        mkdir  ${prefix} 
        head -$perfontcount ${trainingtext} > ${fonttext}
        sed -i  "1,$perfontcount d"  ${trainingtext}
        for cnt in $(seq 1 $numfiles) ; do
            head -$numlines ${fonttext} > ${linetext}
             sed -i  "1,$numlines  d"  ${fonttext}
             last=${cnt: -1}
             case "$last" in
                  1)    let exp=0
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words=false  --ptsize=12  --resolution=300  --xsize=2550  --ysize=300  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text="$linetext"  --outputbase="$prefix"/${fontname// /_}.$cnt.exp$exp   --degrade_image=false
                       ;;
                  2)  let exp=-1
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words=false  --ptsize=12  --resolution=300  --xsize=2550  --ysize=300  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text="$linetext"  --outputbase="$prefix"/${fontname// /_}.$cnt.exp$exp   --degrade_image=true
                       ;;
                  3)  let exp=0
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words=false  --ptsize=12  --resolution=300  --xsize=2550  --ysize=300  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text="$linetext"  --outputbase="$prefix"/${fontname// /_}.$cnt.exp$exp --degrade_image=true  --distort_image     --invert=false   
                       ;;
                  4)  let exp=-1
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words=false  --ptsize=12  --resolution=300  --xsize=2550  --ysize=300  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text="$linetext"  --outputbase="$prefix"/${fontname// /_}.$cnt.exp$exp  --degrade_image=true  --distort_image     --invert=false   
                       ;;
                  5)  let exp=0
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words=false  --ptsize=12  --resolution=150  --xsize=2550  --ysize=300  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text="$linetext"  --outputbase="$prefix"/${fontname// /_}.$cnt.exp$exp   --degrade_image=true
                       ;;
                  6)  let exp=-1
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words=false  --ptsize=12  --resolution=150  --xsize=2550  --ysize=300  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text="$linetext"  --outputbase="$prefix"/${fontname// /_}.$cnt.exp$exp   --degrade_image=true   
                       ;;
                  7)  let exp=0
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words=false  --ptsize=12  --resolution=200  --xsize=2550  --ysize=300  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text="$linetext"  --outputbase="$prefix"/${fontname// /_}.$cnt.exp$exp   --degrade_image=false 
                       ;;
                  8)  let exp=-1
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words=false  --ptsize=12  --resolution=200  --xsize=2550  --ysize=300  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text="$linetext"  --outputbase="$prefix"/${fontname// /_}.$cnt.exp$exp    --degrade_image=true   
                       ;;
                  9)  let exp=0
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words=false  --ptsize=12  --resolution=200  --xsize=2550  --ysize=300  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text="$linetext"  --outputbase="$prefix"/${fontname// /_}.$cnt.exp$exp   --degrade_image=true --distort_image     --invert=false 
                       ;;
                  0)  let exp=-1
                        OMP_THREAD_LIMIT=1 text2image --fonts_dir="$unicodefontdir"  --strip_unrenderable_words=false  --ptsize=12  --resolution=200  --xsize=2550  --ysize=300  --leading=32 --margin=100 --exposure=$exp  --font="$fontname" --text="$linetext"  --outputbase="$prefix"/${fontname// /_}.$cnt.exp$exp  --degrade_image=true   --distort_image     --invert=false   
                       ;;
                  *) echo "Signal number $last is not processed"
                     ;;
             esac
            rm "$prefix"/${fontname// /_}.$cnt.exp$exp.box
            cp "$linetext"  "$prefix"/${fontname// /_}.$cnt.exp$exp.gt.txt
         done
     done < "$fontlist"

    find "$prefix" -type f -name "*.box" -exec rm -f {} \;

