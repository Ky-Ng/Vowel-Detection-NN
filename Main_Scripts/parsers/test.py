import librosa

path_to_audio_file =  "../../wav_data/USC_487_wav_data/wav_data/Vowels_Amanda/aa_amanda.wav"
audio_file, _ = librosa.load(
            path=path_to_audio_file,
            sr=44100
        )

audio_file = librosa.resample(audio_file, orig_sr=44100, target_sr=14000)
parameterized_audio = librosa.feature.mfcc(
                y=audio_file,
                sr=14000,
                n_mfcc=14
            )
print(parameterized_audio.shape)
print(parameterized_audio.T)