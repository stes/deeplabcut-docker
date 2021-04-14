# Unofficial DeepLabCut Dockerfiles

This repo contains build routines for the following (unofficial) deeplabcut docker images:

- `stffsc/deeplabcut:miniconda4.8.3-*`: These are `miniconda` based images which will be installed with the [official deeplabcut environments](https://github.com/DeepLabCut/DeepLabCut/tree/master/conda-environments). The difference to the official installation guide is that we'll use `miniconda` instead of `anaconda`.
  -  `stffsc/deeplabcut:miniconda4.8.3-cpu-lite`: based on [DLC-CPU-LITE.yaml](https://github.com/DeepLabCut/DeepLabCut/blob/master/conda-environments/DLC-CPU-LITE.yaml)
  -  `stffsc/deeplabcut:miniconda4.8.3-gpu-lite`: based on [DLC-GPU-LITE.yaml](https://github.com/DeepLabCut/DeepLabCut/blob/master/conda-environments/DLC-GPU-LITE.yaml)
  -  `stffsc/deeplabcut:miniconda4.8.3-cpu`: based on [DLC-CPU.yaml](https://github.com/DeepLabCut/DeepLabCut/blob/master/conda-environments/DLC-CPU.yaml)
  -  `stffsc/deeplabcut:miniconda4.8.3-gpu`: based on [DLC-GPU.yaml](https://github.com/DeepLabCut/DeepLabCut/blob/master/conda-environments/DLC-GPU.yaml)
- `stffsc/deeplabcut:core-tf1.15.5-gpu-py3`: based on the `tensorflow 1.15` docker container which comes with [`deeplabcut`](https://github.com/DeepLabCut/DeepLabCut) installed.
- `stffsc/deeplabcut:gui-tf1.15.5-gpu-py3`: based on the `tensorflow 1.15` docker container which comes with [`deeplabcut[gui]`](https://github.com/DeepLabCut/DeepLabCut) installed.
- `stffsc/deeplabcut::core-tf2.4.1-gpu-py3`: based on the `tensorflow 2.4.1` docker container which comes with [`deeplabcutcore`](https://github.com/DeepLabCut/DeepLabCut-Core) (experimental tensorflow 2 version) installed.

All images are based on Python >= 3.6.

## Dockerhub 

The images are synced to dockerhub: https://hub.docker.com/r/stffsc/deeplabcut
Images on dockerhub are in sync with the code version on `main`.

## Interactive console

For a quick start, you can build a local image based on the DLC images by running

``` bash
./interact.sh stffsc/deeplabcut:core-tf1.15.5-gpu-py3
```

which will give you a [nice](https://ohmybash.nntoan.com/) shell with correct user permissions along with a `git` setup within the container.
This environment might be useful for prototyping. You'll have read access to the files in your current directory.

## Local Build

Make sure your docker deamon is running.
You can build the images by running

```
./build.sh
```

Note that this assumes that you have rights to execute `docker build` and `docker run` commands which requires either `sudo` access or membership in the `docker` group on your local machine. The script determines the correct mode automatically.

## Contributing

If you want to contribute images, please open a PR. To report bugs and open feature requests, please use the issues.

## License

Contents of this repo are licensed under the MIT License. But note that the software installed within the containers has different licenses (GPL, LGPL, Apache 2.0, among others). [DeepLabCut](https://github.com/DeepLabCut/DeepLabCut) is licensed under [LGPL v3.0](https://github.com/DeepLabCut/DeepLabCut/blob/master/LICENSE).
