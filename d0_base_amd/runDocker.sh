CTO_NAME="alpineintuition/base_amd"
CTO_TAG="latest"

docker run \
	-it \
    --rm \
    --privileged \
    --device=/dev/kfd \
    --device=/dev/dri \
    --group-add video \
    --shm-size=30G \
    --user=$UID:43 \
    -v /home/jean/alpine_intuition:/root/alpine_intuition \
    $CTO_NAME:$CTO_TAG \
	/bin/bash
