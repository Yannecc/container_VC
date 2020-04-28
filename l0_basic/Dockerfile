ARG UBUNTU_VERSION=18.04
ARG PYTHON=python3.6
ARG CUDA=10.1
ARG CUDNN=7

FROM nvidia/cuda:${CUDA}-cudnn${CUDNN}-devel-ubuntu${UBUNTU_VERSION}
ENV DEBIAN_FRONTEND noninteractive

ARG DETECTRON2_VERSION=0.1.1


# Install packages and setup basics

RUN apt-get update --fix-missing && \
    apt-get install -y \
        wget build-essential bzip2 ca-certificates libglib2.0-0 libxext6 \
        libx11-dev rsync openssh-server libmysqlclient-dev python-opencv \
        cmake python3-dev python3-pip python3-virtualenv libopenblas-dev \
        libsm6 libxrender1 git mercurial subversion gcc build-essential \
        liblapack-dev curl neovim zsh locales sudo tmux && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG C.UTF-8


# Create python 3.6 virtual env

ENV VIRTUAL_ENV /opt/python36
RUN python3 -m virtualenv --python=/usr/bin/python3.6 $VIRTUAL_ENV
ENV PATH $VIRTUAL_ENV/bin:$PATH


# Install python packages

COPY requirements.txt .
RUN pip install -r requirements.txt && \
    pip install -U 'git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI'


# Install apex

ENV FORCE_CUDA="1"
ENV TORCH_CUDA_ARCH_LIST="Kepler;Kepler+Tesla;Maxwell;Maxwell+Tegra;Pascal;Volta;Turing"

RUN pip uninstall apex && \
    git clone https://github.com/NVIDIA/apex /opt/apex && \    
    cd /opt/apex && \
    pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./


# Install detectron2 

RUN cd /opt && wget -qO- https://github.com/facebookresearch/detectron2/archive/v${DETECTRON2_VERSION}.tar.gz | tar xvz && \
    mv detectron2-${DETECTRON2_VERSION} detectron2 && \
    cd detectron2 && pip install -e .
ENV DETECTRON2_FOLDER=/opt/detectron2
