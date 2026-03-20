# Low-Latency-FPGA-Edge-AI-Accelerator-for-Drone-Acoustic-Surveillance

## Overview
This project implements a neural network accelerator in Verilog RTL for real-time drone acoustic detection.  
The system processes MFCC audio features and performs classification directly on hardware.

## Key Features
- Hardware-based neural network (20–16–8–2 architecture)
- Implemented in Verilog RTL (FC layers, ReLU, Argmax)
- Real-time inference using FPGA-friendly design
- Supports MFCC input from real audio signals

## Performance
- Inference Cycles: ~520  
- Latency: ~5.2 µs (100 MHz)  
- Throughput: ~192K inferences/sec  

## Project Structure
- `rtl/` – Verilog modules (neural network)
- `sim/` – Testbench and simulation
- `python_model/` – MFCC generation and training
- `rtl_weights/` – Weights and input files

## How to Run
```bash
iverilog -g2012 -o top_tb rtl/top_nn.v rtl/fc1_layer.v rtl/fc2_layer.v rtl/fc3_layer.v rtl/relu16.v rtl/relu8.v rtl/argmax2.v rtl/fc1_neuron.v sim/tb_top_nn.v
vvp top_tb
