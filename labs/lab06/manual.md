# CS F342 – Computer Architecture
## Lab 6: ImmGen, Memory and RV32I subset
**Objective:** To design and implement the critical sub-systems of a 32-bit RISC-V CPU and integrate them into a functioning single-cycle processor.

---

## Overview
In this lab, you will implement 
- the **Immediate Generator**
- the **PC Incrementer**
- **Banked Memory** systems

Finally, you will integrate these with a **Control Unit** and your **Register File** to execute a basic instruction set (R-type, I-type, Load, and Store).

---

### Instruction Set Support
---
Your CPU must support the following at the end of this lab:
* **R-type:** `add`, `sub`, `and`, `or`
* **I-type:** `addi`, `andi`
* **Load/Store:** `lw`, `sw`

---

## Task 1: Schematics & Design (Pre-Implementation)
*Before writing any Verilog code, you must present the following schematics to your lab instructor for approval.*

### Task 1A : Immediate Generator (ImmGen)
Design a module that extracts the immediate value from a 32-bit instruction.

You can use this table for reference.

| **Instruction Type**              | **Immediate Value Bits (Before Sign Extension)**       |
| --------------------------------- | ------------------------------------------------------ |
| **I-Type** (`addi`, `andi`, `lw`) | `inst[31:20]`                                          |
| **S-Type** (`sw`)                 | `{ inst[31:25], inst[11:7] }`                          |
| **B-Type** (`branches`)           | `{ inst[31], inst[7], inst[30:25], inst[11:8], 1'b0 }` |
---

1. **Block Diagram:** In your circuit, show individual sub-blocks for I-type, S-type, and B-type format generators that take `inst` as input and output a 32-bit binary number. These blocks should feed into a central Multiplexer controlled by `immSel`, so that the correct immediate type is output.
2. **Wiring Logic:** Now, inside each sub-block, show how specific bits from the instruction (e.g., `inst[31:20]`) are wired and sign-extended to form a 32-bit output.

### Task 1B : Banked Memory System
Assume you are provided with a byte-addressable memory module, which means each address applied to the module will return 1 byte (8 bits) of data. However, our CPU operates on 32-bit words. This is how all memories work! So how do we use a byte-addressable memory with a word-addressing procesor to get 4 bytes in a single clock cycle?  

Answer: You use 4 byte addressable memories (called a memory bank), called `bank 0`, `bank 1`, `bank 2` and `bank 3`. `bank 0` will provide the lowest 8 bits, `bank 1` the next 8 bits and so on. The 8-bit outputs of each bank are concatenated to get the full 32-bit word simultaneously (in a single cycle)!  

Note that you have to be careful about the address that you provide to each bank!

1. **Circuit Diagram:** Design a banking system using four 8-bit memory banks. Show how the address bus from the CPU is correctly routed internally inside the bank to the 4 memories. You can assume that the CPU will always output **a word-aligned address** on the address bus.

---
>>>>>**Get these checked from the lab instructor before proceeding!**
---

## Task 2: Module Implementation
Once your schematics are signed off, implement the corresponding modules in Verilog:

## Task 2A : Immediate Generator

### Module Name: `immGen`

**Requirements**: Design an immediate generator which handles I-type, S-type and B-type instructions and generates a sign extended 32 bit operand.

**Inputs**
- 2 bit `immSel`.
- 32 bit `instruction`.

**Output**
- 32 bit sign extended `immOut`.

**Constraint:** Use structural Verilog or continuous assignments (`assign`) to mimic the wiring and MUX logic from your schematic.

**Restriction:** No `always` blocks with behavioral logic for the construction itself.

## Task 2B :  PC Incrementer

### Module Name: `PCInc`

**Logic**: Create a module that takes the current `PC` and outputs `PC + 4`, this modified `PC` is written into the **PC register** on the rising edge of the clock.

**Inputs**
- 32 bit `oldPC`
- `clk`

**Output**
- 32 bit `newPC`

**Requirement:** Reuse the **Adder** module you developed in the previous labs.

## Task 2C : Banked Memory (IMEM & DMEM)

In this task, you will implement a banked 32-bit memory system using four 8-bit memory banks. The memory is divided into:

- Instruction Memory (IMEM) — read-only, asynchronous read

- Data Memory (DMEM) — read/write, asynchronous read, synchronous write

Both memories must fetch or store a full 32-bit word using word-aligned addresses, constructed from four byte-wide memory banks (`bank0`–`bank3`).

8-bit memory banks can be created simply with a register array as follows:
```verilog
    reg [7:0] b0 [0:1023];
    reg [7:0] b1 [0:1023];
    reg [7:0] b2 [0:1023];
    reg [7:0] b3 [0:1023];
```
- Each bank has 1024 lines, which means in total you can address 1024 locations in the memory.  
- How many bits do you need in the address?  
- We are not using the full 32-bit addresses because that will make the memory too large, and cause simulation problems.  
- Accordingly, your circuit should ensure that it ignores part of the input address and only uses the relevant bits to return or write to the correct locations in the memory.

### Module Name: `BankedMEM`

**Inputs**

- `clk` – clock signal

- `writeEn` – enables writing into memory (sw)

- `address` – 32-bit word-aligned address

- `writeData` – 32-bit data to be written

**Outputs**

- `readData` – 32-bit loaded value (lw)

**Constraints**

- Must use four 8-bit memory banks
  
- Reads are asynchronous
  
- Writes occur on posedge clk


## Task 2D : Control Unit

### Module Name: `ControlUnit`

**Logic**: Use a `case` statement based on the instruction `opcode` (behavioral implementation) and `funct3` / `funct7` fields.

**Inputs**
- `instruction`: 32-bit instruction.

**Outputs**
- `RegWrite`: Enables writing to the register file.
- `ALUSrc`: Selects between Register output or Immediate value for ALU input.
- `MemWrite`: Enables writing to data memory.
- `MemRead`: Enables reading from data memory.
- `ALUOp`: 3-bit signal to define the ALU operation (see `lab04` for ALUOp codes).
- `ImmSel`: Control signal for the Immediate Generator.

---

## Task 3: Capstone - CPU Integration
Connect your modules together to form the Single-Cycle CPU.

### Module Name: `cpu_sc_part`

**Inputs**
- None!

**Outputs**
- None!

### Integration Checklist:

1.  **Instruction Fetch:**
    1. Instantiate a `BankedMEM` named `IMEM` and hardwire its `WriteEn` to 0
    2. Connect the `PC` to `IMEM` input
    3. Connect `PC + 4` back to `PC` input.
2.  **Decoding:** Route the instruction to the Control Unit, Register File, and ImmGen after instantiating these three modules.
3.  **Execution:** Instantiate and connect the ALU (from previous lab) with the correct MUX for `ALUSrc`. Connect correct control signals from `ControlUnit` to `ALU` inputs.
4.  **Memory Access:** Instantiate another `BankedMEM` named `DMEM` and connect it appropriately for Load/Store instructions.
5.  **Write Back:** Ensure the Write Back MUX selects between ALU results and Memory results.

---

## Verification (Sample Code)
1. Assemble the following snippet into machine code.
2. Create a test bench and instantiate the `cpu_sc_part` module.
2. In the testbench initial setup, load the machine code into the IMEM of the module.
3. Run the module and verify the register values at the end of the execution:

```assembly
addi x1, x0, 10    # x1 = 10
addi x2, x0, 20    # x2 = 20
add  x3, x1, x2    # x3 = 30
sw   x3, 0(x0)     # Store 30 at memory address 0
lw   x4, 0(x0)     # Load value from address 0 into x4
sub  x5, x4, x1    # x5 = 30 - 10 = 20
```

## Appendix

### Previous modules

If you were unable to complete the previous labs, or do not have confidence in your own modules from previous labs, you can use copy the modules from [here](link).