# 8-Bit RISC Processor

## Overview

This project implements an **8-bit RISC (Reduced Instruction Set Computer)** processor using **Verilog**, designed for deployment on the **Basys 3 FPGA board** using **Xilinx Vivado**.

The processor features a Harvard architecture with a simplified instruction set, supporting basic arithmetic, logic, memory, and control flow operations. It includes a custom 5-stage instruction pipeline and is capable of running small assembly programs. The system demonstrates functionality through an interactive 7-segment display.

---
### Architecture Diagram
![CPU architecture](<CPU architecture.png>)

---
### Demo
A sample program counts from 0 to 255 and displays the value of any register selected via the on-board switches on the 7-segment display.
![Demo](IMG_5401.gif)
---

## Features

- **Harvard architecture**
- **Load/Store architecture**
- **16-bit instruction word**
- **256 bytes** of **data** and **instruction** memory
- **8-bit datapath**
- **8 general-purpose registers** (`R0–R7`)
- **Flag support**: Zero (Z), Carry (C), Negative (N)
- **5-stage pipeline**: IF, ID, EX, MEM, WB

---

## Instruction Set Architecture (ISA)

Below is a visual representation of the instruction encoding and specific examples of the instruction set:

![Instruction Encoding](<image1.png>)

### Instruction Format

| Type | Format                  | Description                      |
|------|--------------------------|----------------------------------|
| R    | `opcode rd rs1 rs2`      | Register-to-register operations  |
| I    | `opcode rd imm`          | Immediate to register            |
| LD   | `opcode rd [rs1]`        | Load from memory                 |
| ST   | `opcode [rd] rs1`       | Store to memory                  |
| BR   | `opcode imm`             | Conditional/unconditional branch |

---

## ALU Operations

| Instruction | Description               | Opcode     |
|-------------|---------------------------|------------|
| ADD         | Add two numbers           | `1000`     |
| SUB         | Subtract two numbers      | `1001`     |
| INC         | Increment by 1            | `1010`     |
| DEC         | Decrement by 1            | `1011`     |
| AND         | Logical AND               | `1100`     |
| XOR         | Logical XOR               | `1101`     |
| OR          | Logical OR                | `1110`     |
| NOP         | No operation              | `1111`     |

---

## Memory and Control Instructions

| Instruction | Description                         | Opcode     |
|-------------|-------------------------------------|------------|
| ST          | Store register to memory            | `0000`     |
| LDI         | Load immediate value                | `0001`     |
| LD          | Load from memory                    | `0010`     |
| JE          | Jump if equal (zero flag)           | `0011`     |
| JMP         | Unconditional jump                  | `0100`     |
| JNE         | Jump if not equal (zero flag clear) | `0101`     |
| JC          | Jump if carry flag is set           | `0110`     |

---

## Control Signals

- `alu_op_o` – ALU operation select  
- `en_jmp_o` – Enable jump  
- `we_mem_o` – Write enable for memory  
- `ld_mem_o` – Load enable for memory  
- `we_reg_o` – Write enable for register file  
- `en_immediate_o` – Enable immediate value  
- `use_immediate_pc` – Use immediate for program counter

---

## Pipeline Architecture

The processor uses a **5-stage pipeline** for instruction execution:

1. **IF** – Instruction Fetch  
2. **ID** – Instruction Decode  
3. **EX** – Execute  
4. **MEM** – Memory Access  
5. **WB** – Writeback

---

## Project Structure
```graphql
  ├─ src/ # Verilog source files
  ├─ sim/ # Simulation testbenches
  ├─ README.md # Project documentation
  ├─ constraints.xdc # Basys 3 pin configuration

```

---

## FPGA Integration

- **Board**: Basys 3 (Xilinx Artix-7 FPGA)
- **Clock Source**: 100 MHz on-board clock, divided for slower human-readable output

### Inputs
- **Switches**: Select register to display
- **Buttons**: Reset, step-through (optional)

### Outputs
- **7-Segment Display**: Shows selected register value

---

## Simulation

Testbenches for each major component are included in the `sim/` directory. Use your preferred Verilog simulator (such as Icarus Verilog or ModelSim) to run simulations.

```bash
# Example simulation with Icarus Verilog
iverilog -o cpu_tb sim/cpu_tb.v src/*.v
vvp cpu_tb
