function Test_MFCC
    [audio_file, fs] = audioread("../wav_data/USC_487_wav_data/wav_data/Vowels_Amanda/aa_amanda.wav");
    
    % [coeffs,delta,deltaDelta,loc] = mfcc(audio_file,fs);
    % length(coeffs)
    % midpoint = round(audio_file / 2);
    % audio_file = audio_file(midpoint - )

    cepFeatures = cepstralFeatureExtractor('SampleRate',fs);
    [coeffs,delta,deltaDelta] = cepFeatures(audio_file);
    plot(coeffs)
end
