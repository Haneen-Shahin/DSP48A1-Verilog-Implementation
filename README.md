# DSP48A1-Verilog-Implementation  Digital IC Design & RTL Verification
Verilog HDL implementation and verification of the Xilinx Spartan-6 DSP48A1 slice, developed as part of Eng. Kareem Wasseem’s Digital IC Design Diploma

![Verilog](https://img.shields.io/badge/Language-Verilog-blue.svg)
![EDA Tools](https://img.shields.io/badge/EDA-QuestaSim%20%7C%20Vivado-red.svg)
![FPGA Target](https://img.shields.io/badge/Target-Xilinx%20Artix--7-orange.svg)

**Overview**  
This repository contains the complete Verilog HDL RTL design, behavioral simulation, and physical FPGA synthesis for the **Spartan-6 DSP48A1** slice. The DSP48A1 block provides high-speed arithmetic hardware optimized for MAC operations, symmetric FIR filtering, and multi-precision arithmetic algorithms.

---

**Key Architecture Features**

* **18-bit Pre-Adder / Subtractor:** Dynamically configured via `OPMODE[6]` and `OPMODE[4]` to compute $D \pm B$ prior to multiplication.
* **18x18 Signed Multiplier:** Generates a full 36-bit two's-complement product ($A \times B$ or $A \times (D \pm B)$).
* **48-bit Post-Adder / Subtractor / Accumulator:** Flexible ALU supporting operations of the form $Z \pm (X + \text{CIN})$ guided by dynamic multiplexer routing[cite: 1].
* **Parameterizable Pipeline Stages:** Independent pipeline registers ($A0, A1, B0, B1, C, D, M, P, \text{CYI}, \text{CYO}$) to optimize clock throughput[cite: 1, 2].
* **Selectable Reset Modes:** Parameterized support for both active-high synchronous (`SYNC`) and asynchronous (`ASYNC`) pipeline resets[cite: 1, 2].
* **Direct Chaining Routes:** Dedicated 18-bit (`BCIN`/`BCOUT`) and 48-bit (`PCIN`/`PCOUT`) cascade buses to chain adjacent DSP slices without global routing overhead[cite: 1].

---

**Parameter Configurations**

| Parameter | Default | Allowed Values | Description |
| :--- | :---: | :---: | :--- |
| `WIDTH_18` | `18` | Integer | Data bus width for ports A, B, D, BCIN, BCOUT |
| `WIDTH_48` | `48` | Integer | Data bus width for ports C, PCIN, PCOUT, P |
| `A0REG`, `A1REG` | `0`, `1` | `0`, `1` | Pipeline register configuration for input path A |
| `B0REG`, `B1REG` | `0`, `1` | `0`, `1` | Pipeline register configuration for input path B |
| `CREG`, `DREG` | `1` | `0`, `1` | Pipeline register selection for ports C and D |
| `MREG`, `PREG` | `1` | `0`, `1` | Pipeline register selection for Multiplier output and Accumulator |
| `CARRYINREG`, `CARRYOUTREG` | `1` | `0`, `1` | Pipeline stage selection for Carry Input / Output |
| `OPMODEREG` | `1` | `0`, `1` | Register selection for the dynamic OPMODE bus |
| `CARRYINSEL` | `"OPMODE5"` | `"OPMODE5"`, `"CARRYIN"` | Carry input multiplexer selection source |
| `B_INPUT` | `"DIRECT"` | `"DIRECT"`, `"CASCADE"` | Direct port `B` vs cascading `BCIN` input selection |
| `RSTTYPE` | `"SYNC"` | `"SYNC"`, `"ASYNC"` | Reset configuration mode across all internal registers |

---

**Dynamic Control Decoding (`OPMODE`)**

| OPMODE Bit field | Description & Mux Routing |
| :--- | :--- |
| `OPMODE[1:0]` | **X Multiplexer:** `00` (Zero), `01` (Multiplier Product $M$), `10` (Accumulator $P$), `11` (Concatenated $\{D[11:0], A[17:0], B[17:0]\}$) |
| `OPMODE[3:2]` | **Z Multiplexer:** `00` (Zero), `01` (Cascade Input `PCIN`), `10` (Accumulator $P$), `11` (Direct Port `C`) |
| `OPMODE[4]` | **Pre-Adder Bypass:** `0` (Bypass, pass $B$), `1` (Enable Pre-Adder output $D \pm B$) |
| `OPMODE[5]` | **Forced Carry-In:** Controls internal carry generation when `CARRYINSEL = "OPMODE5"` |
| `OPMODE[6]` | **Pre-Adder Arithmetic:** `0` (Addition: $D + B$), `1` (Subtraction: $D - B$) |
| `OPMODE[7]` | **Post-Adder Arithmetic:** `0` (Addition: $Z + X + \text{CIN}$), `1` (Subtraction: $Z - (X + \text{CIN})$) |

---

**Repository Directory Tree**

```text
├── Code/
│   ├── RTL/
│   │   ├── DSP48A1.v          # Top-level DSP slice design module
│   │   └── register.v         # Generic parameterizable register module
│   ├── Script/
│   │   └── run.do             # QuestaSim compile and wave simulation script
│   ├── Testbench/
│   │   └── DSP48A1_tb.v       # Verification testbench (Single initial block execution)
│   └── Constraints/
│       └── DSP48A1.xdc        # Vivado timing and physical placement constraints
├── Docs/
│   ├── architecture.md        # Detailed datapath and hardware pipeline specification
│   ├── DSP48A1.md             # Top-level port descriptions and register mapping
│   ├── register.md            # Generic register logic specification
│   └── verification.md        # Simulation plan, test cases, and synthesis results
├── Project_documentation_Report.pdf
├── .gitignore
└── README.md
