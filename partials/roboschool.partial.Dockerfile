# install roboschool
ARG ROBOSCHOOL_CHECK=HEAD
ENV ROBOSCHOOL_PATH=/root/roboschool
RUN apt-get update && \
    apt-get -y install git cmake pkg-config qtbase5-dev libqt5opengl5-dev libassimp-dev patchelf && \
    git clone https://github.com/openai/roboschool.git $ROBOSCHOOL_PATH && \
    cd $ROBOSCHOOL_PATH && git checkout $ROBOSCHOOL_CHECK && \
    ./install_boost.sh && ./install_bullet.sh
RUN cd $ROBOSCHOOL_PATH && bash -c "source exports.sh && cd roboschool/cpp-household && make clean && make -j8"
RUN cd $ROBOSCHOOL_PATH && bash -c "source exports.sh && ${PIP} install -e ." && \
    ${PYTHON} -c "import gym; gym.make('roboschool:RoboschoolAnt-v1').reset()"
