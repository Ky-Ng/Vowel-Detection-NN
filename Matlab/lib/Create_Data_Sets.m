% Creates a .mat file containing the Wav Parameterization and 
function Create_Data_Sets(VOWELS, TRAINING_AUDIO_PATH, SAVE_DATA_LOCATION, ORIGINAL_SAMPLING_RATE, NUM_COEFICIENTS, parameterization_mode)
    close all;
    clc;

    TARGET_SAMPLING_RATE = NUM_COEFICIENTS * 1000;
    total_samples = 0;

    % Matrices to save
    wav_parameterization = [];
    one_hot_encoding_labels = [];

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
            coefficients = [];

            switch parameterization_mode
                case Parameterization.LPC
                    coefficients = getLpcCoef(processed_audio, NUM_COEFICIENTS, true);
                case Parameterization.MFCC
                    coefficients = getMfccCoef(processed_audio, TARGET_SAMPLING_RATE, NUM_COEFICIENTS);
                otherwise
                    disp("Incorrectly Chose Parameterization Option");
                    return
            end

            
            % Step 5) Place coefficients in Training Matrices to be serialized
            wav_parameterization = [wav_parameterization; coefficients];    

            one_hot_encoding_label = getOneHotEncoding(vowel_idx, VOWELS);
            one_hot_encoding_labels = [one_hot_encoding_labels; one_hot_encoding_label];
            
            % Step 6) Increment total samples for file naming
            total_samples = total_samples + 1;
        end
    end

    % Step 7) Save Data and Labels to .mat formats
    save_name = sprintf("%d_vowels_%d_samples", length(VOWELS), total_samples);
    switch parameterization_mode
        case Parameterization.LPC
            save_name = "LPC_" + save_name;
        case Parameterization.MFCC
            save_name = "MFCC_" + save_name;   
    end

    % In Matlab, code 7 means the path exists 
    path_not_exists = ~exist(SAVE_DATA_LOCATION, 'dir');
    if (path_not_exists)
        fprintf("Creating Path: %s", SAVE_DATA_LOCATION);
        mkdir(SAVE_DATA_LOCATION)
        disp("Done.")
    end

    save(SAVE_DATA_LOCATION + save_name, "wav_parameterization", "one_hot_encoding_labels");
end

function one_hot_encoding_label = getOneHotEncoding(vowel_idx, VOWELS)
    one_hot_encoding_label = zeros(1, length(VOWELS));
    one_hot_encoding_label(vowel_idx) = 1;
end
