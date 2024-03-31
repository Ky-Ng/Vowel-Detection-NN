import numpy as np
import matplotlib.pyplot as plt
import librosa

path_to_audio_file =  "../../wav_data/USC_487_wav_data/wav_data/Vowels_Kyle/aa_kyle.wav"
audio_file, _ = librosa.load(
            path=path_to_audio_file,
            sr=44100
        )

audio_file = librosa.resample(audio_file, orig_sr=44100, target_sr=14000)
diff_freq_audio = np.diff(audio_file)

parameterized_audio = librosa.feature.mfcc(
                y=audio_file,
                sr=14000,
                n_mfcc=14
            )

parameterized_audio_diff = librosa.feature.mfcc(
                y=diff_freq_audio,
                sr=14000,
                n_mfcc=14
            )

print(parameterized_audio.shape)
print(parameterized_audio.T)

print ("=========")
print(parameterized_audio_diff.shape)
print(parameterized_audio_diff.T)

plt.figure()
plt.plot(parameterized_audio_diff[0])
plt.xlabel('Frame')
plt.ylabel('MFCC')
plt.title('First MFCC feature of differentiated audio')
plt.show()
