#!/bin/bash

DOCKER=${DOCKER:-'docker'}
DOCKER_BUILD="$DOCKER build -q"
BASENAME=stffsc/deeplabcut

build_tf1_base() {
${DOCKER_BUILD} - << "EOF"
from tensorflow/tensorflow:1.15.5-gpu-py3
run apt-get update -y && apt-get install -yy ffmpeg
run pip install dataclasses
EOF
}

build_tf1_gui_base() {
base=$(build_tf1_base)
${DOCKER_BUILD} - << EOF
from ${base}
run apt-get install -yy libgtk-3-dev python3-wxgtk4.0
EOF
}

# Base images
build_miniconda() {
for tag in cpu-lite gpu-lite; do
CONDA_ENV=DLC-$(echo $tag | tr '[:lower:]' '[:upper:]')
>&2 echo building ${tag} from ${CONDA_ENV}
${DOCKER_BUILD} --build-arg CONDA_ENV=${CONDA_ENV} -t ${BASENAME}:miniconda4.8.3-${tag} - << "EOF"
from continuumio/miniconda3:4.8.3
arg CONDA_ENV
run wget https://raw.githubusercontent.com/DeepLabCut/DeepLabCut/master/conda-environments/${CONDA_ENV}.yaml
run conda env create -f ${CONDA_ENV}.yaml
run apt-get update -y && apt-get install -yy ffmpeg

env CONDA_DEFAULT_ENV ${CONDA_ENV}                                                                                          
env CONDA_PREFIX /opt/conda/envs/${CONDA_ENV}                                                                                                
env PATH /opt/conda/envs/${CONDA_ENV}/bin:${PATH}
env DLClight True
run rm ~/.bashrc
EOF
done
}

# Stable releases with TF1.15
build_tf1_core() {
base=$(build_tf1_base)
${DOCKER_BUILD} -t ${BASENAME}:core-tf1.15.5-gpu-py3 - << EOF
from ${base}
run pip install deeplabcut==2.1.10.4
env DLClight True
EOF
}

build_tf1_gui() {
base=$(build_tf1_gui_base)
${DOCKER_BUILD} -t ${BASENAME}:gui-tf1.15.5-gpu-py3 - << EOF
from ${base}
run pip install 'deeplabcut[gui]==2.1.10.4'
EOF
}

# Release candidates
build_tf1_core_rc() {
base=$(build_tf1_base)
${DOCKER_BUILD} -t ${BASENAME}:core-rc-tf1.15.5-gpu-py3 - << EOF
from ${base}
run pip install deeplabcut==2.2rc2
env DLClight True
EOF
}

build_tf1_gui_rc() {
base=$(build_tf1_gui_base)
${DOCKER_BUILD} -t ${BASENAME}:gui-rc-tf1.15.5-gpu-py3 - << EOF
from ${base}
run pip install 'deeplabcut[gui]==2.2rc2'
EOF
}



build_tf2_core() {
${DOCKER_BUILD} -t ${BASENAME}:core-tf2.4.1-gpu-py3 - << "EOF"
from tensorflow/tensorflow:2.4.1-gpu
run pip install tf-slim
run pip install deeplabcutcore
run pip install dataclasses
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
    $DOCKER images | grep '^deeplabcut ' | sed -s 's/\s\s\+/\t/g' | cut -f1,2 -d$'\t' --output-delimiter ':' | grep core
}

run_test() {
    test_image_id="$1"
    $DOCKER run -u $(id -u) -v $(pwd):/app --tmpfs /.local --tmpfs /.cache -w /app/test/DeepLabCut \
     --tmpfs /usr/local/lib/python3.6/dist-packages/deeplabcut/pose_estimation_tensorflow/models/pretrained \
     --env DLClight=True \
     -it "${test_image_id}" python -m pytest -q tests
}

prepare_tests() {
  if [[ ! -d test/DeepLabCut/.git ]]; then
    (cd test && git clone git@github.com:DeepLabCut/DeepLabCut.git) || exit 1
  else
    (cd test/DeepLabCut && git pull origin master) || exit 1
  fi
}

prepare_tests
#for job in miniconda tf1_core tf1_gui; do 
for job in tf1_core tf1_gui tf1_core_rc tf1_gui_rc; do 
    echo start building $job
    image_id=$(build_${job})
    echo finished ${job} ${image_id}
    test_image_id=$(build_test_image ${image_id})
    echo testing image
    # run_test ${test_image_id}
done
