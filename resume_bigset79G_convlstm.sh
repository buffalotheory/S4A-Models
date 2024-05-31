#!/bin/bash
# from

set -x

MODEL=convlstm
EPOCHS=10
PREFIX=bigset79G
BATCH_SIZE=18
NUM_WORKERS=16

results_path=${PREFIX}_bs${BATCH_SIZE}

echo "[$(date "+%Y-%m-%d %H:%M:%S")]:INFO:${0}:resuming pad_experiments.py with model $MODEL test: $PREFIX" >&2

ckpt=last

cd /app/S4A-Models \
&& time python pad_experiments.py \
      --train \
      --resume $ckpt \
      --model $MODEL \
      --parcel_loss \
      --weighted_loss \
      --root_path_coco /app/S4A-Models/coco_files/ \
      --prefix_coco $PREFIX \
      --netcdf_path /app/dataset/ \
      --prefix ${results_path} \
      --num_epochs $EPOCHS \
      --batch_size $BATCH_SIZE \
      --bands B02 B03 B04 B08 \
      --img_size 61 61 \
      --requires_norm \
      --num_workers $NUM_WORKERS \
      --num_gpus 2 \
      --fixed_window \
      --wandb \

ECODE=$?
set +x
echo "[$(date "+%Y-%m-%d %H:%M:%S")]:INFO:${0}:pad_experiments.py resume (${MODEL} / ${PREFIX}) exited with ECODE $ECODE" >&2
exit $ECODE
