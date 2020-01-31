#!/bin/sh

SCRIPTPATH=`pwd`
PREFIX=ckb
BUILDTYPE=Layer
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
