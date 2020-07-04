ARG UBUNTU_VERSION=18.04
ARG PYTHON=python3.6
ARG CUDA=10.2
ARG CUDNN=7

FROM nvidia/cuda:${CUDA}-cudnn${CUDNN}-devel-ubuntu${UBUNTU_VERSION}
ENV DEBIAN_FRONTEND noninteractive


# Install packages and setup basics

RUN apt-get update --fix-missing && \
    apt-get install -y \
        build-essential \
        bzip2 \
        ca-certificates \
        cmake \
        curl \
        gcc \
        git \
        imagemagick \
        libglib2.0-0 \
        liblapack-dev \
        libmysqlclient-dev \
        libopenblas-dev \
        libsm6 \
        libx11-dev \
        libxext6 \
        libxrender1 \
        locales \
        mercurial \
        neovim \
        openssh-server \
				pciutils \
        python3-dev \
        python-opencv \
        python3-pip \
        python3-virtualenv \
        rsync \
        subversion \
        tmux \
        wget \
        zsh && \
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
    pip install -U 'git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI' && \
    pip install -U 'git+https://github.com/facebookresearch/fvcore'


# Install apex

ENV FORCE_CUDA="1"
ENV TORCH_CUDA_ARCH_LIST="Kepler;Kepler+Tesla;Maxwell;Maxwell+Tegra;Pascal;Volta;Turing"

RUN pip uninstall apex && \
    git clone https://github.com/NVIDIA/apex /opt/apex && \    
    cd /opt/apex && \
    pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./


# Install detectron2 

ARG DETECTRON2_VERSION=0.1.3


RUN cd /opt && wget -qO- https://github.com/facebookresearch/detectron2/archive/v${DETECTRON2_VERSION}.tar.gz | tar xvz && \
    mv detectron2-${DETECTRON2_VERSION} detectron2 && \
    cd detectron2 && pip install -e .
ENV DETECTRON2_FOLDER=/opt/detectron2

RUN \
    # PointRend
    ln -rs /opt/detectron2/projects/PointRend/configs/InstanceSegmentation /opt/detectron2/configs/PointRend && \
    # VoVNet
    git clone https://github.com/youngwanLEE/vovnet-detectron2.git /opt/detectron2/projects/VoVNet && \
    ln -rs /opt/detectron2/projects/VoVNet/configs /opt/detectron2/configs/VoVNet && \
    # MeshRCNN 
    git clone https://github.com/facebookresearch/meshrcnn /opt/detectron2/projects/MeshRCNN && \
    # CenterMask
    git clone https://github.com/youngwanLEE/centermask2.git /opt/detectron2/projects/CenterMask2 && \
    ln -rs /opt/detectron2/projects/CenterMask2/configs/centermask /opt/detectron2/configs/CenterMask2


# Fix to make tensorflow working with cuda 10.2

RUN ln -s /usr/local/cuda/lib64/libcudart.so.10.2 /usr/local/cuda/lib64/libcudart.so.10.1 && \
    ln -s /usr/local/cuda/lib64/libcupti.so.10.2 /usr/local/cuda/lib64/libcupti.so.10.1


# Create user and give permissions

RUN groupadd --gid 1000 docker && \
    useradd --uid 1000 --gid docker --shell /bin/zsh --create-home user && \
    mkdir /opt/datasets && \
    chown -R user /opt && \
    echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64" >> /home/user/.zshrc
WORKDIR /home/user
USER user
