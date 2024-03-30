% Process the audio to be used for parameterization including: (1) resampling and (2) silence removal
function processed_audio = preProcessAudio(audio_file_path, original_sampling_rate, target_sampling_rate)
    disp("processing audio for file path " + audio_file_path)

    raw_audio = audioread(audio_file_path);
    trimmed_audio = removeSilence(raw_audio, original_sampling_rate);

    figure;
    plotCompareAudio(raw_audio, trimmed_audio, original_sampling_rate, original_sampling_rate, "Raw Audio", "Trimmed Audio");

    resampled_audio = downSampleAudio(trimmed_audio, original_sampling_rate, target_sampling_rate);
end

% Helper function to resample audio since most parameterization heuristics are 1 coefficient per 1kHz sampling rate
function resampled_audio = downSampleAudio(audioIn, original_sampling_rate, target_sampling_rate)
    resampled_audio = resample(audioIn, target_sampling_rate, original_sampling_rate);
    sound(resampled_audio, target_sampling_rate);
    pause((length(resampled_audio) / target_sampling_rate) + 0.5);
end

% Helper function to remove the silence before and after the main speech segment
% Note: this assumes the function has only one continuous speech segment
function trimmed_audio = removeSilence(raw_audio, sampling_rate)
    % Step 1) Get the audio boundaries
    roi = detectSpeech(raw_audio, sampling_rate);
    start_idx = roi(1);
    end_idx = roi(2);

    % Step 2) Return the clipped audio
    trimmed_audio = raw_audio(start_idx : end_idx);
end

function plotAudio(audio_time_series, sampling_rate, plot_title)
    % Step 1) Generate the x-axis for time
    time_indexes = generateTimeAxis(audio_time_series, sampling_rate);

    % Step 2) Plot audio
    figure;
    title(plot_title);
    set(gcf, 'Name', plot_title);
    plot(time_indexes, audio_time_series);
end

function plotCompareAudio(audio1, audio2, sampling_rate1, sampling_rate2, audio1_title, audio2_title)
    % Step 1) Create Plots
    tiledlayout(2, 1);

    % Step 2) Generate time series
    time_indexes1 = generateTimeAxis(audio1, sampling_rate1);
    time_indexes2 = generateTimeAxis(audio2, sampling_rate2);

    % Step 3) Plot
    subplot = nexttile;
    plot(subplot, time_indexes1, audio1);
    title(subplot, audio1_title);

    subplot = nexttile;
    plot(subplot, time_indexes2, audio2);
    title(subplot, audio2_title);

    set(gcf, "Name", audio1_title + " vs. " + audio2_title)
end

function time_series = generateTimeAxis(audio_time_series, sampling_rate)
    % Step 1) Generate the x-axis for time
    num_samples = length(audio_time_series);
    time_indexes = 0 : num_samples - 1;

    % Step 2) Convert each sample index to its respective time
    time_series = time_indexes / sampling_rate;
end