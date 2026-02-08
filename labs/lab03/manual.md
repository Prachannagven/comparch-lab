# CS F342 – Computer Architecture
## Lab 3: RISC-V Assembly Programming, Encoding, and Decoding of Instructions


## Objective

The objective of **Lab 3** is to understand the **Instruction Set Architecture (ISA)** from both the **programmer’s** and the **hardware designer’s** perspective.

In this lab, you will:

- Write **non-trivial RISC-V assembly programs**
- Understand how assembly instructions are **encoded into machine code**
- Manually **decode machine code** back into assembly
- Observe how instructions are **decoded and executed** in hardware
- Relate instruction fields to:
  - register file access
  - immediate generation
  - PC update logic
  - control flow

This lab explicitly bridges **ISA semantics** with **datapath and control concepts** discussed in the lectures.

---

## Tool

You will use a web-based RISC-V simulator:

https://riscv-simulator-five.vercel.app/

You are expected to:
- assemble code
- step through execution instruction-by-instruction
- inspect PC, registers, and datapath signals

using this tool.

## Using the Simulator
- The left panel is for writing assembly code.
- Press **Assemble** to convert your code into machine instructions.
- Use **Step** or **Run** to observe execution.
- The right panel displays:
  - **Program Counter (PC)**
  - **Register values**
  - **Immediate generation**
  - **Control and datapath signals**

- You are encouraged to **step through one instruction at a time** to understand how each instruction affects the registers and PC.
- You can also look at the actual datapath by switching to the `datapath` tab on the top. As you step through your code, you can see how the signals propagate through the datapath and register values change.
- The memory tab shows the different memory contents
   - data: data memory
   - text: program / instruction memory
---

## Submission

- Add this lab folder to your GitHub codespace.
- Treat this file as a worksheet and fill in the appropriate places indicated below (empty code blocks and tables).
- Commit after finishing all tasks with the message exactly: `lab03 eval`.
- You can commit at intermediate steps with other messages if you wish.

---

## Task 1: Basic Assembly Programs

### Objective
Become fluent with basic RISC-V assembly instructions and understand **register-level effects**.

---

### Task 1A: Register–Register Arithmetic

**Write an assembly program that:**

- Loads two constants into registers
- Performs:
  - addition  
     ```
    ADDI x5, x0, 10
    ADDI x7, x0, 20
    ADD x7, x7, x5
     ```
  - bitwise AND  
     ```
    ADDI x5, x0, 7
    ADDI x7, x0, 15
    AND x7, x7, x5
     ```

**Constraints**
- Use only: `addi`, `add`, `and`
- Use registers: `x5`, `x6`, `x7` and `x0` only

**Report** (fill the table below)  
1. Execute the assembly program in the tool linked above.
2. After execution, fill the following table:

| Instruction | Destination Register | Value Written |
|------------|-----------------------|---------------|
| add        |           x7          |     0x16      |
| and        |           x7          |     0x7       |

---

### Task 1B: Immediate Arithmetic

**Write an assembly program that:**

- Initializes a register with a constant
- Modifies it using **at least three immediate type arithmetic instructions**
- Includes **at least one negative immediate**
   ```
    LI x5, 1394
    ORI x5, x5, 10
    ADDI x5, x5, -210
    ANDI x5, x5, 1096
   ```


**Report**
- Initial register value (init row below)
- Register value after each instruction
- Explanation of how **sign extension** affects execution

| Step | Instruction | Immediate (decimal) | Immediate (binary)         | Register Value After Execution (decimal) |
|------|-------------|---------------------|----------------------------|------------------------------------------|
| Init |    LI       |        1394         |       0000010101110010     |             1394                         |
| 1    |    ORI      |         10          |       0000000000001010     |             1402                         |
| 2    |    ADDI     |        -210         |       1111111100101110     |             1192                         |
| 3    |    ANDI     |        1096         |       0000010001001000     |             1032                         |




---

## Task 2: Control Flow – Branches, Loops, and Jumps

### Objective
Understand **PC-relative control flow**.

---

### Program Specification

Write a program that:

- Initializes a counter to **10**
- Decrements it inside a loop
- Exits when the counter reaches zero
- Stores the **number of loop iterations executed** in a register

**Must use**
- `beq` or `bne`
- At least one `jal`

---
```
LI x6, 10
LI x7, 0

LOOP:
    BEQ  x6, x0, DONE
    ADDI x6, x6, -1
    ADDI x7, x7, 1
    JAL  x0, LOOP

DONE:
```

### Report

For **one conditional branch** and **one jump**, fill the table __*before stepping*__:

| Instruction | PC (hex) | Offset / Immediate    | Predicted Next PC | Actual Next PC |
|-------------|----------|-----------|-------------------|----------------|
|   BEQ       | 0x8      |    0x18   |   0xC             |   0xC          |
|   ADDI      | 0xC      |     -1      |   0x10            |   0x10          |
|   ADDI      | 0x10     |     1     |   0x14            |   0x14          |
|   JAL       | 0x14     |     0x8      |   0x18            |   0x4          |

---

## Task 3: Manual Instruction Encoding

### Objective
Understand how assembly instructions map to **32-bit machine code**.

---

### Instructions to Encode

Manually encode the following instructions:

1. `add x7, x5, x6`
2. `addi x6, x6, -4`
3. `beq x5, x0, label`
4. `jal x1, label`

For **each instruction**, fill the table below:

| Field |  Value | | | |
|------|-------|------|-------|------|
| Instruction | add | addi | beq | jal |
| Instruction format (R/I/B/J) | R|I| B|J |
| Opcode |0b0110011 | 0b0010011| 0b1100011| 0b1101111|
| rs1 | 0b00101| 0b00110| 0b00101 | N/A|
| rs2 | 0b00110| N/A| 0b00000| N/A|
| rd | 0b00111| 0b00110| N/A| 0b00001|
| Immediate (binary, sign-extended) | N/A | 0b111111111100 | 0b111111111100|0b11111111111111111010   |
| Final 32-bit encoding (hex) | 0x006283b3|0xffc30313 | 0xfe028ce3| 0xff5ff0ef|

Verify each encoding using the simulator assembler.

---

## Task 4: Manual Instruction Decoding (Prediction Task)

### Objective
Practice **decode as hardware would do**, without executing first.

---

### Given Machine Code Sequence

```
0x00500293
0x00100313
0x00628463
0xFFF30313
0xFE000AE3
0x0000006F
```

---

### Task 4A: Decode Table

Fill the following table as if you were the processor, and you are working through the instructions one line at a time. Assume you start with PC = 0 on the first line.

| PC | Instruction (hex) | Type | rs1 | rs2 | rd | Immediate | Meaning | Assembly |
|----|------------------|------|-----|-----|----|-----------|---------|----------|
| 0x0 | 0x00500293 | I | x0 | N/A | x5 | 5 | Load 5 into x5 | `addi x5, x0, 5` |
| 0x4 | 0x00100313 | I | x0 | N/A | x6 | 1 | Load 1 into x6 | `addi x6, x0, 1` |
| 0x8 | 0x00628463 | B | x5 | x6 | N/A | 8 | Branch to PC+8 if x5==x6 | `beq x5, x6, 8` |
| 0xC | 0xFFF30313 | I | x6 | N/A | x6 | -1 | Decrement x6 by 1 | `addi x6, x6, -1` |
| 0x10 | 0xFE000AE3 | B | x0 | x0 | N/A | -12 | Branch to PC-12 if x0==x0 | `beq x0, x0, -12` |
| 0x14 | 0x0000006F | J | N/A | N/A | x0 | 0 | Jump to PC+0 (halt loop) | `jal x0, 0` |





Include:
- sign-extended immediates
- PC-relative offsets in **bytes**

---

### Task 4B: Register & PC Prediction

Assume initial state:

```
x5 = 0
x6 = 0
x7 = 0
```

Fill **predicted values**:

| PC | x5 | x6 | x7 | Next PC |
|----|----|----|----|---------|
|  0 |  0  |  0  | 0   |  4   <br>|
|  4 |  5  |  0  | 0   |  8   <br>|
|  8  |  5  |  1  |   0 |  C   <br>|
|  C  |  5  |  1  |   0 |  10   <br>|
|  10  |  5  |  0  |   0 |  4   <br>|
|  4  |  5  |  0  |   0 |  8   <br>|
|  8  |  5  |  1  |   0 |  C   <br>|

---

## 8. Task 5: Decode Verification via Execution

### Objective
Verify decode reasoning using actual execution.

---

### Steps

1. Load the same assembly code you obtained above into the simulator
2. Step instruction-by-instruction
3. Observe and verify with your prediction above:
   - PC updates
   - Register writes

---

### Report

For **each mismatch** between prediction and observation:
- identify the incorrect assumption
- explain the architectural reason
in the space below
```
The assembly program given will never reach the final halt, as the loop given by BEQ x0, x0, -12 forces the program to repeat forever, changing x6 from 1 to 0 and back.

There is no architectural reason for any mismatch, there is no mismatch. The flaw stems from the code itself.

```

---

## 9. Take-Home (Evaluative): Reverse Engineering with Errors

### Given Machine Code Program

```
0x00000293
0x00100313
0x00600393
0x00038A63
0x00628433
0x00030393
0x00040393
0xFFE38393
0x00C0006F
0x0000006F
0x00000393
```

The program contains **exactly three errors**:

1. Immediate encoding error
2. Jump address related error
3. Semantic (algorithmic) register-update error

---

### Student Tasks

1. Decode the program into assembly
   ```
   ADDI x5, x0, 0      
   ADDI x6, x0, 1      
   ADDI x7, x0, 6      
   BEQ  x7, x0, 20 
   ADD  x8, x5, x6    
   ADDI x7, x6, 0      
   ADDI x7, x8, 0     
   ADDI x7, x7, -2     
   JAL  x0, 12         
   JAL  x0, 0          
   ADDI x7, x0, 0     
   ```
2. Explain the **intended algorithm** (what does it do?)
   ```
   It looks like this algorithm is supposed to compute the fibonnaci number, up to the 6th fibonacci.
   ```
3. Identify and explain **each error**
   ```
   - Error 1: The ADDI x7, x7, -2 should be -1 instead of -2 to correctly execute the program.
   - Error 2: JAL x0, 12 should be JAL x0, -20 to jump back to the BEQ instruction to check for completion.
   - Error 3: ADDI x7, x6 and ADDI x7, x8 are both incorrect. They should be doing x5 =  x6 and x6 = x8 in order to propelry work.
   ```
4. Correct the machine code  
   Create a new file, `artefacts/lab03/assembly.asm` and add the final correct code there.
5. Verify corrected behavior in the simulator
6. Did you notice anything strange? How does the CPU know when to stop executing instructions / when the program has ended?
```
The CPU knew when to stop executing when it entered the infinite loop of adding 0 to x7 repeatedly.
```
_Hint: you can examine the behavior of the machine code by copying it into the text memory in the simulator and stepping through. I am not sure if that will work, but you can try._

---

## 11. Learning Outcomes

After Lab 3, you should be able to:

- Write and read non-trivial RISC-V assembly
- Encode and decode instructions manually
- Reason about PC-relative control flow
- Relate ISA semantics to datapath behavior

---

**End of Lab 3 Manual**



## Important Note on Halt

The base RISC-V ISA does **not** include a HALT instruction.

In this lab, a **self-looping jump** is used to represent a halted processor:

```asm
end:
  jal x0, end
```

This is a standard bare-metal technique and should be treated as an explicit halt.

---