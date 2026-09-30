# Issue2 Xpulp integration status
Packed execution RTL and directed tests exist. The remaining critical step is exact official-Xcv decode reuse from the primary CV32E40P decoder. Until that refactor is complete, the packed block is not connected to the architectural Issue2 decoder and no new/custom opcode is assigned. This is intentional to prevent encoding collisions and semantic drift.

Dependency rule for the first integrated subset: exactly two GPR sources and one GPR destination, no memory side effects, no implicit accumulator and no control-flow state. This allows existing HAMSA RAW/WAW/forwarding machinery to remain valid.
