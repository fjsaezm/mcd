# MUCD - APPSA PR1

import appsa_pr1 as dcase
from matplotlib import pyplot as plt

# [!] Make sure to set the correct paths:
# 'DATASET_PATH' in appsa_pr1.py
# 'workspace' in config.py

filename = 'Y__p-iA312kg_70.000_80.000'

# Waveform representation
plt.figure()
x, fs = dcase.plot_waveform(filename + '.wav')
plt.show()


# Mel-spectrogram representation
plt.figure()
mel = dcase.plot_melgram(filename + '.npy')
plt.show()
