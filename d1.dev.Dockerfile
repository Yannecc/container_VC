FROM alpineintuition/base:latest
ARG UID
ARG GID
ARG USER_MAIL
ARG USER_NAME

# Create user and give permissions

USER root

RUN apt update --fix-missing && \
    apt-get install -y libsndfile1 && \
    apt-get install -y espeak && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


RUN useradd --uid $UID --gid docker --shell /bin/zsh --create-home $USER_NAME && \
    chown -R $USER_NAME /opt
WORKDIR /home/$USER_NAME
USER $USER_NAME


# Install python packages

COPY requirements.txt .
RUN pip install -r requirements.txt


# Install and setup zsh

COPY docker-theme.zsh-theme .
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    echo "export LANG=en_US.UTF-8" >> .zshrc && \
    echo "export LC_CTYPE=en_US.UTF-8" >> .zshrc && \
    mv docker-theme.zsh-theme /home/$USER_NAME/.oh-my-zsh/themes/ && \
    sed -i 's/robbyrussell/docker-theme/g' .zshrc && \
    mkdir /home/$USER_NAME/.cache/torch && \
    mkdir /home/$USER_NAME/.torch && \
    echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64" >> .zshrc
ENTRYPOINT zsh


# Set alpine settings

ENV PYTHONPATH /home/$USER_NAME/alpine_intuition/alpine_lib:$PYTHONPATH
ENV PYTHONPATH /home/$USER_NAME/alpine_intuition/inait/car_intuition:$PYTHONPATH

RUN git config --global user.email $USER_MAIL && \
    git config --global user.name $USER_NAME
