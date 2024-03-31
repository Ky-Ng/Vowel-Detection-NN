function Process_Audio_Main()
    close all; clc;
    disp("Starting Audio Processing ...")
    test1 = "../wav_data/USC_487_wav_data/wav_data/Vowels_Amanda/aa_amanda.wav";
    test2 = "../wav_data/USC_487_wav_data/wav_data/Vowels_Frank/eh_frank.wav";
    test3 = "../wav_data/USC_487_wav_data/wav_data/Vowels_EvanChee/aa_EvanChee.wav";

    ORIGINAL_SAMPLING_RATE = 44100;
    TARGET_SAMPLING_RATE = 14000;
    
    preProcessAudio(test1,ORIGINAL_SAMPLING_RATE, TARGET_SAMPLING_RATE);
    preProcessAudio(test2,ORIGINAL_SAMPLING_RATE, TARGET_SAMPLING_RATE);
    preProcessAudio(test3,ORIGINAL_SAMPLING_RATE, TARGET_SAMPLING_RATE);
end