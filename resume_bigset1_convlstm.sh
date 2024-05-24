#!/bin/bash
# from

set -x

MODEL=convlstm
EPOCHS=1
PREFIX=bigset1
BATCH_SIZE=9
NUM_WORKERS=9

[[ "$1" == '-e' ]] && EPOCHS=$2

results_path=${PREFIX}_bs${BATCH_SIZE}

echo "[$(date "+%Y-%m-%d %H:%M:%S")]:INFO:${0}:resuming pad_experiments.py with model ${MODEL}.  resuming from ${results_path}" >&2

ckpt=last

time python pad_experiments.py \
      --train \
      --resume $ckpt \
      --model $MODEL \
      --parcel_loss \
      --weighted_loss \
      --root_path_coco coco_files/ \
      --prefix_coco $PREFIX \
      --netcdf_path ../dataset/ \
      --prefix ${results_path} \
      --num_epochs $EPOCHS \
      --batch_size $BATCH_SIZE \
      --bands B02 B03 B04 B08 \
      --img_size 61 61 \
      --requires_norm \
      --num_workers $NUM_WORKERS \
      --num_gpus 1 \
      --fixed_window \
      --wandb \

ECODE=$?
set +x
echo "[$(date "+%Y-%m-%d %H:%M:%S")]:INFO:${0}:pad_experiments.py resume (${MODEL} / ${PREFIX}) exited with ECODE $ECODE" >&2
exit $ECODE

# Checkpoint can be specified by name
#ckpt=/Users/iahansen/admin/master_study/P7/repo/Sen4AgriNet/S4A-Models/logs/convlstm/20240516144730/run_20240517075542/checkpoints/epoch=0-step=4.ckpt
