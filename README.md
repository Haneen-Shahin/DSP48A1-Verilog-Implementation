# ⚡ DSP48A1-Verilog-Implementation — Digital IC Design & Verification 🚀

![Verilog](https://img.shields.io/badge/Language-Verilog-green.svg)
![EDA Tools](https://img.shields.io/badge/EDA-QuestaSim%20%7C%20Vivado-blue.svg)
![FPGA Target](https://img.shields.io/badge/Target-Xilinx%20Artix--7-orange.svg)

---

## 📌 Overview

This repository contains a parameterized, cycle-accurate Verilog HDL implementation and verification environment for the **Xilinx Spartan-6 DSP48A1** computational slice.

The design supports high-speed digital signal processing operations including FIR filtering, multiply-accumulate (MAC) operations, pre-add/subtract operations, and multi-precision arithmetic.

---

## 🏗️ Architecture & Features

The DSP48A1 block consists of four primary processing units with configurable pipeline stages:

- ➕ **18-bit Pre-Adder / Subtractor:** Supports dynamic pre-addition and pre-subtraction operations.
- ✖️ **18×18 Signed Multiplier:** Generates a 36-bit two's-complement product.
- 🧮 **48-bit Post-Adder / Subtractor / Accumulator:** Performs 48-bit arithmetic operations using dynamically selected X and Z paths.
- ⏱️ **Configurable Pipeline Stages:** Supports parameterized registers for A, B, C, D, multiplier, accumulator, carry, and OPMODE paths.
- 🔄 **Reset Configuration:** Supports synchronous and asynchronous reset modes.
- 🔗 **Dedicated Cascade Paths:** Provides 18-bit BCIN/BCOUT and 48-bit PCIN/PCOUT cascade paths for multi-slice DSP architectures.

---

## ⚙️ Parameters

| Parameter | Default | Allowed Values | Description |
| :--- | :---: | :---: | :--- |
| `WIDTH_18` | `18` | Integer | Bit width of A, B, D, BCIN and BCOUT |
| `WIDTH_48` | `48` | Integer | Bit width of C, PCIN, PCOUT and P |
| `A0REG`, `A1REG` | `0`, `1` | `0`, `1` | Pipeline register configuration for A |
| `B0REG`, `B1REG` | `0`, `1` | `0`, `1` | Pipeline register configuration for B |
| `CREG`, `DREG` | `1` | `0`, `1` | Register enable for C and D |
| `MREG`, `PREG` | `1` | `0`, `1` | Multiplier and accumulator register enable |
| `CARRYINREG`, `CARRYOUTREG` | `1` | `0`, `1` | Carry input/output register enable |
| `OPMODEREG` | `1` | `0`, `1` | OPMODE register enable |
| `CARRYINSEL` | `"OPMODE5"` | `"OPMODE5"`, `"CARRYIN"` | Carry input source selection |
| `B_INPUT` | `"DIRECT"` | `"DIRECT"`, `"CASCADE"` | Selects B or BCIN as B source |
| `RSTTYPE` | `"SYNC"` | `"SYNC"`, `"ASYNC"` | Reset operation mode |

---

## 🗂️ OPMODE Control Logic Reference

| Bits | Functionality |
| :--- | :--- |
| `OPMODE[1:0]` | X multiplexer selection |
| `OPMODE[3:2]` | Z multiplexer selection |
| `OPMODE[4]` | Pre-adder bypass / enable |
| `OPMODE[5]` | Forced carry-in selection |
| `OPMODE[6]` | Pre-adder addition / subtraction |
| `OPMODE[7]` | Post-adder addition / subtraction |

---

## 📁 Repository Structure

```text
DSP48A1-Verilog-Implementation/
│
├── 📦 Code/
│   ├── 🛠️ RTL/
│   │   ├── 📄 DSP48A1.v
│   │   └── 📄 register.v
│   │
│   ├── 📜 Script/
│   │   └── 📄 run_DSP.do
│   │
│   ├── 🧪 Testbench/
│   │   └── 📄 DSP_tb.v
│   │
│   └── 🗺️ Constraints/
│       └── 📄 Constraints_DSP.xdc
│
├── 📚 Docs/
│   └── 📄 .gitkeep
│
├── 📕 Project_documentation_Report.pdf
├── 📄 LICENSE
├── 🙈 .gitignore
└── 📄 README.md
```
---

## 🧪 Simulation & Verification

The design was verified using a self-checking testbench in **QuestaSim**, covering arithmetic operations, corner cases, pipeline timing, and reset behavior.

---

### 💻 Running Simulation

Bash
```
vsim -do Code/Script/run_DSP.do
```
---
## 👩‍💻 Author

**Haneen Fady Shahin**  

> 🤝 **Note:** Feel free to use, modify, or integrate any part of this design and documentation for your own research, study, or projects!

