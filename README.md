# ⚡ DSP48A1-Verilog-Implementation Digital IC design & Verification 🚀

![Verilog](https://img.shields.io/badge/Language-Verilog-green.svg)
![EDA Tools](https://img.shields.io/badge/EDA-QuestaSim%20%7C%20Vivado-blue.svg)
![FPGA Target](https://img.shields.io/badge/Target-Xilinx%20Artix--7-orange.svg)

---

## 📌 Overview
This repository contains a parameterized, cycle-accurate Verilog HDL implementation and verification environment for the **Spartan-6 DSP48A1** computational slice. The block is optimized for high-speed digital signal processing tasks, including finite impulse response (FIR) filtering, multiply-accumulate (MAC) operations, pre-add/subtract operations, and multi-precision arithmetic[cite: 1, 2].

---

## 🏗️ Architecture & Features

The DSP48A1 block architecture consists of four primary processing units and parameterizable pipeline stages:

- ➕ **18-bit Pre-Adder / Subtractor:** Dynamic pre-addition or pre-subtraction ($D \pm B$) controlled via `OPMODE[6]` and `OPMODE[4]` to optimize symmetric filter logic.
- ✖️ **18x18 Signed Multiplier:** Generates a 36-bit two's-complement product ($A \times B$ or $A \times (D \pm B)$)[cite: 1].
- 🧮 **48-bit Post-Adder / Subtractor / Accumulator:** Computes 48-bit wide arithmetic operations ($Z \pm (X + \text{CIN})$) routed dynamically by multiplexers $X$ and $Z$[cite: 1].
- ⏱️ **Pipeline Staging:** Parameterizable registers ($A0, A1, B0, B1, C, D, M, P, \text{CYI}, \text{CYO}, \text{OPMODE}$) to enable high operating frequencies[cite: 1, 2].
- 🔄 **Reset Configuration:** Fully configurable active-high synchronous (`SYNC`) or asynchronous (`ASYNC`) reset modes[cite: 1, 2].
- 🔗 **Dedicated Cascading Routes:** Integrated 18-bit (`BCIN`/`BCOUT`) and 48-bit (`PCIN`/`PCOUT`) paths for multi-slice DSP chaining without extra routing overhead[cite: 1].

---

## ⚙️ Parameters (Generics)

| Parameter | Default | Allowed Values | Description |
| :--- | :---: | :---: | :--- |
| `WIDTH_18` | `18` | Integer | Bit width of ports A, B, D, BCIN, BCOUT |
| `WIDTH_48` | `48` | Integer | Bit width of ports C, PCIN, PCOUT, P |
| `A0REG`, `A1REG` | `0`, `1` | `0`, `1` | Pipeline register configuration for input port A |
| `B0REG`, `B1REG` | `0`, `1` | `0`, `1` | Pipeline register configuration for input port B |
| `CREG`, `DREG` | `1` | `0`, `1` | Staging register enable for ports C and D |
| `MREG`, `PREG` | `1` | `0`, `1` | Pipeline register enable for Multiplier output and P Accumulator[cite: 2] |
| `CARRYINREG`, `CARRYOUTREG` | `1` | `0`, `1` | Pipeline register enable for Carry input and Carry output[cite: 2] |
| `OPMODEREG` | `1` | `0`, `1` | Pipeline register enable for OPMODE control vector[cite: 2] |
| `CARRYINSEL` | `"OPMODE5"` | `"OPMODE5"`, `"CARRYIN"` | Carry input multiplexer source selection[cite: 2] |
| `B_INPUT` | `"DIRECT"` | `"DIRECT"`, `"CASCADE"` | Input source for B (`B` vs `BCIN`)[cite: 2] |
| `RSTTYPE` | `"SYNC"` | `"SYNC"`, `"ASYNC"` | Reset operation mode (Synchronous vs Asynchronous)[cite: 2] |

---

## 🗂️ OPMODE Control Logic Reference

| Bits | Functionality |
| :--- | :--- |
| `OPMODE[1:0]` | **🔀 X Multiplexer Select:** `00` (Zero), `01` (Multiplier output $M$), `10` (Accumulator $P$), `11` (Concatenated $\{D[11:0], A[17:0], B[17:0]\}$)[cite: 2] |
| `OPMODE[3:2]` | **🔀 Z Multiplexer Select:** `00` (Zero), `01` (Cascade input `PCIN`), `10` (Accumulator $P$), `11` (Direct input `C`)[cite: 2] |
| `OPMODE[4]` | **↪️ Pre-Adder Bypass:** `0` (Bypass pre-adder, pass $B$), `1` (Pass pre-adder output $D \pm B$)[cite: 2] |
| `OPMODE[5]` | **➡️ Forced Carry-In:** Dynamic carry input source selection when `CARRYINSEL = "OPMODE5"`[cite: 2] |
| `OPMODE[6]` | **➕ Pre-Adder Operation:** `0` (Addition: $D + B$), `1` (Subtraction: $D - B$)[cite: 2] |
| `OPMODE[7]` | **➖ Post-Adder Operation:** `0` (Addition: $Z + X + \text{CIN}$), `1` (Subtraction: $Z - (X + \text{CIN})$)[cite: 2] |

---

## 📁 Repository Structure

```text
├── 📦 Code/
│   ├── 🛠️ RTL/
│   │   ├── 📄 DSP.v               # Top-level DSP48A1 slice wrapper module[cite: 2]
│   │   └── 📄 DSP_REG.v           # Configurable pipeline register module[cite: 2]
│   ├── 📜 Script/
│   │   └── 📄 run.do              # QuestaSim simulation script[cite: 2]
│   ├── 🧪 Testbench/
│   │   └── 📄 DSP_tb.v            # Self-checking verification testbench[cite: 2]
│   └── 🗺️ constraints/
│       └── 📄 DSP.xdc             # Vivado timing and design constraints[cite: 2]
├── 📚 Docs/
│   ├── 📑 DSP.md                  # Specification for top-level DSP module ports & parameters[cite: 2]
│   ├── 📑 DSP_REG.md              # Specification for parameterizable register module[cite: 2]
│   ├── 📑 architecture.md         # Architectural breakdown and datapath mapping[cite: 2]
│   └── 📑 verification.md         # Verification plan, test coverage & synthesis results[cite: 2]
├── 📕 Project_documentation_Report.pdf[cite: 1, 2]
├── 🙈 .gitignore[cite: 2]
└── 📄 README.md[cite: 2]
---

## 🧪 Simulation & Verification

The design was verified using a self-checking testbench on **Mentor Graphics QuestaSim** covering corner cases, arithmetic operations, pipelined timing, and resets.

### 💻 Running Simulation via QuestaSim:

```bash
vsim -do Code/Script/run.do

## 🛠️ Synthesis & Implementation Results

- ⚙️ **Tool:** AMD Xilinx Vivado Design Suite
- 🎯 **Target Device:** xc7a200tffg1156-3 / xc7a35tcpg236-1
- ⏱️ **Clock Frequency:** 100 MHz (T = 10.0 ns)
- ✅ **Timing Slack:** Setup & Hold slack met with 0 failing endpoints
- 🔍 **DRC / Linting:** Passed with 0 Critical Warnings and 0 Errors

---

## 👩‍💻 Author

**Haneen Fady Shahin**  

> 🤝 **Note:** Feel free to use, modify, or integrate any part of this design and documentation for your own research, study, or projects!
