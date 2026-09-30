# HAMSA-DI Xpulp/FLEX extension

Research extension target for the secondary lane. Keep Issue1 fully backward-compatible with COREV_PULP/Xcv. Issue2 adds only dependency-simple, two-source/one-destination packed operations first: 8/16-bit add, sub, signed compare, min and max. Three-source MAC/dot-product, post-increment memory, hardware-loop control, CSR/system and complex operations remain Issue1 until the secondary RF/dependency model is widened.

A standalone packed-SIMD execution block is provided for verification and as a fallback. The preferred final integration is to drive the existing cv32e40p_alu vector controls after exact Xcv opcode decode is shared/refactored from the primary decoder. Do not assign new encodings that collide with official Xcv encodings.

FLEX accelerator control remains MMIO-based in ApproxSNN, avoiding unnecessary ISA coupling during functional bring-up. A later custom accelerator instruction may be evaluated only after the MMIO baseline is regression-clean.
