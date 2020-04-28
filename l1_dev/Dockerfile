FROM alpine-intuition/basic:latest
ARG UID
ARG GID
ARG USER_MAIL
ARG USER_NAME

# Create user and give permissions

RUN groupadd --gid $GID docker && \
    useradd --uid $UID --gid docker --shell /bin/zsh --create-home user && \
    mkdir /opt/datasets && \
    chown -R user /opt
WORKDIR /home/user
USER user


# Install python packages

COPY requirements.txt .
RUN pip install -r requirements.txt


# Install and setup zsh

COPY docker-theme.zsh-theme .
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    echo "export LANG=en_US.UTF-8" >> .zshrc && \
    echo "export LC_CTYPE=en_US.UTF-8" >> .zshrc && \
    mv docker-theme.zsh-theme /home/user/.oh-my-zsh/themes/ && \
    sed -i 's/robbyrussell/docker-theme/g' .zshrc
ENTRYPOINT zsh


# Install detectron2 others projects

RUN ln -rs /opt/detectron2/projects/PointRend/configs/InstanceSegmentation /opt/detectron2/configs/PointRend

RUN git clone https://github.com/youngwanLEE/vovnet-detectron2.git /opt/detectron2/projects/VoVNet && \
    ln -rs /opt/detectron2/projects/VoVNet/configs /opt/detectron2/configs/VoVNet

RUN git clone https://github.com/facebookresearch/meshrcnn /opt/detectron2/projects/MeshRCNN

RUN git clone https://github.com/youngwanLEE/centermask2.git /opt/detectron2/projects/CenterMask2 && \
    ln -rs /opt/detectron2/projects/CenterMask2/configs/centermask /opt/detectron2/configs/CenterMask2


# Set alpine settings

ENV PYTHONPATH /home/user/alpine_intuition/alpine_lib:$PYTHONPATH
ENV PYTHONPATH /home/user/alpine_intuition/inait/car_intuition:$PYTHONPATH

RUN mkdir /home/user/.cache/torch && \
    mkdir /home/user/.torch

RUN mkdir /home/user/alpine_intuition && \
    echo "cd /home/user/alpine_intuition" >> /home/user/.zshrc

RUN git config --global user.email $USER_MAIL && \
    git config --global user.name $USER_NAME
