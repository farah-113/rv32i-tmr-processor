# Fault-Tolerant RISC-V Processor (RV32I/TMR)

Single-cycle RV32I processor design in VHDL, with component-level
functional verification and ongoing development of Triple Modular
Redundancy (TMR).

**Development period:** October 2026 – Present

**Status:** In development

## Project Overview

This project explores RISC-V processor architecture, RTL design,
functional verification, and fault-tolerant computing.

The first phase focuses on designing and verifying the RTL components
of a single-cycle processor targeting 20 RV32I instructions.

The next phase focuses on integrating three identical processor cores
operating in lockstep, with majority voting to mitigate single-core
faults.

## Technical Specifications

- 32-bit datapath
- 32 general-purpose 32-bit registers
- Hardwired zero register (x0)
- 256-word instruction ROM
- 256-word data RAM
- Eight ALU operations
- Main decoder and ALU decoder
- Immediate generation for I, S, B, U and J formats
- Branch comparison and next-PC selection
- Multiple write-back sources

## Target Instruction Subset

| Type | Instructions |
|------|--------------|
| R-type | ADD, SUB, AND, OR, XOR, SLT |
| I-type arithmetic | ADDI, ANDI, ORI, SLLI, SRLI |
| Memory | LW, SW |
| Branch | BEQ, BNE, BLT |
| Jump | JAL, JALR |
| Upper immediate | LUI, AUIPC |

## Functional Verification

The project follows a simulation-first development methodology,
using self-checking VHDL testbenches to compare actual component
outputs against expected results automatically.

The verification suite contains six testbenches with a combined
total of 2,914 test vectors and checks.

| Testbench | Checks | Coverage |
|-----------|-------:|----------|
| ALU | 1888 | Arithmetic, logic, shifts and edge cases |
| Immediate generator | 86 | Immediate formats and sign extension |
| Register file | 100 | Read/write behavior and x0 protection |
| Control unit | 23 | Instruction decoding and control signals |
| PC logic | 43 | Branches, jumps, reset and address calculation |
| Memories | 774 | ROM contents and RAM read/write behavior |
| Total | 2914 | Component-level verification |

### Verification Methodology

- Automated comparison of actual and expected outputs
- Python-generated reference test vectors
- Boundary and corner-case testing
- Signed arithmetic and comparison testing
- Clock-edge and write-enable verification
- Diagnostic reporting for mismatched results
- Automatic PASS/FAIL reporting

## Technologies

- VHDL / VHDL-2008
- RISC-V (RV32I)
- AMD Xilinx Vivado 2024.2
- Vivado XSIM
- GHDL
- Xilinx Artix-7 (XC7A100T)

## Repository Structure

- `rtl/` - Processor RTL components and VHDL packages.
- `testbenches/` - Self-checking testbenches and reference vectors.

## Running the Simulations

1. Create a Vivado RTL project.
2. Add the files from `rtl/` as design sources.
3. Add the files from `testbenches/` as simulation sources.
4. Set the testbench source files to VHDL-2008.
5. Select the desired testbench as the simulation top.
6. Run behavioral simulation.
7. Inspect the PASS/FAIL result in the simulation console.

Use `run all` in the Tcl console if the default simulation
duration is insufficient.

## Development Status

- [x] Individual RTL components
- [x] Component-level self-checking testbenches
- [x] Reference test-vector package
- [ ] Integrated processor top-level published
- [ ] End-to-end processor verification
- [ ] Triple Modular Redundancy integration
- [ ] Majority voter implementation
- [ ] Fault injection experiments
- [ ] FPGA implementation of the TMR architecture
- [ ] Timing and resource utilization analysis

## Future Work

Implement and verify a triple-core lockstep architecture with
majority voting. Evaluate fault tolerance through fault injection
and compare the single-core and redundant architectures in terms
of FPGA resource utilization and timing performance.
