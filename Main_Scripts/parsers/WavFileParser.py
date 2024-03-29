import numpy as np
import librosa
import os
from enum import Enum


class WavParameterization(Enum):
    """
    Enum for which Wav file parameterization is being used
    """
    MFCC = 1,
    LPC = 2


class WavFileParser:
    """
    Module for paramterizing wav files into appropriate MFCC or LPC numpy arrays and its corresponding one hot encoding value.
    """

    # Class Attributes
    SEC_TO_MS: float = 1/1000

    def __init__(
            self,
            NUM_COEFF: int,
            RECORDED_SAMPLING_RATE: int,
            TARGET_SAMPLING_RATE: int,
            VOWEL_LIST: list[str]
    ) -> None:
        """
        Initialize the MyClass object.

        ## Parameters:
        NUM_COEFF (int): 
            For best MFCC and LPC parameterization, use one MFCC/LPC coefficient per 1kHz sampling rate
            (e.g., 14kHz sampling audio should have MFCC14 or LPC14)

        ORIGINAL_SAMPLING_RATE (int): 
            Original Sampling Rate

        TARGET_SAMPLING_RATE (int): 
            The sampling rate you wish the audio to be processed at. Note: use one coefficient per 1kHz sampling rate
            for best results

        VOWEL_LIST (list[str]): 
            Holds all the vowels to be used in the training/testing. (e.g., use Hillenbrand or Timmit Database vowel naming convention "uw" for `/u/`)
            The index of the vowel represents the One Hot Encoding ID (i.e., vowel at index 0 has an encoding [1, 0, 0, ..., 0])
        """
        self.NUM_COEFF = NUM_COEFF
        self.RECORDED_SAMPLING_RATE = RECORDED_SAMPLING_RATE
        self.TARGET_SAMPLING_RATE = TARGET_SAMPLING_RATE
        self.VOWEL_LIST = VOWEL_LIST

        if (self.TARGET_SAMPLING_RATE != self.NUM_COEFF * 1000):
            print(
                f"Warning: using {self.NUM_COEFF} coefficients for target sampling rate {self.TARGET_SAMPLING_RATE}. It is recommended to use one coefficient per 1kHz.)")

    def wavs_to_coef(
            wav_files: list[tuple[str, str]],
            serialize_path: str,
            parameterization: WavParameterization = None
    ) -> tuple[np.array, np.array]:
        """
        Converts each wav_file in `wav_files` to a tuple containing [MFCC14/LPC14 coef, Vowel One Hot Encoding]

        Note: if the wav_files will be saved in `serialize_path` and cached there for future calls to this function
        """
        if parameterization is None:
            raise ValueError(
                "Must choose either 'MFCC' or 'LPC' as the parameterization option"
            )

    def wav_to_coef(
            self,
            wav_file_path: str,
            serialize_path: str,
            parameterization: WavParameterization = None
    ) -> np.array:
        
        # Step 0) Check to see that a parameterization setting is set
        if parameterization is None:
            raise ValueError(
                "Must choose either 'MFCC' or 'LPC' as the parameterization option"
            )

        # Step 1) Create Serialization path
        wav_file_name = os.path.basename(wav_file_path)
        save_name = f"{wav_file_name}_{parameterization.name}_{self.NUM_COEFF}.npy"
        
        to_serialize_path = os.path.join(serialize_path, save_name)
        print("to_serialize_path", to_serialize_path)
        # Case 1) Check to see if `wav_f`ile` has been serialized before
        print(os.path.exists(to_serialize_path))
        # if(os.path.exists(to_serialize_path)):
        #     print("Debug: loading from serialization")
        #     return np.load(to_serialize_path)

        # Case 2) wav_file has not been parameterized and serialized before

        # Step 1) Preprocess the Audio File
        audio = self.pre_process_audio(path_to_audio_file=wav_file_path)

        # Step 2) Parameterize the audio using MFCCs or LPCs
        parameterized_audio = None

        if (parameterization == WavParameterization.LPC):
            parameterized_audio = librosa.lpc(audio, order=self.NUM_COEFF)[1:]
        elif (parameterization == WavParameterization.MFCC):
            parameterized_audio = librosa.feature.mfcc(
                y=audio,
                sr=self.TARGET_SAMPLING_RATE,
                n_mfcc=self.NUM_COEFF
            )
            print(parameterized_audio.shape)

        # Step 3) Serialize the audio for the future
        np.save(
            file=to_serialize_path,
            arr=parameterized_audio
        )

        return parameterized_audio

    def get_vowel_encoding(self, vowel: str) -> np.array:
        """
        Creates the one hot encoding for `vowel`. Note: `vowel` must be in `VOWEL_LIST`

        ## Parameters
        vowel: str
            The vowel to be encoded

        ## Returns
        one_hot_encoding: np.array
            An np.array representing the OHE
        """

        # Step 1) Get the OHE location to place a 1
        vowel_encoding_idx = self.VOWEL_LIST.index(vowel)

        if (vowel_encoding_idx == -1):
            raise ValueError(
                f"Vowel {vowel} not in Vowel List: {self.VOWEL_LIST}")

        # Step 2) Create the encoding
        one_hot_encoding = np.zeros(len(self.VOWEL_LIST), dtype=int)
        one_hot_encoding[vowel_encoding_idx] = 1

        return one_hot_encoding

    def pre_process_audio(
            self, path_to_audio_file:
            str,
            NUM_MS=50,
            HIGH_FREQUENCY_HEURISTIC=True) -> np.ndarray:
        """
        Processes an audio file by loading it into a numpy array
        and changing the sample rate to NUM_LPC * 1000 and slicing out 
        NUM_MS (number of milliseconds) before and after the file midpoint. 
            Note: There will be NUM_MS*2 ms worth of sampling

        Additionally, there is a heuristic for adding back frequencies
        using a simple `diff` of consecutive elements which can
        be disabled using the HIGH_FREQUENCY_HEURISTIC flag.

        ## Parameters
        path_to_audio_file : str
            Path to the audio input file

        NUM_MS : int
            The number of milliseconds to sample before and after the waveform file's 
            midpoint in order to account for different starting times and end times of the wav
            files.

        HIGH_FREQUENCY_HEURISTIC : bool
            Whether or not to use transform the audio file into a difference
            of consecutive samples. a[i] = a[i+1] - a[i] 

        ## Returns
        audio_array : np.ndarray
            processed audio file as a numpy array
        """

        # Step 1) Load in Raw Audio
        audio_file, _ = librosa.load(
            path=path_to_audio_file,
            sr=self.RECORDED_SAMPLING_RATE
        )

        # Step 2) Take only the samples NUM_SEC ms before and after the midpoint of the file
        file_middle_idx = len(audio_file) // 2
        num_samples = int(NUM_MS * self.SEC_TO_MS *
                          self.RECORDED_SAMPLING_RATE)
        # Note: Sample rate is in Hz or (samples/sec), so we get # of samples from `ms * (sec/ms) * (samples/sec)`
        middle_audio_only = audio_file[
            file_middle_idx - num_samples:
            file_middle_idx + num_samples
        ]

        # Step 3) Change sample rate
        down_sampled_audio_file = librosa.resample(
            middle_audio_only,
            orig_sr=self.RECORDED_SAMPLING_RATE,
            target_sr=self.TARGET_SAMPLING_RATE
        )

        # Step 4) Rentroduce high frequencies if needed
        if (HIGH_FREQUENCY_HEURISTIC):
            down_sampled_audio_file = np.diff(down_sampled_audio_file)

        return down_sampled_audio_file


def main():
    print("Running WavFileParser Library from main, likely for debugging.\nStarting...")
    parser = WavFileParser(
        NUM_COEFF=14,
        RECORDED_SAMPLING_RATE=44100,
        TARGET_SAMPLING_RATE=14 * 1000,
        VOWEL_LIST=["iy", "ih", "eh", "ae", "ey"]
    )
    print(parser.get_vowel_encoding("ih"))
    print(parser.wav_to_coef(
        "../../wav_data/USC_487_wav_data/wav_data/Vowels_Amanda/aa_amanda.wav",
        serialize_path="./",
        parameterization=WavParameterization.MFCC).T
    )


if __name__ == "__main__":
    main()
