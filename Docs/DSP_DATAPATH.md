# Structural Instantiation & Internal Datapath Architecture (`DSP_DATAPATH.md`)

This module documents the precise RTL signal routing, sub-block registers, and arithmetic expressions implemented in `DSP48A1.v`[cite: 2].

---

### Internal Register Instantiations

The datapath incorporates parameterized `register` instances configured by generic pipeline depth flags (`XREG`) and reset schemes (`RSTTYPE`)[cite: 2]:

* **Control & Status Buffers:**
  * `OPMODE_reg_inst`: Captures 8-bit `OPMODE` input bus driven by `CEOPMODE` and `RSTOPMODE`[cite: 2].
  * `CARRYIN_reg_inst`: Buffers the selected carry-in bit (`CYI`)[cite: 2].
  * `CARRYOUT_reg_inst`: Buffers the overflow/carry-out bit `P_alu[48]`[cite: 2].

* **Data Path Buffers:**
  * `B0_reg_inst` & `B1_reg_inst`: Dual pipeline stages for the $B$ operand path[cite: 2].
  * `A0_reg_inst` & `A1_reg_inst`: Sequential dual pipeline stages for the $A$ operand path[cite: 2].
  * `D_reg_inst`: Registers the 18-bit pre-adder operand input $D$[cite: 2].
  * `C_reg_inst`: Registers the 48-bit post-adder input $C$[cite: 2].
  * `M_reg_inst`: Pipeline stage capturing the 36-bit multiplier result `M_pre`[cite: 2].
  * `P_reg_inst`: Accumulator register driving output ports `P` and `PCOUT`[cite: 2].

---

### Data Input & Multiplexing Selection Logic

* **$B$ Input Source Selection (`B_INPUT` Parameter):**
  $$\text{B0\_pre} = \begin{cases} \text{B}, & \text{if } \text{B\_INPUT} = \text{"DIRECT"} \\ \text{BCIN}, & \text{if } \text{B\_INPUT} = \text{"CASCADE"} \\ 0, & \text{otherwise} \end{cases}$$[cite: 2]

* **Carry-In Multiplexing Selection (`CARRYINSEL` Parameter):**
  $$\text{CYI} = \begin{cases} \text{OPMODE\_reg}[5], & \text{if } \text{CARRYINSEL} = \text{"OPMODE5"} \\ \text{CARRYIN}, & \text{if } \text{CARRYINSEL} = \text{"CARRYIN"} \\ 0, & \text{otherwise} \end{cases}$$[cite: 2]

* **$X$ Multiplexer Decoding (`OPMODE_reg[1:0]`):**
  * `2'b00`: $X_{\text{out}} = 48'b0$[cite: 2]
  * `2'b01`: $X_{\text{out}} = \text{M\_reg}$[cite: 2]
  * `2'b10`: $X_{\text{out}} = \text{PCOUT}$[cite: 2]
  * `2'b11`: $X_{\text{out}} = \{\text{D\_reg}[11:0], \text{A1\_reg}[17:0], \text{B1\_reg}[17:0]\}$[cite: 2]

* **$Z$ Multiplexer Decoding (`OPMODE_reg[3:2]`):**
  * `2'b00`: $Z_{\text{out}} = 48'b0$[cite: 2]
  * `2'b01`: $Z_{\text{out}} = \text{PCIN}$[cite: 2]
  * `2'b10`: $Z_{\text{out}} = \text{PCOUT}$[cite: 2]
  * `2'b11`: $Z_{\text{out}} = \text{C\_reg}$[cite: 2]

---

### Functional Datapath Calculations

* **Pre-Adder / Subtractor Stage:**
  $$\text{pre\_out} = \begin{cases} \text{D\_reg} - \text{B0\_reg}, & \text{if } \text{OPMODE\_reg}[6] = 1 \\ \text{B0\_reg} + \text{D\_reg}, & \text{if } \text{OPMODE\_reg}[6] = 0 \end{cases}$$[cite: 2]
  $$\text{B1\_pre} = \begin{cases} \text{pre\_out}, & \text{if } \text{OPMODE\_reg}[4] = 1 \\ \text{B0\_reg}, & \text{if } \text{OPMODE\_reg}[4] = 0 \end{cases}$$[cite: 2]

* **Multiplier Stage:**
  $$\text{M\_pre} = \text{A1\_reg} \times \text{B1\_reg}$$[cite: 2]

* **Post-Adder / Subtractor Stage:**
  $$\text{P\_alu}[48:0] = \begin{cases} Z_{\text{out}} - (X_{\text{out}} + \text{CIN}), & \text{if } \text{OPMODE\_reg}[7] = 1 \\ X_{\text{out}} + Z_{\text{out}} + \text{CIN}, & \text{if } \text{OPMODE\_reg}[7] = 0 \end{cases}$$[cite: 2]
  $$\text{P\_pre} = \text{P\_alu}[47:0]$$[cite: 2]
