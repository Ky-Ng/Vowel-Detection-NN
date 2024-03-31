function Get_MFCC_Coef_TestDriver()
    close all;
    clc;

    % Declare Constants
    VOWELS = {"iy"; "ih"; "ey"; "eh"; "ae"; "uw"; "uh"; "ow"; "ao"; "aa"};
    % VOWELS = {"iy"; "ih"; "ey"; "eh"; "ae"; "uw"; "uh"};
    % PLOT_COLOR = ["red"; "green"; "blue"; "cyan"; "magenta"; "yellow"; "black"] ;

    % VOWELS = {"iy"; "uw"};
    % PLOT_COLOR = ["red"; "green" ] ;

    TRAINING_AUDIO_PATH = "../wav_data/USC_487_wav_data/wav_data/";

    ORIGINAL_SAMPLING_RATE = 44100;
    NUM_COEFICIENTS = 14;
    TARGET_SAMPLING_RATE = NUM_COEFICIENTS * 1000;

    % Training Data
    training_inputs = [];
    training_label = [];

    % Parameterization Mode
    parameterization_mode = Parameterization.UNSET;

    % Step 1) Go through each vowle in `VOWELS`
    for vowel_idx = 1 : length(VOWELS)
        full_path = TRAINING_AUDIO_PATH + "*/*" + VOWELS(vowel_idx) + "*.wav";
        vowel_files = dir(full_path);

        % Step 2) Go through each corresponding `vowel.wav` file
        for file_idx = 1 : length(vowel_files)
            
            % Step 3) Load In File and process audio
            FILE_PATH = vowel_files(file_idx).folder + "/"  + vowel_files(file_idx).name;
            
            % Preprocess the audio by removing silences and resampling
            processed_audio = preProcessAudio(FILE_PATH, ORIGINAL_SAMPLING_RATE, TARGET_SAMPLING_RATE);
            
            % Step 4) Generate Coefficients
            coefficients = getMfccCoef(processed_audio, TARGET_SAMPLING_RATE, NUM_COEFICIENTS);

            hold on;
            plot(coefficients, 'Color', PLOT_COLOR(vowel_idx))
            
            % Step 5) Place coefficients in Training Matrices to be serialized
            training_inputs = [training_inputs; coefficients]; 
            
            one_hot_encoding = getOneHotEncoding(vowel_idx, VOWELS);

            training_label = [training_label; one_hot_encoding];
            
        end
    end
    

end

function one_hot_encoding = getOneHotEncoding(vowel_idx, VOWELS_LIST)
    one_hot_encoding = zeros(1, length(VOWELS_LIST));
    one_hot_encoding(vowel_idx) = 1;
end
