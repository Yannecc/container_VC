FROM rocm/pytorch:rocm3.3_ubuntu16.04_py3.6_pytorch

ARG VIDEO_GID
ENV DEBIAN_FRONTEND noninteractive


# Install packages and setup basics

RUN apt-get update --fix-missing && \
    apt-get install -y \
	python3-dev python3-pip python3-virtualenv


# Python 3.6 env

ENV VIRTUAL_ENV /opt/python36
RUN python3 -m virtualenv --python=/usr/bin/python3.6 $VIRTUAL_ENV
ENV PATH $VIRTUAL_ENV/bin:$PATH


# Install Tensorflow2 for AMD

RUN pip install tensorflow-rocm


# Install Pytorch and Torchvision for AMD

RUN git clone --branch=v1.5.0 https://github.com/pytorch/pytorch.git /opt/pytorch && \
    cd /opt/pytorch && \
    git submodule update --init --recursive

RUN pip install ninja enum34 numpy pyyaml setuptools typing cffi future hypothesis

RUN cd /opt/pytorch && \
    python tools/amd_build/build_amd.py && \
    USE_ROCM=1 python setup.py install

RUN git clone --branch=v0.7.0 https://github.com/pytorch/vision /opt/vision && \
    cd /opt/vision && \
    python setup.py install
