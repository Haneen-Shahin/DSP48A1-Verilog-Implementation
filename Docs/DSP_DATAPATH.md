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
  * `B0_reg_inst` & `B1_reg_inst`: Dual pipeline stages for the `B` operand path[cite: 2].
  * `A0_reg_inst` & `A1_reg_inst`: Sequential dual pipeline stages for the `A` operand path[cite: 2].
  * `D_reg_inst`: Registers the 18-bit pre-adder operand input `D`[cite: 2].
  * `C_reg_inst`: Registers the 48-bit post-adder input `C`[cite: 2].
  * `M_reg_inst`: Pipeline stage capturing the 36-bit multiplier result `M_pre`[cite: 2].
  * `P_reg_inst`: Accumulator register driving output ports `P` and `PCOUT`[cite: 2].

---

### Data Input & Multiplexing Selection Logic

* **B Input Source Selection (`B_INPUT` Parameter):**
  * `B_INPUT == "DIRECT"`  ⇒ `B0_pre = B`[cite: 2]
  * `B_INPUT == "CASCADE"` ⇒ `B0_pre = BCIN`[cite: 2]
  * `Otherwise`            ⇒ `B0_pre = 18'b0`[cite: 2]

* **Carry-In Multiplexing Selection (`CARRYINSEL` Parameter):**
  * `CARRYINSEL == "OPMODE5"` ⇒ `CYI = OPMODE_reg[5]`[cite: 2]
  * `CARRYINSEL == "CARRYIN"` ⇒ `CYI = CARRYIN`[cite: 2]
  * `Otherwise`               ⇒ `CYI = 1'b0`[cite: 2]

* **X Multiplexer Decoding (`OPMODE_reg[1:0]`):**
  * `2'b00`: `X_out = 48'b0`[cite: 2]
  * `2'b01`: `X_out = M_reg`[cite: 2]
  * `2'b10`: `X_out = PCOUT`[cite: 2]
  * `2'b11`: `X_out = {D_reg[11:0], A1_reg[17:0], B1_reg[17:0]}`[cite: 2]

* **Z Multiplexer Decoding (`OPMODE_reg[3:2]`):**
  * `2'b00`: `Z_out = 48'b0`[cite: 2]
  * `2'b01`: `Z_out = PCIN`[cite: 2]
  * `2'b10`: `Z_out = PCOUT`[cite: 2]
  * `2'b11`: `Z_out = C_reg`[cite: 2]

---

### Functional Datapath Calculations

* **Pre-Adder / Subtractor Stage:**
  * `pre_out = (OPMODE_reg[6]) ? (D_reg - B0_reg) : (B0_reg + D_reg)`[cite: 2]
  * `B1_pre  = (OPMODE_reg[4]) ? pre_out : B0_reg`[cite: 2]

* **Multiplier Stage:**
  * `M_pre = A1_reg × B1_reg`[cite: 2]

* **Post-Adder / Subtractor Stage:**
  * `P_alu[48:0] = (OPMODE_reg[7]) ? (Z_out - (X_out + CIN)) : (X_out + Z_out + CIN)`[cite: 2]
  * `P_pre = P_alu[47:0]`[cite: 2]
