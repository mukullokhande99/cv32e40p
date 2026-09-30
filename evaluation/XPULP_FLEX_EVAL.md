# Xpulp/FLEX evaluation

Compare identical HAMSA configurations with the Issue2 Xcv admission gate enabled/disabled. Use packed preprocessing, quantization, spike bookkeeping and control kernels that naturally map to two-source 8/16-bit SIMD.

Report:
- cycles, IPC and benchmark score
- Issue2 issued/retired/blocked/killed
- Issue2 Xcv retired and Xcv share of Issue2 retirement
- pair utilization and block reasons
- area, Fmax, power, energy/instruction
- end-to-end ApproxSNN application latency and CPU/accelerator overlap

Do not infer application benefit from microbench IPC alone. Keep compiler flags, memory timing, CPU configuration and accelerator configuration fixed for each ablation.
