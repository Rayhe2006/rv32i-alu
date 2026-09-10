# RV32I ALU — SystemVerilog

A 32-bit Arithmetic Logic Unit implementing the full operation set required
by the RV32I base instruction set: add, subtract, AND/OR/XOR, shift left
logical, shift right logical, shift right arithmetic, set-less-than
(signed), and set-less-than (unsigned).

It's a pure combinational block (no clock, no state) with a self-checking
testbench — 11 directed test cases plus a dedicated check of the `zero`
output flag, which a real CPU uses to resolve `beq`/`bne` branches.

## Files

- `rtl/alu.sv` — the ALU. Operation select is a `typedef enum` rather than
  magic
