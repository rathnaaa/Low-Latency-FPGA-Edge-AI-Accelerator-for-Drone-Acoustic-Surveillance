import numpy as np

rows = []

with open("../rtl_weights/w3.txt") as f:
    for line in f:
        rows += line.split()

# ensure exactly 16 values
rows = rows[:16]

with open("../rtl_weights/w3_fixed.txt","w") as f:
    for v in rows:
        f.write(v + "\n")

print("w3_fixed.txt created")
