#!/bin/bash
# Run deeplabcut or other docker images in interactive mode
# Specify a base image as the argument, e.g.
# 
# ./interact.sh stffsc/deeplabcut:core-tf1.15.5-gpu-py3
#
# Will open an interactive session for the deeplabcut core
# docker image. To use, simply copy this script to your
# local directory or path and call it "interact.sh"

BASEIMAGE=${1:-"stffsc/deeplabcut:core-tf1.15.5-gpu-py3"}
docker pull ${BASEIMAGE} || exit 1

GIT_USER=$(git config user.name)
GIT_EMAIL=$(git config user.email)
USERN=$(id -un)
USER=$(id -u)
DOCKERNAME=${USERN}/$(echo ${BASEIMAGE} | tr '/' '-')-bash

docker build -q -t ${DOCKERNAME} - << EOF
from ${BASEIMAGE}

run apt-get install -yy curl git

# Create same user as on the host system
run mkdir -p /home
run mkdir -p /app
run useradd -d /home -s /bin/bash -u ${USER} ${USERN}
run chown -R ${USERN} /home
run chown -R ${USERN} /app

# Switch to the local user from now on
user ${USERN}

# Get a prettier terminal
run curl -s https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh > /home/install.sh
run bash /home/install.sh

# Setup git as on the host system
run git config --global user.name ${GIT_USER}
run git config --global user.email ${GIT_EMAIL}
EOF

docker run -v $(pwd):/app -w /app -u $(id -u):$(id -g) -it ${DOCKERNAME} bash
