#!/bin/bash

# INSTRUCTIONS:
# Run this script from the terminal:  ./data_download_onedrive_valid_VAD.sh . Files will be downloaded in ./data folder

mkdir ./data

wget https://dauam-my.sharepoint.com/:u:/g/personal/alicia_lozano_uam_es/EWBjWyX774pLhJc2ahr4zk0BtLvWt7YGhdMDDmGu-LcBNQ?download=1 
mv EWBjWyX774pLhJc2ahr4zk0BtLvWt7YGhdMDDmGu-LcBNQ?download=1 ./data/valid_VAD.zip
unzip ./data/valid_VAD.zip > /dev/null
mv ./valid_VAD ./data/.



