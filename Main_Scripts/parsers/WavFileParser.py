import numpy as np
import librosa

class WavFileParser:
    """
    Module for paramterizing wav files into appropriate MFCC or LPC numpy arrays and its corresponding one hot encoding value.
    """

    # Class Attributes
    SEC_TO_MS = 1/1000

    def __init__(self, NUM_COEFF: int, RECORDED_SAMPLING_RATE: int, TARGET_SAMPLING_RATE: int, VOWEL_LIST: list[str]) -> None:
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


    def wavs_to_coef(
            wav_files: list[str],
            serialize_path: str,
            MFCC: bool = False,
            LPC: bool = False,
    ) -> tuple[np.array, np.array]:
        """
        Converts each wav_file in `wav_files` to a tuple containing [MFCC14/LPC14 coef, Vowel One Hot Encoding]

        Note: if the wav_files will be saved in `serialize_path` and cached there for future calls to this function
        """
        pass

    def wav_to_coef(wav_fiile: str, str, MFCC: bool = False, LPC: bool = False) -> None:
        pass

    def get_vowel_encoding(vowel: str) -> np.array:
        to_ret = np.zeros()
        pass

    def process_audio(self, path_to_audio_file: str, NUM_MS=50, HIGH_FREQUENCY_HEURISTIC=True) -> np.ndarray:
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
            sr=self.RECORDED_SAMPLE_RATE
        )

        # Step 2) Take only the samples NUM_SEC ms before and after the midpoint of the file
        file_middle_idx = len(audio_file) // 2
        num_samples = int(NUM_MS * self.SEC_TO_MS * self.RECORDED_SAMPLE_RATE)
        # Note: Sample rate is in Hz or (samples/sec), so we get # of samples from `ms * (sec/ms) * (samples/sec)`
        middle_audio_only = audio_file[
            file_middle_idx - num_samples:
            file_middle_idx + num_samples
        ]

        # Step 3) Change sample rate
        down_sampled_audio_file = librosa.resample(
            middle_audio_only,
            orig_sr=self.RECORDED_SAMPLE_RATE,
            target_sr=self.TARGET_SAMPLING_RATE
        )

        # Step 4) Rentroduce high frequencies if needed
        if (HIGH_FREQUENCY_HEURISTIC):
            down_sampled_audio_file = np.diff(down_sampled_audio_file)

        return down_sampled_audio_file

def main():
    print("Running WavFileParser Library from main, likely for debugging.\nStarting...")

if __name__ == "__main__":
    main()