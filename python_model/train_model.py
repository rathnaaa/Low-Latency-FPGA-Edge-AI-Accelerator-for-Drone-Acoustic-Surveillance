import os
import numpy as np
import librosa
from sklearn.model_selection import train_test_split
from sklearn.neural_network import MLPClassifier
from sklearn.metrics import accuracy_score

DATASET_PATH = "dataset"
SAMPLE_RATE = 22050
MFCC_FEATURES = 20

def extract_features(file_path):
    audio, sr = librosa.load(file_path, sr=SAMPLE_RATE)
    mfcc = librosa.feature.mfcc(y=audio, sr=sr, n_mfcc=MFCC_FEATURES)
    mfcc_mean = np.mean(mfcc.T, axis=0)
    return mfcc_mean

X = []
y = []

print("Loading dataset...")

for label, folder in enumerate(["non_drone", "drone"]):
    path = os.path.join(DATASET_PATH, folder)

    for file in os.listdir(path):
        file_path = os.path.join(path, file)
        features = extract_features(file_path)

        X.append(features)
        y.append(label)

X = np.array(X)
y = np.array(y)

print("Dataset loaded:", X.shape)

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

print("Training model...")

model = MLPClassifier(
    hidden_layer_sizes=(16, 8),
    activation="relu",
    max_iter=200
)

model.fit(X_train, y_train)

preds = model.predict(X_test)
acc = accuracy_score(y_test, preds)

print("Accuracy:", acc)

# -------------------------
# EXPORT WEIGHTS FOR RTL
# -------------------------
import os

os.makedirs("../rtl_weights", exist_ok=True)

# def save_weights_txt(array, filename):
#     with open(filename, "w") as f:
#         for row in array:
#             if isinstance(row, np.ndarray):
#                 line = " ".join(str(int(x)) for x in row)
#             else:
#                 line = str(int(row))
#             f.write(line + "\n")

def save_weights_txt(array, filename):
    with open(filename, "w") as f:
        for row in array:
            if isinstance(row, np.ndarray):
                line = " ".join(format((x & 0xff), '02x') for x in row)
            else:
                line = format((row & 0xff), '02x')
            f.write(line + "\n")


# Quantization scale
scale = 127

# Layer 1
w1 = model.coefs_[0] * scale
b1 = model.intercepts_[0] * scale

# Layer 2
w2 = model.coefs_[1] * scale
b2 = model.intercepts_[1] * scale

# Layer 3
w3 = model.coefs_[2] * scale
b3 = model.intercepts_[2] * scale

# Convert to int
w1 = np.round(w1).astype(int)
b1 = np.round(b1).astype(int)
w2 = np.round(w2).astype(int)
b2 = np.round(b2).astype(int)
w3 = np.round(w3).astype(int)
b3 = np.round(b3).astype(int)

# Save
save_weights_txt(w1, "../rtl_weights/w1.txt")
save_weights_txt(b1.reshape(-1,1), "../rtl_weights/b1.txt")

save_weights_txt(w2, "../rtl_weights/w2.txt")
save_weights_txt(b2.reshape(-1,1), "../rtl_weights/b2.txt")

save_weights_txt(w3, "../rtl_weights/w3.txt")
save_weights_txt(b3.reshape(-1,1), "../rtl_weights/b3.txt")

print("Weights exported for RTL.")

def save_bias_hex(arr, filename):
    with open(filename, "w") as f:
        for v in arr:
            f.write(format(np.uint8(int(v)), '02x') + "\n")

save_bias_hex(np.round(b1).astype(int), "../rtl_weights/b1.txt")
save_bias_hex(np.round(b2).astype(int), "../rtl_weights/b2.txt")
save_bias_hex(np.round(b3).astype(int), "../rtl_weights/b3.txt")

print("Bias exported")

