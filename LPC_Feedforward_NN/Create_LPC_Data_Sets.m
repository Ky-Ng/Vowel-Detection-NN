function CreateVCClassifierData_2_14_24

close all;
clc;

VNames = {"iy"; "ih"; "ey"; "eh"; "ae"; "uw"; "uh"; "ow"; "ao"; "aa"};
AUDIO_PATH = "./wav_data/";

% Sampling Rate = 44,100 Hz, 44,100 samples / sec
Fs = 44100;
SEC_TO_MS = 1/1000;
SAMPLE_NUM_50_MS = 50 * SEC_TO_MS * Fs;

% Down sampling rate should be 1000 samples * NUM_LPC, ex LPC14 should have
% 14,000 samples

NUM_LPC = 14;
DOWN_SAMPLE_RATE = round(Fs / (NUM_LPC * 1000))

% Training Data
training_lpc = [];
ground_truth = [];

for vowel_idx = 1 : length(VNames)
    FULL_PATH = AUDIO_PATH + "*/" + VNames(vowel_idx) + "*.wav";
    vowel_files = dir(FULL_PATH)
    
    for file_idx = 1 : length(vowel_files)
        % Load In File
        FILE_PATH = vowel_files(file_idx).folder + "/"  + vowel_files(file_idx).name;
        audio_file = audioread(FILE_PATH);
        
        % Slice Sample by getting 50 ms before and after the middle
        file_middle = round(length(audio_file) / 2);
        
        audio_file_truncated = audio_file(file_middle - SAMPLE_NUM_50_MS : file_middle + SAMPLE_NUM_50_MS);
        audio_file_reintroduce_high_freq = diff(downsample(audio_file_truncated, DOWN_SAMPLE_RATE));
        
        lpc_coefficients = lpc(audio_file_reintroduce_high_freq, NUM_LPC);
        lpc_coefficients = lpc_coefficients(2:15)
        
        training_lpc = [training_lpc; lpc_coefficients]; 
        
        one_hot_encoding = zeros(1, 10);
        one_hot_encoding(vowel_idx) = 1;

        ground_truth = [ground_truth ; one_hot_encoding]
        
        % sound(audio_file) % Listen to the sound
    end

end

save training_lpc1 training_lpc
save ground_truth1 ground_truth