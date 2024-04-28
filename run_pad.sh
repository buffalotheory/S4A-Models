#!/bin/bash
# from

set -x

time python pad_experiments.py \
      --train \
      --model convlstm \
      --parcel_loss \
      --weighted_loss \
      --root_path_coco coco_files/ \
      --prefix_coco 20240417101117 \
      --netcdf_path ../dataset/netcdf/ \
      --prefix 20240417101117 \
      --num_epochs 10 \
      --batch_size 32 \
      --bands B02 B03 B04 B08 \
      --saved_medians \
      --img_size 61 61 \
      --requires_norm \
      --num_workers 16 \
      --num_gpus 1 \
      --fixed_window
