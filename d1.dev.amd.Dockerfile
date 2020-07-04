FROM rocm/pytorch:rocm3.5_ubuntu16.04_py3.6_pytorch

ARG UID
ARG GID
ARG USER_MAIL
ARG USER_NAME

ENV DEBIAN_FRONTEND noninteractive


# Install packages and setup basics

RUN apt-get update --fix-missing && \
    apt-get install -y \
        kmod zsh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Setup user

RUN groupadd --gid $GID docker && \
    useradd --uid $UID --gid docker --shell /bin/zsh --create-home user && \
    touch /home/user/.zshrc && \
    mkdir /home/user/.local && mkdir /home/user/.local/lib && \
    mv /root/.local/lib/python3.6 /home/user/.local/lib && \
    chown -R user /home/user/.local && \
    mkdir /home/user/.cache && \
    chown -R user /home/user/.cache && \
    chown -R user /opt


# Setup python

COPY requirements.txt .
RUN pip3 install -r requirements.txt && \
    echo 'alias python=python3.6' >> /home/user/.zshrc


# Install Tensorflow2 for AMD

RUN pip install tensorflow-rocm

WORKDIR /home/user
USER user
ENTRYPOINT zsh
