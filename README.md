# Unofficial DeepLabCut Dockerfiles

This repo contains build routines for the following (unofficial) deeplabcut docker images:

- `deeplabcut:miniconda4.8.3-*`: These are `miniconda` based images which will be installed with the [official deeplabcut environments](https://github.com/DeepLabCut/DeepLabCut/tree/master/conda-environments). The difference to the official installation guide is that we'll use `miniconda` instead of `anaconda`.
  -  `deeplabcut:miniconda4.8.3-cpu-lite`: based on [DLC-CPU-LITE.yaml](https://github.com/DeepLabCut/DeepLabCut/blob/master/conda-environments/DLC-CPU-LITE.yaml)
  -  `deeplabcut:miniconda4.8.3-gpu-lite`: based on [DLC-GPU-LITE.yaml](https://github.com/DeepLabCut/DeepLabCut/blob/master/conda-environments/DLC-GPU-LITE.yaml)
  -  `deeplabcut:miniconda4.8.3-cpu`: based on [DLC-CPU.yaml](https://github.com/DeepLabCut/DeepLabCut/blob/master/conda-environments/DLC-CPU.yaml)
  -  `deeplabcut:miniconda4.8.3-gpu`: based on [DLC-GPU.yaml](https://github.com/DeepLabCut/DeepLabCut/blob/master/conda-environments/DLC-GPU.yaml)
- `deeplabcut:core-tf1.15.5-gpu-py3`: based on the `tensorflow 1.15` docker container which comes with [`deeplabcut`](https://github.com/DeepLabCut/DeepLabCut) installed.
- `deeplabcut:gui-tf1.15.5-gpu-py3`: based on the `tensorflow 1.15` docker container which comes with [`deeplabcut[gui]`](https://github.com/DeepLabCut/DeepLabCut) installed.
- `deeplabcut::core-tf2.4.1-gpu-py3`: based on the `tensorflow 2.4.1` docker container which comes with [`deeplabcutcore`](https://github.com/DeepLabCut/DeepLabCut-Core) (experimental tensorflow 2 version) installed.

All images are based on Python >= 3.6.

## Local Build

Make sure your docker deamon is running.
You can build the images by running

```
./build.sh
```

Note that this assumes that you have rights to execute `docker build` and `docker run` commands which requires either `sudo` access or membership in the `docker` group on your local machine. The script determines the correct mode automatically.

## Dockerhub 

The images are synced to dockerhub. The scripts used for this will be added in an upcoming release

## Contributing

If you want to contribute images, please open a PR.
