% Implementation of `Create_Data_Sets.m` for getting training data 
function Create_Training_Data()
    addpath("lib/");

    % Declare Constants
    VOWELS = {"iy"; "ih"; "ei"; "eh"; "ae"; "uw"; "uh"; "oa"; "aw"; "ah"};
    AUDIO_PATH = "../wav_data/Hillenbrand_wav_data/first_10_samples";

    SAVE_DATA_LOCATION_BASE = "./data/Hillenbrand";

    ORIGINAL_SAMPLING_RATE = 44100;
    NUM_COEFICIENTS = 14;

    speaker_type_subfolders = dir(AUDIO_PATH)
    for speaker_type_idx = 1 : length(speaker_type_subfolders)
        % Skip the `.` and `..` directory
        if speaker_type_subfolders(speaker_type_idx).name == "." || speaker_type_subfolders(speaker_type_idx).name == ".."
            continue
        end

        speaker_type_folder = speaker_type_subfolders(speaker_type_idx).folder + "/" + speaker_type_subfolders(speaker_type_idx).name;
        save_data_location = SAVE_DATA_LOCATION_BASE + "/" + speaker_type_subfolders(speaker_type_idx).name + "/";

        fprintf("Starting LPC Training Data creation ...")
        Create_Data_Sets(VOWELS, speaker_type_folder, save_data_location, ORIGINAL_SAMPLING_RATE, NUM_COEFICIENTS, Parameterization.LPC, false);
        disp("Done.")

        fprintf("Starting MFCC Training Data creation ...")
        Create_Data_Sets(VOWELS, speaker_type_folder, save_data_location, ORIGINAL_SAMPLING_RATE, NUM_COEFICIENTS, Parameterization.MFCC, false);
        disp("Done.")
    end
    
end