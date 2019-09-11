# select faster mirror for China users
ARG IN_CHINA
COPY sources.list-China /etc/apt
RUN if [ $IN_CHINA ]; then cp /etc/apt/sources.list-China /etc/apt/sources.list; fi
RUN if [ $IN_CHINA ]; then ${PIP} config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple; fi
