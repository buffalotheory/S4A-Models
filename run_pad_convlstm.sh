#!/bin/bash
# from

set -x

MODEL=convlstm
echo "[$(date "+%Y-%m-%d %H:%M:%S")]:INFO:${0}:starting pad_experiments.py with model $MODEL" >&2

time python pad_experiments.py \
      --train \
      --model $MODEL \
      --parcel_loss \
      --weighted_loss \
      --root_path_coco coco_files/ \
      --prefix_coco 202405161500 \
      --netcdf_path ./dataset/ \
      --prefix $(date "+%Y%m%d") \
      --num_epochs 10 \
      --batch_size 9 \
      --bands B02 B03 B04 B08 \
      --img_size 61 61 \
      --requires_norm \
      --num_workers 9 \
      --num_gpus 1 \
      --fixed_window \

#      --prefix $(date "+%Y%m%d_%H%M%S") \
#      --wandb \
#      --saved_medians \


      #--window_len 12


      # \
      #--saved_medians
