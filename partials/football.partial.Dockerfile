# install Google Research Football
ARG FOOTBALL_VERSION=1.4
ENV FOOTBALL_PATH=/root/football
RUN apt-get update && \
    apt-get install -y git cmake build-essential libgl1-mesa-dev libsdl2-dev libsdl2-image-dev libsdl2-ttf-dev \
                    libsdl2-gfx-dev libboost-all-dev libdirectfb-dev libst-dev mesa-utils glee-dev libsdl-sge-dev

RUN ${PIP} install gfootball==$FOOTBALL_VERSION