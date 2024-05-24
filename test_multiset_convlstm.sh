#!/bin/bash
# from

set -x

MODEL=convlstm
EPOCHS=5
PREFIX=multiset
BATCH_SIZE=9
NUM_WORKERS=9

results_path=${PREFIX}_bs${BATCH_SIZE}

echo "[$(date "+%Y-%m-%d %H:%M:%S")]:INFO:${0}:starting pad_experiments.py with model ${MODEL}.  logging to ${results_path}" >&2

time python pad_experiments.py \
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
      --load_checkpoint=logs/convlstm/multiset_bs9/run_20240524094301/checkpoints/epoch=4-step=40-v2.ckpt

ECODE=$?
set +x
echo "[$(date "+%Y-%m-%d %H:%M:%S")]:INFO:${0}:pad_experiments.py run (${MODEL} / ${PREFIX}) exited with ECODE $ECODE" >&2


#      --prefix $(date "+%Y%m%d_%H%M%S") \
#      --wandb \
#      --saved_medians \


      #--window_len 12


      # \
      #--saved_medians
