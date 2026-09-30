# Issue2 Xpulp integration status

The HAMSA secondary lane now decodes an official CORE-V PULP packed two-source ALU subset directly from OPCODE_CUSTOM_3 using the same instruction fields as the primary CV32E40P decoder.

Supported normal register-register packed .h/.b forms on Issue2:
- cv.add / cv.sub
- cv.min / cv.max
- cv.srl / cv.sra / cv.sll
- cv.or / cv.xor / cv.and
- cv.cmpeq / cv.cmpne / cv.cmpgt / cv.cmpge / cv.cmplt / cv.cmple

The secondary execution lane reuses cv32e40p_alu and drives its vector_mode input, preserving existing ALU semantics rather than inventing a second incompatible SIMD implementation. The IDU only admits dependency-simple two-source/one-destination normal forms.

Still deliberately excluded from Issue2:
- scalar-replicate and immediate-vector forms
- dot products and sdot accumulate
- three-source/rd-as-source operations
- post-increment/indexed memory
- hardware-loop/system/CSR/control-flow instructions
- vector operations that require extra RF ports or side effects

Issue2 Xcv retirement is now separately tagged/counted for evaluation. Full-core architectural regression remains mandatory before performance/PPA claims.
