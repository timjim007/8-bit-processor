# 8-bit RISC Processor

## Overview
This document provides an overview of the instruction set design for the 8-bit RISC processor. The instructions are grouped into two main categories:
1. **Arithmetic and Logic Unit (ALU) Operations**
2. **Control and Memory Operations**

Each operation is encoded using a unique opcode for ease of execution in the processor.

---

## ALU Operations
The ALU supports a variety of arithmetic and logical operations. Below is the list of supported ALU instructions:

| **Instruction** | **Description**         | **Opcode** |
|------------------|-------------------------|------------|
| `ALU_ADD`       | Add two numbers         | `4'b1000`  |
| `ALU_SUB`       | Subtract two numbers    | `4'b1001`  |
| `ALU_INC`       | Increment value by 1    | `4'b1010`  |
| `ALU_DEC`       | Decrement value by 1    | `4'b1011`  |
| `ALU_AND`       | Logical AND operation   | `4'b1100`  |
| `ALU_XOR`       | Logical XOR operation   | `4'b1101`  |
| `ALU_OR`        | Logical OR operation    | `4'b1110`  |
| `ALU_NOP`       | No operation (pass-through)| `4'b1111`  |

---

## Control and Memory Operations
These instructions handle memory access and control flow within the processor:

| **Instruction** | **Description**                       | **Opcode** |
|------------------|---------------------------------------|------------|
| `OP_ST`         | Store value to memory                 | `4'b0000`  |
| `OP_LDI`        | Load immediate value into register    | `4'b0001`  |
| `OP_LD`         | Load value from memory into register  | `4'b0010`  |
| `OP_JE`         | Jump to address if equal (flag-based) | `4'b0011`  |
| `OP_JMP`        | Unconditional jump to address         | `4'b0100`  |
| `OP_JNE`        | Jump to address if not equal          | `4'b0101`  |
| `OP_JC`         | Jump to address if carry flag is set  | `4'b0110`  |

---

## Instruction Encoding Diagram
Below is a visual representation of the instruction encoding and specific examples of the instruction set:

![Instruction Encoding](<image1.png>)


---

## How to Use
1. **Instruction Format:**
   Each instruction is represented by a 4-bit opcode. The control unit decodes these opcodes to execute the corresponding operation.

2. **Extensibility:**
   - The ALU and control operations are designed to be modular and extensible for future enhancements.

3. **Instruction Execution:**
   - Arithmetic and logic operations are performed on registers.
   - Control instructions handle branching and memory interactions.

---

## References
This processor design references materials and examples from:
- [BitSpinner](https://www.bit-spinner.com)
- [FPGA4Student](https://www.fpga4student.com)

These resources were instrumental in completing the 8-bit RISC processor.

---

## Example Usage

---

## Future Updates
This instruction set is a work-in-progress and may include additional instructions or modifications in subsequent updates.

