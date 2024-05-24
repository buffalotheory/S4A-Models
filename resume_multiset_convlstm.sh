#!/bin/bash
# from

set -x

# Variables to offer at this stage of the test run

MODEL=convlstm
EPOCHS=5
PREFIX=multiset
BATCH_SIZE=9
NUM_WORKERS=9

results_path=${PREFIX}_bs${BATCH_SIZE}

echo "[$(date "+%Y-%m-%d %H:%M:%S")]:INFO:${0}:resuming pad_experiments.py with model $MODEL test: $PREFIX" >&2

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

ECODE=$?
set +x
echo "[$(date "+%Y-%m-%d %H:%M:%S")]:INFO:${0}:pad_experiments.py resume (${MODEL} / ${PREFIX}) exited with ECODE $ECODE" >&2
exit $ECODE

# Disabled options
#      --wandb \
#

# Previous checkpoint examples
#ckpt=/Users/iahansen/admin/master_study/P7/repo/Sen4AgriNet/S4A-Models/logs/convlstm/20240516144730/run_20240517075542/checkpoints/epoch=0-step=4.ckpt
#ckpt=/Users/iahansen/admin/master_study/P7/repo/Sen4AgriNet/S4A-Models/logs/convlstm/202405170804/run_20240517090313/checkpoints/epoch=4-step=45.ckpt
#ckpt=/Users/iahansen/admin/master_study/P7/repo/Sen4AgriNet/S4A-Models/logs/convlstm/20240517_095529/run_20240517095605/checkpoints/epoch=4-#step=45.ckpt
#ckpt=/Users/iahansen/admin/master_study/P7/repo/Sen4AgriNet/S4A-Models/logs/convlstm/20240520/run_20240520193115/checkpoints/epoch=10-step=44.ckpt
#ckpt=/Users/iahansen/admin/master_study/P7/repo/Sen4AgriNet/S4A-Models/logs/convlstm/20240522/run_20240522113233/checkpoints/epoch=4-step=20.ckpt
