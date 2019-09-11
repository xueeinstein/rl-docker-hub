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

FROM ubuntu:${UBUNTU_VERSION} as base

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

# install Google Research Football
ARG FOOTBALL_VERSION=1.4
ENV FOOTBALL_PATH=/root/football
RUN apt-get update && \
    apt-get install -y git cmake build-essential libgl1-mesa-dev libsdl2-dev libsdl2-image-dev libsdl2-ttf-dev \
                    libsdl2-gfx-dev libboost-all-dev libdirectfb-dev libst-dev mesa-utils glee-dev libsdl-sge-dev

RUN ${PIP} install gfootball==$FOOTBALL_VERSION