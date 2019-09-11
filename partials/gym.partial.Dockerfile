# install gym except mujoco
ARG GYM_VERSION=0.14.0

RUN apt-get update && \
    apt-get -y install git cmake zlib1g zlib1g-dev build-essential ${PYTHON}-dev ${PYTHON}-opengl swig && \
    ${PIP} install pygame
RUN ${PIP} install gym[atari]==$GYM_VERSION
RUN ${PIP} install gym[box2d]==$GYM_VERSION
RUN ${PIP} install gym[classic_control]==$GYM_VERSION
