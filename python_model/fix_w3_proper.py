import numpy as np

vals = []

with open("../rtl_weights/w3.txt") as f:
    for line in f:
        vals.extend(line.split())

# pad if missing
while len(vals) < 16:
    vals.append("00")

with open("../rtl_weights/w3_fixed.txt","w") as f:
    for v in vals[:16]:
        f.write(v + "\n")

print("w3_fixed corrected")