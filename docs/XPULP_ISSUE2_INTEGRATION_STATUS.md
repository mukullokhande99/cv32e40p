# Issue2 Xpulp integration status
The architectural Issue2 decoder now recognizes an official CORE-V PULP/Xcv two-source packed-ALU subset under OPCODE_CUSTOM_3 and drives the native CV32E40P ALU vector mode. Supported register-register .h/.b operations are add, sub, signed min/max, shifts, OR/XOR/AND and signed compare forms represented in the primary decoder. The HAMSA IDU classifies the same subset as two-source/one-destination and therefore reuses existing RAW/WAW checks, forwarding and in-order writeback.

Scalar-replicate/immediate forms, unsigned variants not explicitly decoded, dot products/MAC, three-source operations, post-increment memory, hardware-loop and system/control operations remain Issue1-only. This boundary is intentional: those classes require extra operand/dependency or side-effect semantics.

Directed CI checks official encoding acceptance/rejection. Full-core architectural regression is still required before performance/PPA claims.
