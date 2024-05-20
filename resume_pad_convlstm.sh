#!/bin/bash
# from

set -x

MODEL=convlstm
echo "[$(date "+%Y-%m-%d %H:%M:%S")]:INFO:${0}:starting pad_experiments.py with model $MODEL" >&2

ckpt=/Users/iahansen/admin/master_study/P7/repo/Sen4AgriNet/S4A-Models/logs/convlstm/20240516144730/run_20240517075542/checkpoints/epoch=0-step=4.ckpt
ckpt=/Users/iahansen/admin/master_study/P7/repo/Sen4AgriNet/S4A-Models/logs/convlstm/202405170804/run_20240517090313/checkpoints/epoch=4-step=45.ckpt
ckpt=/Users/iahansen/admin/master_study/P7/repo/Sen4AgriNet/S4A-Models/logs/convlstm/20240517_095529/run_20240517095605/checkpoints/epoch=4-step=45.ckpt
ckpt=/Users/iahansen/admin/master_study/P7/repo/Sen4AgriNet/S4A-Models/logs/convlstm/20240520/run_20240520193115/checkpoints/epoch=10-step=44.ckpt
#ckpt=last

time python pad_experiments.py \
      --train \
      --wandb \
      --resume=$ckpt \
      --model $MODEL \
      --parcel_loss \
      --weighted_loss \
      --root_path_coco coco_files/ \
      --prefix_coco 202405161500 \
      --netcdf_path ./dataset/ \
      --prefix $(date "+%Y%m%d_%H%M%S") \
      --num_epochs 5 \
      --batch_size 4 \
      --bands B02 B03 B04 B08 \
      --img_size 61 61 \
      --requires_norm \
      --num_workers 9 \
      --num_gpus 1 \
      --window_len 12
