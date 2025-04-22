#!/bin/bash

# 激活 conda 环境
source ~/anaconda3/etc/profile.d/conda.sh
conda activate hsmot310

# 设置路径
cd /data/users/litianhao/hsmot_code/ByteTrack
# DET_ROOT=/data3/litianhao/hsmot/yolo11/197/predict_yolov11l_8ch_CocoPretrain_interpolate_imgsize1280_1gpu2
DET_ROOT=/data3/litianhao/hsmot/yolo11/197/predict_yolov11l_3ch_CocoPretrain_imgsize1280_1gpu
IMG_ROOT=/data/users/litianhao/data/HSMOT/test/npy
WORK_DIR=/data3/litianhao/hsmot
EVAL_SCRIPT=/data/users/litianhao/hsmot_code/TrackEval/eval.sh

# 所有的 tracker 名称和对应的 expn 名
declare -A trackers
trackers=( 
  ["sort"]="sort_default_parameters_yolo1gpu3ch" 
  ["bytetrack"]="bytetrack_default_parameters_yolo1gpu3ch"
  ["ocsort"]="ocsort_default_parameters_yolo1gpu3ch"
  ["botsort"]="botsort_default_parameters_yolo1gpu3ch"
)

# 依次运行每个 tracker 的 tracking 和评估
for tracker in "${!trackers[@]}"; do
  expn="${trackers[$tracker]}"
  echo ">>> Running tracker: $tracker, experiment: $expn"
  
  python track_by_dets.py \
    -expn "$expn" \
    --tracker "$tracker" \
    --img_root "$IMG_ROOT" \
    --det_root "$DET_ROOT" \
    --workdir "$WORK_DIR"

  echo ">>> Evaluating $tracker..."
  sh "$EVAL_SCRIPT" "$tracker/$expn" track
done