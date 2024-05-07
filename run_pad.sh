#!/bin/bash
# from

set -x

time python pad_experiments.py \
      --train \
      --model convlstm \
      --parcel_loss \
      --weighted_loss \
      --root_path_coco coco_files/ \
      --prefix_coco 20240503153528 \
      --netcdf_path ./dataset/ \
      --prefix 20240503153528 \
      --num_epochs 5 \
      --batch_size 8 \
      --bands B02 B03 B04 B08 \
      --img_size 61 61 \
      --requires_norm \
      --num_workers 8 \
      --num_gpus 1 \
      --fixed_window
