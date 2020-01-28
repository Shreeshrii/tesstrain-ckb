#!/bin/sh
# nohup time -p bash  -x 5-stoptraining.sh ckball Layer > 5-stoptraining-ckballLayer_fast.log & 
# nohup time -p bash  -x 5-stoptraining.sh ckballfonts Layer > 5-stoptraining-ckballfontsLayer_fast.log & 

SCRIPTPATH=`pwd`
PREFIX=$1
BUILDTYPE=$2
CHECKPOINT=${PREFIX}${BUILDTYPE}
MODEL=${CHECKPOINT}_fast

 	lstmtraining \
 	--stop_training \
 	--continue_from $SCRIPTPATH/data/$PREFIX/checkpoints/${CHECKPOINT}_checkpoint \
 	--traineddata data/$PREFIX/$PREFIX.traineddata \
 	--model_output data/${CHECKPOINT}.traineddata

 	lstmtraining \
 	--stop_training \
    --convert_to_int \
 	--continue_from $SCRIPTPATH/data/$PREFIX/checkpoints/${CHECKPOINT}_checkpoint \
 	--traineddata data/$PREFIX/$PREFIX.traineddata \
 	--model_output data/$MODEL.traineddata
