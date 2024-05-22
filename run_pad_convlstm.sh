#!/bin/bash
# from

set -x

MODEL=convlstm
EPOCHS=5
PREFIX=overfit
BATCH_SIZE=9
NUM_WORKERS=9

echo "[$(date "+%Y-%m-%d %H:%M:%S")]:INFO:${0}:starting pad_experiments.py with model $MODEL" >&2

time python pad_experiments.py \
      --train \
      --model $MODEL \
      --parcel_loss \
      --weighted_loss \
      --root_path_coco coco_files/ \
      --prefix_coco $PREFIX \
      --netcdf_path ../dataset/ \
      --prefix ${MODEL}_${PREFIX}_e${EPOCHS}_bs${BATCH_SIZE} \
      --num_epochs $EPOCHS \
      --batch_size $BATCH_SIZE \
      --bands B02 B03 B04 B08 \
      --img_size 61 61 \
      --requires_norm \
      --num_workers $NUM_WORKERS \
      --num_gpus 1 \
      --fixed_window \

#      --prefix $(date "+%Y%m%d_%H%M%S") \
#      --wandb \
#      --saved_medians \


      #--window_len 12


      # \
      #--saved_medians
