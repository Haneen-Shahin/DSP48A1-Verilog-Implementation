# Core Architecture (`DSP48A1.v`)

The `DSP48A1` top module implements the Spartan-6 DSP slice architecture, integrating pipelined arithmetic blocks, flexible multiplexing, and cascading capabilities[cite: 1, 2].

---

### Functional Arithmetic Blocks

* **Pre-Adder / Subtractor Stage:**
  * Enabled/bypassed via `OPMODE[4]`[cite: 1, 2].
  * Addition or subtraction selected via `OPMODE[6]` (`0`: `D + B`, `1`: `D - B`)[cite: 1, 2].

* **18x18 Multiplier Block:**
  * Computes the 36-bit product `A × B` or `A × (D ± B)` using signed operands[cite: 1, 2].

* **48-bit Post-Adder / ALU Stage:**
  * Dynamically controlled via `OPMODE[7]`[cite: 1, 2].
  * Addition mode (`OPMODE[7] == 0`): `Z_out + X_out + CIN`[cite: 1, 2].
  * Subtraction mode (`OPMODE[7] == 1`): `Z_out - (X_out + CIN)`[cite: 1, 2].

---

### Multiplexer Decoding Reference

* **X Multiplexer Select (`OPMODE[1:0]`):**
  * `2'b00` : `48'b0`[cite: 1, 2]
  * `2'b01` : `{12'b0, M_reg[35:0]}` (Multiplier output stage)[cite: 1, 2]
  * `2'b10` : `PCOUT` (Accumulator output feedback)[cite: 1, 2]
  * `2'b11` : `{D_reg[11:0], A1_reg[17:0], B1_reg[17:0]}` (Concatenated input data)[cite: 1, 2]

* **Z Multiplexer Select (`OPMODE[3:2]`):**
  * `2'b00` : `48'b0`[cite: 1, 2]
  * `2'b01` : `PCIN` (Cascade input from adjacent DSP slice)[cite: 1, 2]
  * `2'b10` : `PCOUT` (Accumulator feedback)[cite: 1, 2]
  * `2'b11` : `C_reg` (Direct 48-bit C input port)[cite: 1, 2]

* **Carry-In Logic (`CARRYINSEL` Parameter):**
  * `"OPMODE5"` : Uses bit 5 of the registered control word (`OPMODE_reg[5]`)[cite: 1, 2].
  * `"CARRYIN"` : Uses direct external signal `CARRYIN`[cite: 1, 2].

---

### Module Generic Parameters

| Parameter | Default | Valid Options | Description |
| :--- | :--- | :--- | :--- |
| `A0REG` | `0` | `0`, `1` | First pipeline stage for input `A`[cite: 1, 2] |
| `A1REG` | `1` | `0`, `1` | Second pipeline stage for input `A`[cite: 1, 2] |
| `B0REG` | `0` | `0`, `1` | First pipeline stage for input `B`[cite: 1, 2] |
| `B1REG` | `1` | `0`, `1` | Second pipeline stage for input `B`[cite: 1, 2] |
| `CREG` | `1` | `0`, `1` | Pipeline register for 48-bit input `C`[cite: 1, 2] |
| `DREG` | `1` | `0`, `1` | Pipeline register for pre-adder input `D`[cite: 1, 2] |
| `MREG` | `1` | `0`, `1` | Pipeline register after 18x18 multiplier[cite: 1, 2] |
| `PREG` | `1` | `0`, `1` | Output pipeline register for result `P`[cite: 1, 2] |
| `CARRYINREG` | `1` | `0`, `1` | Pipeline register for internal carry-in `CYI`[cite: 1, 2] |
| `CARRYOUTREG` | `1` | `0`, `1` | Pipeline register for post-adder carry-out[cite: 1, 2] |
| `OPMODEREG` | `1` | `0`, `1` | Pipeline register for 8-bit `OPMODE` signal[cite: 1, 2] |
| `CARRYINSEL` | `"OPMODE5"` | `"OPMODE5"`, `"CARRYIN"` | Controls source for carry-in multiplexer[cite: 1, 2] |
| `B_INPUT` | `"DIRECT"` | `"DIRECT"`, `"CASCADE"` | Controls input path for `B` operand[cite: 1, 2] |
| `RSTTYPE` | `"SYNC"` | `"SYNC"`, `"ASYNC"` | Reset implementation style across registers[cite: 1, 2] |
