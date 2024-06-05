#!/bin/bash
# Bryant Hansen

# Launch the convLSTM test with the overfit dataset

set -x

MODEL=convlstm
EPOCHS=2
PREFIX=overfit
BATCH_SIZE=4
NUM_WORKERS=8
GPUS=1

CONF_DIR=./conf/

RESULTS_PATH=${PREFIX}
#MODEL_PATH=/app/S4A-Models/
#DATASET_PATH=/app/dataset/
#COCO_PATH=${MODEL_PATH}/coco_files/

ME=$(basename $0)
CONF=${ME%.sh}.conf
[[ ! -f "$CONF_DIR"/s4a.conf ]] || . "$CONF_DIR"/s4a.conf
[[ ! -f "$CONF_DIR"/"$CONF" ]] || . "$CONF_DIR"/"$CONF"
[[ ! -f "$CONF" ]]             || . "$CONF"

[[ "$1" == '-e' ]] && EPOCHS=$2

echo "[$(date "+%Y-%m-%d %H:%M:%S")]:INFO:${0}:starting pad_experiments.py with model ${MODEL}.  logging to ${RESULTS_PATH}" >&2

cd $MODEL_PATH \
&& time python pad_experiments.py \
      --train \
      --model $MODEL \
      --parcel_loss \
      --weighted_loss \
      --root_path_coco $COCO_PATH \
      --prefix_coco $PREFIX \
      --netcdf_path $DATASET_PATH \
      --prefix $RESULTS_PATH \
      --num_epochs $EPOCHS \
      --batch_size $BATCH_SIZE \
      --bands B02 B03 B04 B08 \
      --img_size 61 61 \
      --requires_norm \
      --num_workers $NUM_WORKERS \
      --num_gpus $GPUS \
      --fixed_window \

#      --wandb \

ECODE=$?
set +x
echo "[$(date "+%Y-%m-%d %H:%M:%S")]:INFO:${0}:pad_experiments.py run (${MODEL} / ${PREFIX}) exited with ECODE $ECODE" >&2
exit $ECODE
