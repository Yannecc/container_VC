CTO_NAME="alpine-intuition/basic"
CTO_TAG="latest"

docker run \
	-it \
    --rm \
	--runtime=nvidia \
	--gpus '"device=1"' \
	--ipc=host \
    --shm-size=30G \
    ${CTO_NAME}:${CTO_TAG} \
	/bin/bash
