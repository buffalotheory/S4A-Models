#!/bin/bash
# Bryant Hansen

# Execute the test of convLSTM with the multiset dataset

set -x

MODEL=convlstm
EPOCHS=5
PREFIX=bigset79G
BATCH_SIZE=9
NUM_WORKERS=9
GPUS=1

RESULTS_PATH=${PREFIX}
MODEL_PATH=/app/S4A-Models/
DATASET_PATH=/app/dataset/
COCO_PATH=${MODEL_PATH}/coco_files/
CONF_DIR=${MODEL_PATH}/conf/

ME=$(basename $0)
CONF=${ME%.sh}.conf
[[ ! -f "$CONF_DIR"/s4a.conf ]] || . "$CONF_DIR"/s4a.conf
[[ ! -f "$CONF_DIR"/"$CONF" ]] || . "$CONF_DIR"/"$CONF"
[[ ! -f "$CONF" ]]             || . "$CONF"

echo "[$(date "+%Y-%m-%d %H:%M:%S")]:INFO:${0}:starting pad_experiments.py with model ${MODEL}.  logging to ${results_path}" >&2

last_checkpoint_file="$(ls -1t ${MODEL_PATH}/logs/convlstm/overfit/run_*/checkpoints/*.ckpt | head -n 1)"
echo "last_checkpoint_file: $last_checkpoint_file" >&2

cd $MODEL_PATH \
&& time python pad_experiments.py \
time python pad_experiments.py \
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
      --load_checkpoint "$last_checkpoint_file"

ECODE=$?
set +x
echo "[$(date "+%Y-%m-%d %H:%M:%S")]:INFO:${0}:pad_experiments.py run (${MODEL} / ${PREFIX}) exited with ECODE $ECODE" >&2
