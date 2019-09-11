# RL-docker-hub
Docker hub for easily setting up reinforcement learning research environment

## Environments

### Gym

Select Python2 or Python3, GPU or CPU version using following commands:

```sh
docker pull xueeinstein/rl-hub:gym
docker pull xueeinstein/rl-hub:gpu-gym
docker pull xueeinstein/rl-hub:gym-py3
docker pull xueeinstein/rl-hub:gpu-gym-py3
```

### Roboschool

Select GPU or CPU version using following commands:

```sh
docker pull xueeinstein/rl-hub:roboschool-py3
docker pull xueeinstein/rl-hub:gpu-roboschool-py3
```

### DeepMind Lab

Select GPU or CPU version using following commands (only support Python2):

```sh
docker pull xueeinstein/rl-hub:deepmindlab
docker pull xueeinstein/rl-hub:gpu-deepmindlab
```


### Google Research Football

Select GPU or CPU version using following commands (only support Python3):

```sh
docker pull xueeinstein/rl-hub:football-py3
docker pull xueeinstein/rl-hub:gpu-football-py3
```

To render in docker, please set environment variables for mesa driver, for example:

```sh
MESA_GL_VERSION_OVERRIDE=3.2 MESA_GLSL_VERSION_OVERRIDE=150 python3 -m gfootball.play_game
```

## Build Docker

To build docker manually, at first, you need to setup virtual environment to run `assembler.py`:

```sh
virtualenv -p /usr/bin/python3 venv
source venv/bin/activate
pip install -r requirements.txt
```

Then aassemble all of the Dockerfiles using:

```sh
python assembler.py -r dockerfiles --construct_dockerfiles
```

Build and upload roboschool (or gym, deempindlab, football) image using:

```sh
python assembler.py -r roboschool -b -u \
    --hub_repository DOCKER_HUB_USER/rl_hub \
    --hub_username DOCKER_HUB_USER \
    --hub_password DOCKER_HUB_PASSWD
```

## Run Docker Container

By default, docker container starts with webVNC and x11vnc services, so you need to bind ports 80 and 5900.
For example, to bind to host 80 and 5900 respectively, execute:

```sh
docker run --rm -it -p 80:80 -p 5900:5900 \
    -e VNC_PASSWORD="$PASSWD" xueeinstein/rl-hub:roboschool-py3
```

Note that `$PASSWD` is your own password to login the VNC.
