function mfccs = getMfccCoef(audioIn, sampling_rate, num_mfccs)
    cepFeatures = cepstralFeatureExtractor('SampleRate', sampling_rate,'NumCoeffs', num_mfccs);
    [coeffs,~,~] = cepFeatures(audioIn);
    mfccs = coeffs(2:length(coeffs));
end