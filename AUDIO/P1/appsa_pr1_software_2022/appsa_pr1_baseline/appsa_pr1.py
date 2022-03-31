# APPSA PR1
# AUDIAS / Diego de Benito / 2020

import librosa as lr
import numpy as np
import pandas as pd
from matplotlib import pyplot as plt
import os


# %% Environment settings

# We have introduced the dataset in this folder to be able to execute it.
DATASET_PATH = '../dataset/'
FEAT_SUBPATH = 'features/sr44100_win2048_hop511_mels64_nolog/'
AUDIO_SUBPATH = 'audio/validation/'
META_SUBPATH = 'metadata/validation/'
META_FILE = 'validation.tsv'

CLASSES = np.array(['Alarm_bell_ringing', 'Blender', 'Cat', 'Dishes', 'Dog',
                    'Electric_shaver_toothbrush', 'Frying', 'Running_water',
                    'Speech', 'Vacuum_cleaner'], dtype='object')


# %% Display audio files and features

def plot_waveform(filename, axis = None):
    """Loads and plots the signal

    Args:
        filename (string): the .wav filename of the audio

    ax (matplotlib.axes.Axes): axis to plot the figure if desired.
                        If no axis is passed, a new one is created

    Returns:
        np.ndarray : The signal loaded
    """
    # filename = wav file to display

    path = os.path.join(DATASET_PATH, AUDIO_SUBPATH, filename)
    x = lr.load(path, sr=44100)
    x_len_seconds = x[0].size / x[1]

    if axis == None:
        fig, ax = plt.subplots()
        
    ax.plot(x[0])
    ax.set_xlim(0, x[0].size)
    ax.set_xlabel('Time (seconds)')
    ax.grid()
    ax.set_xticks(x[1]*np.arange(1 + x_len_seconds))
    ax.set_xticklabels(np.arange(1 + x_len_seconds))
    ax.set_title(filename)

    return x


def plot_melgram(filename, ax = None):
    """
    Loads the filename and plots its mel-spectrogram, returning the matrix

    Args:
        filename (string): The .npy file of the required audio

    ax (matplotlib.axes.Axes): axis to plot the figure if desired.
                        If no axis is passed, a new one is created

    Returns:
        np.ndarray: The matrix of the mel-spectrogram
    """
    # filename = numpy file with the features to display
    path = os.path.join(DATASET_PATH, FEAT_SUBPATH, filename)

    mel = np.load(path)
    mel = np.log10(1 + np.abs(mel))
    mel_len_seconds = len(mel)/86

    if ax == None:
        fig, ax = plt.subplots()

    ax.imshow(mel.T, origin='lower', aspect='auto', cmap='Blues')

    ax.set_ylabel('Mel filters')
    ax.set_xlabel('Time (seconds)')
    ax.set_xticks(len(mel)*np.arange(1 + np.floor(mel_len_seconds)) /
               np.floor(mel_len_seconds))
    ax.set_xticklabels(np.arange(1 + np.floor(mel_len_seconds)))
    ax.set_title(filename)

    return mel


# %% Display ground truth labels and predictions

def plot_labels(segment, ax = None):
    """Plots the labels of a given filename

    Args:
        segment (string): filename to plot the labels

        ax (plt.pyplot axis): axis to plot the figure if desired.
                              If no axis is passed, a new one is created
    """

    labelfile = os.path.join(DATASET_PATH, META_SUBPATH, META_FILE)
    label_tsv = pd.read_table(labelfile, sep='\s+')

    segment_labels = label_tsv.loc[label_tsv.filename == segment]

    if ax == None:
        fig, ax = plt.subplots()
    for _, l in segment_labels.iterrows():
        on = l["onset"]
        off = l["offset"]
        ev = np.where(CLASSES == l["event_label"])[0][0]

        ax.broken_barh([(on, off-on)], (ev-0.5, 1),
                       color='C'+str(ev), alpha=0.6)

    ax.set_xlim([0, 10])
    ax.set_ylim([-0.5, 9.5])
    ax.set_xlabel('Time (seconds)')
    ax.grid(True)
    ax.set_yticks(range(10))
    ax.set_yticklabels(CLASSES)
    ax.invert_yaxis()

    ax.set_title(segment + ' (ground truth)')


def plot_predictions(segment, predfile):

    pred_tsv = pd.read_table(predfile, sep='\s+')

    segment_preds = pred_tsv.loc[pred_tsv.filename == segment]

    fig, ax = plt.subplots()
    for _, p in segment_preds.iterrows():
        on = p["onset"]
        off = p["offset"]
        ev = np.where(CLASSES == p["event_label"])[0][0]

        ax.broken_barh([(on, off-on)], [ev-0.25, 0.5], color='C'+str(ev))

    ax.set_xlim([0, 10])
    ax.set_ylim([-0.5, 9.5])
    ax.set_xlabel('Time (seconds)')
    ax.grid(True)
    ax.set_yticks(range(10))
    ax.set_yticklabels(CLASSES)
    ax.invert_yaxis()

    ax.set_title(segment + ' (predictions)')


def plot_labels_predictions(segment, predfile):

    labelfile = os.path.join(DATASET_PATH, META_SUBPATH, META_FILE)
    label_tsv = pd.read_table(labelfile, sep='\s+')
    pred_tsv = pd.read_table(predfile, sep='\s+')

    segment_preds = pred_tsv.loc[pred_tsv.filename == segment]
    segment_labels = label_tsv.loc[label_tsv.filename == segment]

    fig, ax = plt.subplots()

    for _, l in segment_labels.iterrows():
        on = l["onset"]
        off = l["offset"]
        ev = np.where(CLASSES == l["event_label"])[0][0]

        ax.broken_barh([(on, off-on)], (ev-0.5, 1),
                       color='C'+str(ev), alpha=0.6)

    for _, p in segment_preds.iterrows():
        on = p["onset"]
        off = p["offset"]
        ev = np.where(CLASSES == p["event_label"])[0][0]

        ax.broken_barh([(on, off-on)], [ev-0.25, 0.5], color='C'+str(ev))

    ax.set_xlim([0, 10])
    ax.set_ylim([-0.5, 9.5])
    ax.set_xlabel('Time (seconds)')
    ax.grid(True)
    ax.set_yticks(range(10))
    ax.set_yticklabels(CLASSES)
    ax.invert_yaxis()

    ax.set_title(segment + ' (ground truth + predictions)')

# %%
