# Copyright 2019 Bill Xue <xueeinstein@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============================================================================
#
# THIS IS A GENERATED DOCKERFILE.
#
# This file was assembled from multiple pieces, whose use is documented
# throughout. Please refer to the github:xueeinstein/rl-docker-hub
# for more information.

ARG UBUNTU_VERSION=18.04

ARG ARCH=
ARG CUDA=10.0
FROM nvidia/cuda${ARCH:+-$ARCH}:${CUDA}-base-ubuntu${UBUNTU_VERSION} as base
# ARCH and CUDA are specified again because the FROM directive resets ARGs
# (but their default value is retained if set previously)
ARG ARCH
ARG CUDA
ARG CUDNN=7.4.1.5-1

# Needed for string substitution 
SHELL ["/bin/bash", "-c"]
# Pick up some TF dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cuda-command-line-tools-${CUDA/./-} \
        cuda-cublas-${CUDA/./-} \
        cuda-cufft-${CUDA/./-} \
        cuda-curand-${CUDA/./-} \
        cuda-cusolver-${CUDA/./-} \
        cuda-cusparse-${CUDA/./-} \
        curl \
        libcudnn7=${CUDNN}+cuda${CUDA} \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libzmq3-dev \
        pkg-config \
        software-properties-common \
        unzip

RUN [ ${ARCH} = ppc64le ] || (apt-get update && \
        apt-get install nvinfer-runtime-trt-repo-ubuntu1804-5.0.2-ga-cuda${CUDA} \
        && apt-get update \
        && apt-get install -y --no-install-recommends libnvinfer5=5.0.2-1+cuda${CUDA} \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*)

# For CUDA profiling, TensorFlow requires CUPTI.
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:$LD_LIBRARY_PATH

ARG USE_PYTHON_3_NOT_2
ARG _PY_SUFFIX=${USE_PYTHON_3_NOT_2:+3}
ARG PYTHON=python${_PY_SUFFIX}
ARG PIP=pip${_PY_SUFFIX}

# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8

RUN apt-get update && apt-get install -y \
    ${PYTHON} \
    ${PYTHON}-pip

RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python

# select faster mirror for China users
ARG IN_CHINA
COPY sources.list-China /etc/apt
RUN if [ $IN_CHINA ]; then cp /etc/apt/sources.list-China /etc/apt/sources.list; fi
RUN if [ $IN_CHINA ]; then ${PIP} config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple; fi

# install desktop and VNC server
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl supervisor openssh-server pwgen vim-tiny net-tools lxde x11vnc xvfb \
     mesa-utils libgl1-mesa-dri gnome-themes-standard gtk2-engines-pixbuf gtk2-engines-murrine pinta arc-theme dbus-x11 \
     x11-utils && \
    apt-get autoclean && \
    apt-get autoremove

ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

# install deps for web VNC
ADD image /
RUN ${PIP} install setuptools wheel && ${PIP} install -r /usr/lib/web/requirements${_PY_SUFFIX}.txt

# start up script
ENV HOME=/root \
    SHELL=/bin/bash
ENTRYPOINT ["/startup.sh"]

# install gym except mujoco
ARG GYM_VERSION=0.14.0

RUN apt-get update && \
    apt-get -y install git cmake zlib1g zlib1g-dev build-essential ${PYTHON}-dev ${PYTHON}-opengl swig && \
    ${PIP} install pygame
RUN ${PIP} install gym[atari]==$GYM_VERSION
RUN ${PIP} install gym[box2d]==$GYM_VERSION
RUN ${PIP} install gym[classic_control]==$GYM_VERSION
