# Vowel Classification Neural Network
___
## Table of Contents
1. [Motivation](#motivation)
2. [High Level Overview](#high-level-overview)
3. [Tangent: Formants and LPCs](#tangent-formants-and-lpcs)
	1. [Linear Predictive Coding](#linear-predictive-coding)
	2. [Sampling Rates](#sampling-rates)
	3. [Neural Network Motivation](#neural-network-motivation)
4. [Technologies Used](#technologies-used)
	1. [Signal Processing](#signal-processing)
	2. [Neural Network Training](#neural-network-training)
5. [Vowel NN Classifier ](#vowel-nn-classifier)
	1. [Dataset Building](#1-dataset-building)
	2. [Vowel Classification Training](#2-vowel-classification-training)
	3. [Side Tangent: Vowel Backness](#side-tangent-vowel-backness)
	4. [Limitations](#limitations)
___
## Motivation
Create a Neural Network to identify vowels based on their [Linear Predictive Coding (LPC) Coefficients](https://sail.usc.edu/~lgoldste/Ling582/Week%209/LPC%20Analysis.pdf). 

For a walkthrough of this repository, checkout this [video](https://youtu.be/mupAVVaChbw).

*Shoutout to my Linguistics professor who wrote this in 1992 and is still teaching this to us at the ripe age of 70+.*
___
## High Level Overview

| Task                | Components                                                                                                                    | Scripts Used                                                                                                                                                                                                           | Full Writeup                                                                               |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| Vowel NN Classifier | 1. Create LPC coefficients for training and ground truth data<br>2. Train feedforward models on the vowel classification task | [Create_LPC_Data_Sets](https://github.com/Ky-Ng/Vowel-Detection-NN/blob/main/Create_LPC_Data_Sets.m)<br>[Vowel_Classification_NN](https://github.com/Ky-Ng/Vowel-Detection-NN/blob/main/Vowel_Classification_NN.ipynb) | [Link](https://drive.google.com/file/d/1teUhbqSgzksPxGWmo40RLY3YbG3y9Pkv/view?usp=sharing) |
| Vowel Backness      | Identifying Vowel Backness using LPC data                                                                                     | [Generate_LPC_Data](https://github.com/Ky-Ng/Vowel-Detection-NN/blob/main/Generate_LPC_Data.ipynb)                                                                                                                     | [Link](https://drive.google.com/file/d/1P1Odct-Sd7Y6cIAgEUB_v64pivZlVdfU/view?usp=sharing) |

___
## Tangent: Formants and LPCs
### Linear Predictive Coding
- As a quick side tangent, Linear Predictive Coding or LPC is a technique discovered by [Bell Labs in 1989](https://ieeexplore.ieee.org/document/266359) used to quantize and compress speech signals.
- LPC uses an auto-regressive model with by predicting the `i`th wave sample using the past `N` samples and learned constants
```
c1 * wave(i-1) + c2 * wave(i-2) + c3 * wave(i-3) + ... + cN * wave(i-N)
```
- We refer to `LPC N` as the wave quantization using the LPC process using `N` coefficients

### Sampling Rates
- In this project, we use `LPC 14` since we have a sample rate of `14kHz` or `14,000` samples per second
- In the original Bell Labs research, the researchers used the heuristic 1 LPC coefficient per `1kHz` sampling rate

### Neural Network Motivation
- Since LPC are linguistically grounded in vocal tract constrictions (since they are related to formants), each vowel exhibits has a unique LPC/Formant "fingerprint"
- Thus, our goal is to use a Feedforward Neural Network to classify which vowel is being produced in a speech signal

(*TODO: More citations needed for this*)
___
## Technologies Used
### Signal Processing
- `lpc` function for generation LPC Coefficients from Waveforms
- `resample` for changing the original `44,100` (`44kHz`) sampling rate to `14,000` (`14kHz`) sampling rate
Libraries:
- [Matlab Signal Processing Toolbox](https://www.mathworks.com/products/signal.html)
- [Librosa](https://librosa.org/doc/latest/index.html)
	- Equivalent to Matlab's Signal Processing Toolbox features the `lpc` and `resample` functions
- [SciPy](https://scipy.org)
	- Deserializes Matlab `.mat` files into Python objects (`numpy` arrays)

### Neural Network Training
- [PyTorch](https://pytorch.org) for Neural Network Architecture and Training
___
## Vowel NN Classifier 
- NN Classifier taking LPC coefficients as inputs and a One Hot Encoding of 10 vowels as its output

### 1) Dataset Building
1) A [Matlab script](https://github.com/Ky-Ng/Vowel-Detection-NN/blob/main/Create_LPC_Data_Sets.m) `resamples`, `truncates`, and preprocesses the utterances in order to ensure the LPC coefficients are reflective of the target vowel and not random noise
2) For more details on the sampling process, read the writeup on section "[Preprocessing Methods](https://drive.google.com/file/d/1P1Odct-Sd7Y6cIAgEUB_v64pivZlVdfU/view?usp=sharing)"
### 2) Vowel Classification Training
1) A [Python script](https://github.com/Ky-Ng/Vowel-Detection-NN/blob/main/Vowel_Classification_NN.ipynb) takes in the `.mat` files from the previous file and trains a simple feedforward network on the vowel classification task
2) The neural networks also have varied hidden layer sizes where increasing the number of hidden neurons seems to have increased the learning
	1) For more details on the hidden neurons, read another writeup, "[1 vs. 5 Hidden Neurons](https://drive.google.com/file/d/1teUhbqSgzksPxGWmo40RLY3YbG3y9Pkv/view?usp=sharing)"
### Side Tangent: Vowel Backness
- Rather than taking a Neural Network approach to identifying vowel backness, I took the [effect size](https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3444174/&ved=2ahUKEwjztpP50PWEAxVeIDQIHY92DmoQFnoECCUQAQ&usg=AOvVaw1TdLnzmgITF6AhzMyp5bmw) using [Cohen's D](https://statisticsbyjim.com/basics/cohens-d/#:~:text=Cohens%20d%20is%20a%20standardized,psychology%20frequently%20uses%20Cohens%20d.)of the front vs back vowels to attempt to identify which LPC Coefficients could identify `frontness` vs `backness`
- The script for the effect size calculations can be found here: [Generate_LPC_Data.ipynb](https://github.com/Ky-Ng/Vowel-Detection-NN/blob/main/Generate_LPC_Data.ipynb)
### Limitations
The model architecture used for this project is quite simple and more of a proof of concept for more sophisticated speech detection tasks. 

Furthermore, only 218 data samples were used. Since there are 10 output vowels, it would also seem that input output pairs on neurons with less than 4 neurons would not perform well (since models with 3 neurons would only have `2^3 = 8` possibilities while there are 10 vowels)
___
