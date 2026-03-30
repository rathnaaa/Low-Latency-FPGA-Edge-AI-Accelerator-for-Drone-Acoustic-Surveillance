import librosa
import numpy as np

AUDIO_FILE = "sample.wav"   # put drone audio here

# Load audio
y, sr = librosa.load(AUDIO_FILE, sr=16000)

# Extract MFCC
mfcc = librosa.feature.mfcc(
    y=y,
    sr=sr,
    n_mfcc=20
)

# Take mean across time
mfcc_vec = np.mean(mfcc, axis=1)

# Quantize to int8
mfcc_q = np.clip(np.round(mfcc_vec), -128, 127).astype(np.int8)

print("MFCC vector:", mfcc_q)

# Save HEX for Verilog
with open("../rtl_weights/mfcc_input.txt", "w") as f:
    for v in mfcc_q:
        f.write(format(np.uint8(v), '02x') + "\n")

print("mfcc_input.txt generated")