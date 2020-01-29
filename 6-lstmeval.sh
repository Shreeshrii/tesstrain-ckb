#!/bin/sh
# nohup bash 6-lstmeval.sh ckb Layer > reports/6-ckb-lstmeval.txt &

SCRIPTPATH=`pwd`
PREFIX=$1
BUILDTYPE=$2
MODEL=${PREFIX}${BUILDTYPE}
FASTMODEL=${MODEL}_fast

echo "-------------------------------------------------------------------------------"

 	lstmtraining \
 	--stop_training \
 	--continue_from $SCRIPTPATH/data/$PREFIX/checkpoints/${MODEL}_checkpoint \
 	--traineddata data/$PREFIX/$PREFIX.traineddata \
 	--model_output data/${MODEL}.traineddata

echo -e "\n ${MODEL}.traineddata ---------------- verbosity 2 \n"

OMP_THREAD_LIMIT=1   time -p  lstmeval  \
  --model  $SCRIPTPATH/data/${MODEL}.traineddata \
  --eval_listfile  $SCRIPTPATH/data/$PREFIX/list.eval \
  --verbosity 2

echo "-------------------------------------------------------------------------------"
 	lstmtraining \
 	--stop_training \
    --convert_to_int \
 	--continue_from $SCRIPTPATH/data/$PREFIX/checkpoints/${MODEL}_checkpoint \
 	--traineddata data/$PREFIX/$PREFIX.traineddata \
 	--model_output data/$FASTMODEL.traineddata

echo -e "\n ${FASTMODEL}.traineddata  ----------------------- verbosity 0 \n"

OMP_THREAD_LIMIT=1   time -p  lstmeval  \
  --model  $SCRIPTPATH/data/${FASTMODEL}.traineddata \
  --eval_listfile  $SCRIPTPATH/data/$PREFIX/list.eval \
  --verbosity 0

echo "-------------------------------------------------------------------------------"
