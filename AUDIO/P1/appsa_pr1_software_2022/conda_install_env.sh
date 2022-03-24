#!/bin/bash

conda create -y -n dcase2019 python=3.6

conda activate dcase2019

pip install torch==1.7.1+cpu torchvision==0.8.2+cpu torchaudio==0.7.2 -f https://download.pytorch.org/whl/torch_stable.html
pip install soundfile dcase_util sed-eval

conda install -y spyder pandas h5py scipy numba==0.48
conda install -y librosa tqdm youtube-dl ffmpeg -c conda-forge



