#!/bin/bash
# Bryant Hansen

# Launch the convLSTM test with the multiset dataset

set -x

MODEL=convlstm
EPOCHS=20
PREFIX=multiset
BATCH_SIZE=4
NUM_WORKERS=16
GPUS=2

[[ "$1" == '-e' ]] && EPOCHS=$2

RESULTS_PATH=${PREFIX}
MODEL_PATH=.
DATASET_PATH=../dataset/
COCO_PATH=${MODEL_PATH}/coco_files/
CONF_DIR=${MODEL_PATH}/conf/

ME=$(basename $0)
MYCONF=${ME%.sh}.conf
[[ ! -f "$CONF_DIR"/s4a.conf ]]  || . "$CONF_DIR"/s4a.conf
[[ ! -f "$CONF_DIR"/"$MYCONF" ]] || . "$CONF_DIR"/"$MYCONF"

echo "[$(date "+%Y-%m-%d %H:%M:%S")]:INFO:${0}:starting pad_experiments.py with model ${MODEL}.  logging to ${RESULTS_PATH}" >&2

cd $MODEL_PATH \
&& time python pad_experiments.py \
      --train \
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

#      --wandb \

ECODE=$?
set +x
echo "[$(date "+%Y-%m-%d %H:%M:%S")]:INFO:${0}:pad_experiments.py run (${MODEL} / ${PREFIX}) exited with ECODE $ECODE" >&2
exit $ECODE
