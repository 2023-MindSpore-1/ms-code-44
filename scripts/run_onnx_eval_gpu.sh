#!/bin/bash
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============================================================================

if [ $# != 6 ]
then
    echo "Usage:bash scripts/run_onnx_eval_GPU.sh [DEVICE_ID] [DATASET] [MINDRECORD_DIR] [onnx_path] [instances_set] [CONFIG_PATH]"
exit 1
fi

DATASET=$2
MINDRECORD_DIR=$3
ONNX_PATH=$4
INSTANCE_SET=$5
CONFIG_PATH=$6
echo $DATASET

export DEVICE_NUM=1
export DEVICE_ID=$1
export RANK_SIZE=$DEVICE_NUM
export RANK_ID=0


BASE_PATH=$(cd "`dirname $0`" || exit; pwd)
cd $BASE_PATH/../ || exit

if [ -d "eval_onnx$2" ];
then
    rm -rf ./eval_onnx$2
fi

mkdir ./eval_onnx$2
cp ./*.py ./eval_onnx$2
cp -r ./src ./eval_onnx$2
cp -r ./config ./eval_onnx$2
cd ./eval_onnx$2 || exit
env > env.log
echo "start inferring for device $DEVICE_ID"
python eval_onnx.py \
    --dataset=$DATASET \
    --onnx_path=$ONNX_PATH \
    --instances_set=$INSTANCE_SET \
    --config_path=$CONFIG_PATH \
    --mindrecord_dir=$MINDRECORD_DIR > log.txt 2>&1 &
cd ..
