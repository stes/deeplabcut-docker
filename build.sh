#!/bin/bash

DOCKER_BUILD='sudo docker build -q'
BASENAME=deeplabcut

build_tf1_base() {
${DOCKER_BUILD} - << "EOF"
from tensorflow/tensorflow:1.15.5-gpu-py3
run apt-get update -y && apt-get install -yy ffmpeg
EOF
}

# Base images
build_miniconda() {
${DOCKER_BUILD} -t ${BASENAME}:miniconda4.8.3 - << "EOF"
from continuumio/miniconda3:4.8.3
run wget https://raw.githubusercontent.com/DeepLabCut/DeepLabCut/master/conda-environments/DLC-GPU-LITE.yaml
run conda env create -f DLC-GPU-LITE.yaml
run apt-get update -y && apt-get install -yy ffmpeg

env CONDA_DEFAULT_ENV DLC-GPU-LITE                                                                                                           
env CONDA_PREFIX /opt/conda/envs/DLC-GPU-LITE                                                                                                
env PATH /opt/conda/envs/DLC-GPU-LITE/bin:${PATH}
env DLClight True
run rm ~/.bashrc
EOF
}

build_tf1_core() {
base=$(build_tf1_base)
${DOCKER_BUILD} -t ${BASENAME}:core-tf1.15.5-gpu-py3 - << EOF
from ${base}
run pip install deeplabcut
env DLClight True
run apt-get update -y && apt-get install -yy ffmpeg
EOF
}

build_tf1_gui() {
base=$(build_tf1_base)
${DOCKER_BUILD} -t ${BASENAME}:gui-tf1.15.5-gpu-py3 - << EOF
from ${base}
run apt-get install -yy libgtk-3-dev python3-wxgtk4.0
run pip install 'deeplabcut[gui]'
run apt-get update -y && apt-get install -yy ffmpeg
EOF
}

build_tf2_core() {
${DOCKER_BUILD} -t ${BASENAME}:core-tf2.4.1-gpu-py3 - << "EOF"
from tensorflow/tensorflow:2.4.1-gpu
run pip install tf-slim
run pip install deeplabcutcore
env DLClight True
EOF
}

build_test_image() {
image_id=$1
${DOCKER_BUILD} -t deeplabcut:tmp - << EOF
from ${image_id}
run pip install --no-cache-dir pytest
EOF
}

list_images() {
    sudo docker images | grep '^deeplabcut ' | sed -s 's/\s\s\+/\t/g' | cut -f1,2 -d$'\t' --output-delimiter ':' | grep core
}

for job in miniconda tf1_core tf1_gui; do 
    echo start building $job
    image_id=$(build_${job})
    echo finished ${job} ${image_id}
    test_image_id=$(build_test_image ${image_id})
    echo testing image
    sudo docker run -u $(id -u) -v $(pwd):/app --tmpfs /.local --tmpfs /.cache -w /app/DeepLabCut \
     --tmpfs /usr/local/lib/python3.6/dist-packages/deeplabcut/pose_estimation_tensorflow/models/pretrained \
     --env DLClight=True \
     -it "${test_image_id}" python -m pytest -q tests
done