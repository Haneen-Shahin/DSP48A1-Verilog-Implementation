# Core Architecture (`DSP48A1.v`)

The `DSP48A1` top module implements the Spartan-6 DSP slice architecture, integrating pipelined arithmetic blocks, flexible multiplexing, and cascading capabilities.

---

### Functional Arithmetic Blocks

* **Pre-Adder / Subtractor Stage:**
  * Enabled/bypassed via `OPMODE[4]`.
  * Addition or subtraction selected via `OPMODE[6]` (`0`: `D + B`, `1`: `D - B`).

* **18x18 Multiplier Block:**
  * Computes the 36-bit product `A × B` or `A × (D ± B)` using signed operands.

* **48-bit Post-Adder / ALU Stage:**
  * Dynamically controlled via `OPMODE[7]`.
  * Addition mode (`OPMODE[7] == 0`): `Z_out + X_out + CIN`.
  * Subtraction mode (`OPMODE[7] == 1`): `Z_out - (X_out + CIN)`.

---

### Multiplexer Decoding Reference

* **X Multiplexer Select (`OPMODE[1:0]`):**
  * `2'b00` : `48'b0`
  * `2'b01` : `{12'b0, M_reg[35:0]}` (Multiplier output stage)
  * `2'b10` : `PCOUT` (Accumulator output feedback)
  * `2'b11` : `{D_reg[11:0], A1_reg[17:0], B1_reg[17:0]}` (Concatenated input data)

* **Z Multiplexer Select (`OPMODE[3:2]`):**
  * `2'b00` : `48'b0`
  * `2'b01` : `PCIN` (Cascade input from adjacent DSP slice)
  * `2'b10` : `PCOUT` (Accumulator feedback)
  * `2'b11` : `C_reg` (Direct 48-bit C input port)

* **Carry-In Logic (`CARRYINSEL` Parameter):**
  * `"OPMODE5"` : Uses bit 5 of the registered control word (`OPMODE_reg[5]`).
  * `"CARRYIN"` : Uses direct external signal `CARRYIN`.

---

### Module Generic Parameters

| Parameter | Default | Valid Options | Description |
| :--- | :--- | :--- | :--- |
| `A0REG` | `0` | `0`, `1` | First pipeline stage for input `A`|
| `A1REG` | `1` | `0`, `1` | Second pipeline stage for input `A` |
| `B0REG` | `0` | `0`, `1` | First pipeline stage for input `B` |
| `B1REG` | `1` | `0`, `1` | Second pipeline stage for input `B` |
| `CREG` | `1` | `0`, `1` | Pipeline register for 48-bit input `C` |
| `DREG` | `1` | `0`, `1` | Pipeline register for pre-adder input `D` |
| `MREG` | `1` | `0`, `1` | Pipeline register after 18x18 multiplier |
| `PREG` | `1` | `0`, `1` | Output pipeline register for result `P` |
| `CARRYINREG` | `1` | `0`, `1` | Pipeline register for internal carry-in `CYI` |
| `CARRYOUTREG` | `1` | `0`, `1` | Pipeline register for post-adder carry-out |
| `OPMODEREG` | `1` | `0`, `1` | Pipeline register for 8-bit `OPMODE` signal |
| `CARRYINSEL` | `"OPMODE5"` | `"OPMODE5"`, `"CARRYIN"` | Controls source for carry-in multiplexer |
| `B_INPUT` | `"DIRECT"` | `"DIRECT"`, `"CASCADE"` | Controls input path for `B` operand |
| `RSTTYPE` | `"SYNC"` | `"SYNC"`, `"ASYNC"` | Reset implementation style across registers |
