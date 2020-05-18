GPU=${1:-0}
if [ $GPU -eq -1 ]; then
    echo "ALL GPU USED"
    GPU="all"
else
    echo "GPU $GPU USED"
    GPU="device=${GPU}"
fi

CTO_NAME="alpine-intuition/dev_$UID"
CTO_TAG="latest"

DATASETS=/opt/datasets
ALPINE_LIB=$HOME/alpine_intuition

MODEL_WEIGHTS=$HOME/.cache/torch
MODEL_WEIGHTS2=$HOME/.torch

ALP_DEV_ID=1010

docker run \
    -it \
    --gpus $GPU \
    --runtime=nvidia \
    --ipc=host \
    --shm-size=30G \
    --user=$UID:$ALP_DEV_ID \
    -e DISPLAY=$DISPLAY \
    -v $ALPINE_LIB:/home/user/alpine_intuition \
    -v $HOME/.ssh:/home/user/.ssh \
    -v $HOME/.zsh_history:/home/user/.zsh_history \
    -v $MODEL_WEIGHTS:/home/user/.cache/torch \
    -v $MODEL_WEIGHTS2:/home/user/.torch \
    -v $DATASETS:$DATASETS \
    ${CTO_NAME}:${CTO_TAG} \
    /bin/bash
