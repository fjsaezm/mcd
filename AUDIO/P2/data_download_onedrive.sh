#!/bin/bash

# INSTRUCTIONS:
# Run this script from the terminal:  ./data_download_onedrive.sh . Files will be downloaded in ./data folder

mkdir ./data

wget https://dauam-my.sharepoint.com/:u:/g/personal/alicia_lozano_uam_es/ER9-4DcM62lLtyqMkcU0ZAwBGHMFaSrPZgzuLq0bAxLB-Q?download=1 
mv ER9-4DcM62lLtyqMkcU0ZAwBGHMFaSrPZgzuLq0bAxLB-Q?download=1 ./data/voxceleb1.tar.gz
mkdir ./data/voxceleb1
tar xvzf ./data/voxceleb1.tar.gz > /dev/null
mv ./wav/* ./data/voxceleb1/
rm -r ./wav/

wget https://dauam-my.sharepoint.com/:u:/g/personal/alicia_lozano_uam_es/EQkvCJ901zxApjlVbbSeyooBfa7it0iQP2Eie1MIsy3V-Q?download=1 
mv EQkvCJ901zxApjlVbbSeyooBfa7it0iQP2Eie1MIsy3V-Q?download=1 ./data/voxceleb2.tar.gz
mkdir ./data/voxceleb2
tar xvzf ./data/voxceleb2.tar.gz > /dev/null
mv ./wav/* ./data/voxceleb2/
rm -r ./wav/



