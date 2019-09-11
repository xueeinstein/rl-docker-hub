# install DeepMind Lab
ARG LAB_CHECK=HEAD
RUN apt-get update && apt-get install -y openjdk-8-jdk && \
    echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
    curl https://bazel.build/bazel-release.pub.gpg | apt-key add - && \
    apt-get update && apt-get install -y bazel && \
    apt-get install -y lua5.1 liblua5.1-0-dev libffi-dev gettext git zip \
    freeglut3-dev libsdl2-dev libosmesa6-dev ${PYTHON}-dev ${PYTHON}-numpy coreutils

ENV LAB_PATH=/root/lab
RUN git clone https://github.com/deepmind/lab $LAB_PATH && cd $LAB_PATH && \
    git checkout $LAB_CHECK && bazel build :deepmind_lab.so --define headless=glx