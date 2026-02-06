# CS F342 – Lab 1
## Verilog Modeling Styles and Hierarchical Design

---

## 1. Objective

The objective of **Lab 1** is to introduce you to **hands-on Verilog HDL design and simulation**, building on your background in digital logic design.

In this lab, you will:

- Implement the same hardware function using different Verilog modeling styles
- Understand the relationship between structural, dataflow, and behavioral (RTL) descriptions
- Learn how hierarchical designs are built using reusable modules
- Use a Codespaces-based workflow with VS Code
- Develop good verification discipline using testbenches

This lab forms the foundation for all subsequent labs in the course.

---

## 2. Background: Verilog Essentials (Recap)

This section briefly reviews the Verilog concepts required for this lab. You are expected to refer to lecture notes and the recommended textbook sections for deeper understanding.

### 2.1 Modules

A **module** is the basic building block in Verilog. It represents a hardware block with inputs and outputs.

Example:
```
module dut (
  input  wire a,
  input  wire b,
  input  wire cin,
  output wire sum,
  output wire cout
);
  // internal logic
endmodule
```

In this lab:
- Every design you write will be inside a module named `dut`
- The module interface represents the hardware pins of the circuit

Note: **DUT (Design Under Test)** refers to the hardware module being verified by the testbench. In this lab, your top-level module must be named `dut` so that the same testbench can be reused across different implementations (see the Testbench section below).

---

### 2.2 Ports, Nets, and Variables

- **Ports**: Inputs and outputs of a module
- **wire**: Used to model combinational connections
- **reg**: Used inside procedural blocks (`always`) to hold values

Rule of thumb:
- Use `wire` for continuous assignments
- Use `reg` for signals assigned inside `always` blocks

---

### 2.3 Modeling Styles in Verilog

Verilog supports multiple ways of describing the same hardware:

1. **Structural modeling**
   - Uses gate primitives and explicit wiring
   - Closest to schematic-level design

2. **Dataflow modeling**
   - Uses Boolean expressions and `assign` statements
   - More compact and readable

3. **Behavioral / RTL modeling**
   - Uses `always @(*)` blocks
   - Describes behavior rather than structure

In this lab, you will implement the *same circuit* using all three styles.

---

### 2.4 Testbenches

A **testbench** is a Verilog module used to:
- Apply inputs to the design under test (DUT)
- Observe outputs
- Check correctness

Key properties of testbenches:
- They have **no inputs or outputs**
- They instantiate the DUT
- They are used only for simulation, not synthesis

Example structure:
```
module tb;
  reg a, b, cin;
  wire sum, cout;

  dut uut (
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
  );

  initial begin
    // apply test vectors
  end
endmodule
```

---

### 2.5 Simulation and Waveforms

During simulation:
- Signal values over time can be dumped into a **VCD (Value Change Dump)** file (see the testbench, and Google 'verilog dumpvars' to learn more about the syntax).
- Waveforms can be viewed using **VaporView** inside VS Code.

Waveforms are used for **debugging and understanding behavior**.

---

## 3. Directory Structure (Lab 1)

```
labs/lab1/
├── task0/
│   └── dut.v
├── task1/
│   └── dut.v
├── task2/
│   └── dut.v
├── task3/
│   └── dut.v
├── task4/
│   └── dut.v
├── task5/
│   └── dut.v        (homework)
├── tb/
│   ├── tb_mux.v
│   ├── tb_fa.v
│   ├── tb_adder4.v
│   └── tb_adder4_sub.v
├── shared/
│   └── module.v
└── README.md
```

Additional folders:
- `shared/` – reusable modules (always included during compilation)
- `artefacts/` – simulation outputs (lab-wise)

---

## 4. Toolchain and Workflow

You will work entirely inside **GitHub Codespaces**.

Tools used (these are already set up in the codespace for you to use):
- Icarus Verilog – compilation and simulation
- VS Code Tasks – running compile and simulation commands
- VaporView – waveform viewing (debugging only)

No local installation is required.

---

## 5. Task 0 – Toolchain Familiarization (Warm-up)

**Objective:**  
Understand the build, simulation, and waveform-viewing workflow.

### Description
In this task, you will **not write any code**. Instead, you will:
- Compile and simulate a provided **2-to-1 multiplexer**
- Learn how to run VS Code tasks
- Learn how to open waveforms in VaporView

### Files
- Design:
  ```
  labs/lab1/task0/dut.v
  ```
- Testbench:
  ```
  labs/lab1/tb/tb_mux.v
  ```

### Steps
1. Run **Compile (lab + task + testbench)** with:
   - lab: `lab1`
   - task: `task0`
   - testbench: `tb_mux.v`  
   For this, press `ctrl + shift + b`, then enter the above in the prompts.  
   You should see `compiled to artifact ...` in the terminal at the bottom.  
   Resulting `.sim` file will be generated in the `artefacts` folder.
2. Run **Run (generate VCD)**  
   For this, press `ctrl + shift + p`, then type `test`, then select `Tasks: Run Test Task`.  
   Respond to the prompts.  
   Resulting `.vcd` file will be generated in `artefacts` folder.
3. Open the generated VCD file in VaporView (double-click).
4. Observe how input changes affect the output (you will have to `add signals from Netlist view`).

---

## 6. How to Compile and Simulate (General)

When running a simulation, you must specify:
1. Lab (e.g. lab01)
2. Task (e.g. task2)
3. Testbench (e.g. tb_fa.v)

Simulation outputs are generated in:
```
artefacts/lab1/
```

### Upon completion
Once you verify that the output is correct:
1. commit the changes (third button from top in the left sidebar)
2. Use the exact commit message: `lab01 task0`
3. Push the commit to GitHub (press the `sync` button)

---

## 7. Lab Tasks

Task 1 – Structural Modeling (Gate-Level)  
Objective:
Implement a 1-bit full adder using structural (gate-level) Verilog.

Requirements:
- Use gate primitives (and, or, xor, not)
- No assign statements
- No always blocks

File:
labs/lab01/task1/dut.v

Testbench:
tb_fa.v

Open this file and understand how the testbench works by reading through all the comments carefully. _Next lab onwards you will write your own test benches._

### Upon completion
Once you verify your solution and are ready to submit:
1. commit the changes (third button from top in the left sidebar)
2. Use the exact commit message: `lab01 task1`
3. Push the commit to GitHub

---

Task 2 – Dataflow Modeling  
Objective:
Implement the same full adder using dataflow modeling.

Requirements:
- Use continuous assignments (assign)
- Express logic as Boolean equations
- No gate primitives
- No always blocks

File:
labs/lab01/task2/dut.v

Testbench:
tb_fa.v

### Upon completion
Once you verify your solution and are ready to submit:
1. commit the changes (third button from top in the left sidebar)
2. Use the exact commit message: `lab01 task2`
3. Push the commit to GitHub

---

Task 3 – Behavioral / RTL Modeling  
Objective:
Implement the same full adder using behavioral modeling.

Requirements:
- Use always @(*)

File:
labs/lab01/task3/dut.v

Testbench:
tb_fa.v

### Upon completion
Once you verify your solution and are ready to submit:
1. commit the changes (third button from top in the left sidebar)
2. Use the exact commit message: `lab01 task3`
3. Push the commit to GitHub

---

Task 4 – Hierarchical Design (4-bit Adder)  
Objective:
Build a 4-bit ripple-carry adder using reusable 1-bit full adders.

Requirements:
- Use module instantiation
- You already built a full adder in task 3. Now copy the file into task 4 directory and rename it as `fa.v`.
- Also rename the module as `fa` instead of `dut`.
- Create another file inside task 4 folder named `dut.v`.
- In this file, instantiate the `fa` module and use it to build a 4-bit adder.

File:
labs/lab01/task4/dut.v
labs/lab01/task4/fa.v

Testbench:
tb_4bit.v

### Upon completion
Once you verify your solution and are ready to submit:
1. commit the changes (third button from top in the left sidebar)
2. Use the exact commit message: `lab01 task4`
3. Push the commit to GitHub

---

Task 5 – Practice at home: 4-bit Adder–Subtractor  
Objective:
Extend the 4-bit adder to support subtraction.

Requirements:
- sub = 0 → addition
- sub = 1 → subtraction
- Use two’s complement logic
- Reuse existing 4-bit adder module by copying over the files from task 4 folder.

File:
labs/lab01/task5/dut.v
labs/lab01/task5/fa.v
labs/lab01/task5/adder4bit.v

Testbench:
tb_4bit_addsub.v

### Upon completion
Once you verify your solution and are ready to submit:
1. commit the changes (third button from top in the left sidebar)
2. Use the exact commit message: `lab01 task5`
3. Push the commit to GitHub

---

## 8. Verification Expectations

Required:
- Clean compilation
- Correct simulation behavior
- All test cases pass

---

## 10. Learning Outcome

By completing Lab 1, you should be comfortable:
- Writing Verilog at multiple abstraction levels
- Simulating and verifying combinational logic
- Understanding testbenches and waveforms
- Working with a structured HDL workflow

---