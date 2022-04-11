#!/bin/bash

# INSTRUCTIONS:
# Run this script from the terminal:  ./data_download.sh . Files will be downloaded in ./data folder

mkdir ./data

./utils/download_from_google_drive.sh "https://drive.google.com/open?id=1ouu_eIDxO4_KPk--wq4xldvQdP39mIfr" ./data tar.gz > /dev/null
mkdir ./data/voxceleb1
mv ./data/wav/* ./data/voxceleb1/
rm -r ./data/wav/

./utils/download_from_google_drive.sh "https://drive.google.com/open?id=1TX-fGGASW2nXEZGJR9A9Jf3q5F_tPHFf" ./data tar.gz > /dev/null
mkdir ./data/voxceleb2
mv ./data/wav/* ./data/voxceleb2/
rm -r ./data/wav/


