# DSP48A1-Verilog-Implementation
Verilog HDL implementation and verification of the Xilinx Spartan-6 DSP48A1 slice, developed as part of Eng. Kareem Wasseem’s Digital IC Design Diploma
# Spartan-6 DSP48A1 Digital IC Design & RTL Verification

![Verilog](https://img.shields.io/badge/Language-Verilog-blue.svg)
![EDA Tools](https://img.shields.io/badge/EDA-QuestaSim%20%7C%20Vivado-red.svg)
![FPGA Target](https://img.shields.io/badge/Target-Xilinx%20Artix--7-orange.svg)

**Overview**  
This repository contains the full Verilog HDL RTL implementation, testbench verification environment, and physical FPGA synthesis flow for the **Spartan-6 DSP48A1** slice. The core provides specialized computational hardware optimized for DSP operations, including symmetric FIR filtering, multiply-accumulate (MAC) routines, and wide multi-precision arithmetic.

---

**Key Features & Architecture**

* **18-bit Pre-Adder / Subtractor:** Controlled via `OPMODE[6]` and `OPMODE[4]` to compute $D \pm B$ pre-operations before multiplication.
* **18x18 Signed Multiplier:** Yields a full 36-bit two's-complement product ($A \times B$ or $A \times (D \pm B)$).
* **48-bit Post-Adder / Subtractor / Accumulator:** Computes dynamic wide operations ($Z \pm (X + \text{CIN})$) routed via flexible $X$ and $Z$ multiplexer paths.
* **Configurable Pipeline Registers:** Independent staging registers ($A0, A1, B0, B1, C, D, M, P, \text{CYI}, \text{CYO}, \text{OPMODE}$) inserted conditionally to maximize system operating frequency[cite: 1, 2].
* **Selectable Reset Modes:** Parameterized support for both active-high synchronous (`SYNC`) and asynchronous (`ASYNC`) resets across all internal registers[cite: 1, 2].
* **Direct Cascading Routes:** Integrated 18-bit (`BCIN`/`BCOUT`) and 48-bit (`PCIN`/`PCOUT`) paths for multi-slice DSP chaining without extra routing delay[cite: 1].

---

**Generics & Parameters**

| Parameter | Default | Allowed Values | Description |
| :--- | :---: | :---: | :--- |
| `WIDTH_18` | `18` | Integer | Bit width for ports A, B, D, BCIN, BCOUT |
| `WIDTH_48` | `48` | Integer | Bit width for ports C, PCIN, PCOUT, P |
| `A0REG`, `A1REG` | `0`, `1` | `0`, `1` | Pipeline register configuration for input path A |
| `B0REG`, `B1REG` | `0`, `1` | `0`, `1` | Pipeline register configuration for input path B |
| `CREG`, `DREG` | `1` | `0`, `1` | Staging registers for C and D ports |
| `MREG`, `PREG` | `1` | `0`, `1` | Staging registers for Multiplier output and Accumulator |
| `CARRYINREG`, `CARRYOUTREG` | `1` | `0`, `1` | Staging registers for Carry Input and Carry Output |
| `OPMODEREG` | `1` | `0`, `1` | Register selection for dynamic OPMODE control vector |
| `CARRYINSEL` | `"OPMODE5"` | `"OPMODE5"`, `"CARRYIN"` | Carry input multiplexer selection source |
| `B_INPUT` | `"DIRECT"` | `"DIRECT"`, `"CASCADE"` | Port `B` direct vs cascading `BCIN` selection |
| `RSTTYPE` | `"SYNC"` | `"SYNC"`, `"ASYNC"` | Global register reset mode |

---

**OPMODE Dynamic Control Decoding**

| Bit Field | Functionality |
| :--- | :--- |
| `OPMODE[1:0]` | **X Mux Select:** `00` (Zero), `01` (Multiplier Product $M$), `10` (Accumulator $P$), `11` (Concatenated $\{D[11:0], A[17:0], B[17:0]\}$) |
| `OPMODE[3:2]` | **Z Mux Select:** `00` (Zero), `01` (Cascade Input `PCIN`), `10` (Accumulator $P$), `11` (Direct Port `C`) |
| `OPMODE[4]` | **Pre-Adder Bypass:** `0` (Bypass pre-adder, pass $B$), `1` (Enable pre-adder output $D \pm B$) |
| `OPMODE[5]` | **Forced Carry-In:** Carried when `CARRYINSEL = "OPMODE5"` |
| `OPMODE[6]` | **Pre-Adder Operation:** `0` (Addition: $D + B$), `1` (Subtraction: $D - B$) |
| `OPMODE[7]` | **Post-Adder Operation:** `0` (Addition: $Z + X + \text{CIN}$), `1` (Subtraction: $Z - (X + \text{CIN})$) |

---

**Repository Directory Tree**

```text
├── Code/
│   ├── RTL/
│   │   ├── DSP48A1.v          # Top-level DSP slice design module
│   │   └── register.v         # Generic parameterizable register module
│   ├── Script/
│   │   └── run.do             # QuestaSim simulation execution script
│   ├── Testbench/
│   │   └── DSP48A1_tb.v       # Self-checking verification testbench
│   └── Constraints/
│       └── DSP48A1.xdc        # Vivado timing and design constraints
├── Docs/
│   ├── architecture.md        # Detailed datapath and hardware pipeline specification
│   ├── DSP48A1.md             # Top-level port descriptions and register mapping
│   ├── register.md            # Generic register logic specification
│   └── verification.md        # Simulation plan, test cases, and synthesis results
├── Project_documentation_Report.pdf
├── .gitignore
└── README.md

Simulation & VerificationFunctional simulation was verified using Mentor Graphics QuestaSim[cite: 1]. Test sequences are executed sequentially within a single initial block structure to verify cycle-accurate behavior, pipeline delays, reset logic, and edge conditions[cite: 1].Run simulation script:Bashvsim -do Code/Script/run.do
Synthesis & Hardware ResultsSynthesis Tool: AMD Xilinx Vivado Design Suite[cite: 1]Target Device: Artix-7 (xc7a35tcpg236-1 / xc7a200tffg1156-3)[cite: 1]Clock Constraints: $100\text{ MHz}$ ($T = 10.0\text{ ns}$)Timing Performance: Setup and hold slack margins met with zero failing endpoints.Linting / DRC: Passed clean with 0 Errors and 0 Critical Warnings.AuthorHaneen Fady ShahinDigital IC Design Engineer[cite: 1]Note: Feel free to use, modify, or adapt any part of this project and documentation for your own work or learning!
