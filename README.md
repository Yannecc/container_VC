# Alpine Containers

This repository is related to the containers used within alpine intuition.

## General guidelines

- If you want to add python packages, add them to the `requirements.txt` file with their versions and rebuild the image. Adding unversioned python packages directly to the image file is a bad practice because it adds redundancy and it complicates reproducibility, and one of the goals of Docker is precisely reproducibility.

- Before doing your own Dockerfile, check the [official good practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/).

## Docker

There is two different images available:
- `base`:
- `dev`:

Before using an image, it must be compiled. To do this, go to the associated folder and run the script `./build`

The launching script `runDocker` can take three different parameters:
- `-i` image type to use, by default at `dev`.
- `-t` image tag, by default at `latest`.
- `-g` GPU index to use, by default at `0`. To use all GPUs available, use `-1`.

The script will automatically detect if there is an AMD or NVIDIA card. Note that it is not possible at the moment to choose which GPU to use via `runDocker` when using AMD cards.


## Singularity

