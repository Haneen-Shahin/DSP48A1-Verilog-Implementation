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
  $$B0\_pre = \begin{cases} B, & \text{if } B\_INPUT = \text{"DIRECT"} \\ BCIN, & \text{if } B\_INPUT = \text{"CASCADE"} \\ 0, & \text{otherwise} \end{cases}$$[cite: 2]

* **Carry-In Multiplexing Selection (`CARRYINSEL` Parameter):**
  $$CYI = \begin{cases} OPMODE\_reg[5], & \text{if } CARRYINSEL = \text{"OPMODE5"} \\ CARRYIN, & \text{if } CARRYINSEL = \text{"CARRYIN"} \\ 0, & \text{otherwise} \end{cases}$$[cite: 2]

* **$X$ Multiplexer Decoding (`OPMODE_reg[1:0]`):**
  * `2'b00`: $X_{out} = 48'b0$[cite: 2]
  * `2'b01`: $X_{out} = M\_reg$[cite: 2]
  * `2'b10`: $X_{out} = PCOUT$[cite: 2]
  * `2'b11`: $X_{out} = \{D\_reg[11:0], A1\_reg[17:0], B1\_reg[17:0]\}$[cite: 2]

* **$Z$ Multiplexer Decoding (`OPMODE_reg[3:2]`):**
  * `2'b00`: $Z_{out} = 48'b0$[cite: 2]
  * `2'b01`: $Z_{out} = PCIN$[cite: 2]
  * `2'b10`: $Z_{out} = PCOUT$[cite: 2]
  * `2'b11`: $Z_{out} = C\_reg$[cite: 2]

---

### Functional Datapath Calculations

* **Pre-Adder / Subtractor Stage:**
  $$pre\_out = \begin{cases} D\_reg - B0\_reg, & \text{if } OPMODE\_reg[6] = 1 \\ B0\_reg + D\_reg, & \text{if } OPMODE\_reg[6] = 0 \end{cases}$$[cite: 2]
  $$B1\_pre = \begin{cases} pre\_out, & \text{if } OPMODE\_reg[4] = 1 \\ B0\_reg, & \text{if } OPMODE\_reg[4] = 0 \end{cases}$$[cite: 2]

* **Multiplier Stage:**
  $$M\_pre = A1\_reg \times B1\_reg$$[cite: 2]

* **Post-Adder / Subtractor Stage:**
  $$P\_alu[48:0] = \begin{cases} Z_{out} - (X_{out} + CIN), & \text{if } OPMODE\_reg[7] = 1 \\ X_{out} + Z_{out} + CIN, & \text{if } OPMODE\_reg[7] = 0 \end{cases}$$[cite: 2]
  $$P\_pre = P\_alu[47:0]$$[cite: 2]
