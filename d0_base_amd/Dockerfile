FROM rocm/pytorch:rocm3.5_ubuntu16.04_py3.6_pytorch
ENV DEBIAN_FRONTEND noninteractive


# Install packages and setup basics

RUN apt-get update --fix-missing && \
    apt-get install -y \
        kmod zsh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Setup python

COPY requirements.txt .
RUN pip3 install -r requirements.txt 
    echo 'alias python=python3.6' >> /root/.zshrc


## Install Tensorflow2 for AMD

RUN pip install tensorflow-rocm


WORKDIR /root
ENTRYPOINT zsh
