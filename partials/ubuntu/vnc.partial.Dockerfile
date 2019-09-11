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
