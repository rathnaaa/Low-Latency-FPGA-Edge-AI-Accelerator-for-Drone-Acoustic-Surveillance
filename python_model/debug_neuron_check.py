import numpy as np

# same inputs as testbench
x = np.array([i for i in range(20)], dtype=int)

# EXACT weights printed by RTL
w = np.array([
    8, 6, -5, -34, 42, 13, -12, 33, -22, 47,
    19, 15, 2, 3, 53, -55, 23, 42, -9, -18
], dtype=int)

out = np.sum(x * w)
print("Python neuron output:", out)
