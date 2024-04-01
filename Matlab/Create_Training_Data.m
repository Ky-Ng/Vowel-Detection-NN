% Implementation of `Create_Data_Sets.m` for getting training data 
function Create_Training_Data()
    % Declare Constants
    VOWELS = {"iy"; "ih"; "ey"; "eh"; "ae"; "uw"; "uh"; "ow"; "ao"; "aa"};
    TRAINING_AUDIO_PATH = "../wav_data/USC_487_wav_data/wav_data";
    SAVE_DATA_LOCATION = "./data/"

    ORIGINAL_SAMPLING_RATE = 44100;
    NUM_COEFICIENTS = 14;

    fprintf("Starting LPC Training Data creation ...")
    Create_Data_Sets(VOWELS, TRAINING_AUDIO_PATH, SAVE_DATA_LOCATION, ORIGINAL_SAMPLING_RATE, NUM_COEFICIENTS, Parameterization.LPC, true);
    disp("Done.")

    fprintf("Starting MFCC Training Data creation ...")
    Create_Data_Sets(VOWELS, TRAINING_AUDIO_PATH, SAVE_DATA_LOCATION, ORIGINAL_SAMPLING_RATE, NUM_COEFICIENTS, Parameterization.MFCC, true);
    disp("Done.")
end