#!/bin/bash
# nohup bash  4-train-layer.sh ckb > 4-ckb.log & 

export PYTHONIOENCODING=utf8
ulimit -s 65536
SCRIPTPATH=`pwd`
MODEL=$1

mkdir -p data/script  data/script/Arabic
combine_tessdata -u ~/tessdata_best/script/Arabic.traineddata $SCRIPTPATH/data/script/Arabic/$MODEL.

rm -rf data/$MODEL
mkdir data/$MODEL

cd data/$MODEL
wget -O $MODEL.config https://github.com/tesseract-ocr/langdata_lstm/raw/master/ara/ara.config
wget -O $MODEL.numbers https://github.com/tesseract-ocr/langdata_lstm/raw/master/ara/ara.numbers
wget -O $MODEL.punc https://github.com/tesseract-ocr/langdata_lstm/raw/master/ara/ara.punc
cp  $SCRIPTPATH/langdata/$MODEL.wordlist ./

Version_Str="$MODEL:shreeshrii`date +%Y%m%d`:from:"
sed -e "s/^/$Version_Str/" $SCRIPTPATH/data/script/Arabic/$MODEL.version > $MODEL.version

rm  /tmp/all-$MODEL-lstmf
fontlist=$SCRIPTPATH/langdata/$MODEL.fontslist.txt
while IFS= read -r fontname
     do
        cat  $SCRIPTPATH/data/all-*${fontname// /_}*-lstmf >>  /tmp/all-$MODEL-lstmf
     done < "$fontlist"
python3 $SCRIPTPATH/shuffle.py 1 < /tmp/all-$MODEL-lstmf > all-lstmf

cat $SCRIPTPATH/langdata/$MODEL.training_text > all-gt 

cd ../..

nohup make  training  \
MODEL_NAME=$MODEL  \
LANG_TYPE=RTL \
BUILD_TYPE=Layer  \
TESSDATA=/home/ubuntu/tessdata_best \
GROUND_TRUTH_DIR=$SCRIPTPATH/gt \
START_MODEL=script/Arabic \
LAYER_NET_SPEC="[Lfx128 O1c1]" \
LAYER_APPEND_INDEX=5 \
RATIO_TRAIN=0.99 \
DEBUG_INTERVAL=-1 \
MAX_ITERATIONS=5521100 >> 4-ckb.log & 

####
####nohup make  training  \
####MODEL_NAME=$MODEL  \
####LANG_TYPE=RTL \
####BUILD_TYPE=Minus  \
####TESSDATA=/home/ubuntu/tessdata_best \
####GROUND_TRUTH_DIR=$SCRIPTPATH/$prefix \
####START_MODEL=script/Arabic \
####RATIO_TRAIN=0.95 \
####DEBUG_INTERVAL=-1 \
####MAX_ITERATIONS=40000> $MODEL-Minus.log & 
