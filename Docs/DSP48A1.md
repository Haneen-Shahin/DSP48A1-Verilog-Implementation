# Core Architecture (`DSP48A1.v`)

The `DSP48A1` top module implements the Spartan-6 DSP slice architecture, integrating pipelined arithmetic blocks, flexible multiplexing, and cascading capabilities[cite: 1].

#### Arithmetic Pipeline
* **Pre-Adder / Subtractor:** Selected via `OPMODE[4]` and directionally controlled by `OPMODE[6]` (`0`: Add $D + B$, `1`: Subtract $D - B$)[cite: 1].
* **18x18 Multiplier:** Produces a 36-bit result $A \times B$ or $A \times (D \pm B)$[cite: 1].
* **48-bit Post-Adder / ALU:** Dynamically operated via `OPMODE[7]` (`0`: $Z + X + \text{CIN}$, `1`: $Z - (X + \text{CIN})$)[cite: 1].

#### Control & Multiplexing Decoding
* **X Multiplexer (`OPMODE[1:0]`):**
  * `00` : $0$
  * `01` : $12'b0, M[35:0]$ (Multiplier output)
  * `10` : $P$ (Accumulator feedback)
  * `11` : Concatenated input $D[11:0], A[17:0], B[17:0]$[cite: 1]
* **Z Multiplexer (`OPMODE[3:2]`):**
  * `00` : $0$
  * `01` : $\text{PCIN}$ (Cascade input)
  * `10` : $P$ (Feedback)
  * `11` : $C$ port input[cite: 1]
* **Carry-In Logic (`CARRYINSEL`):** Selects between `OPMODE[5]` and direct `CARRYIN`[cite: 1].

#### Generics & Synthesis Parameters
* **Pipeline Controls:** `A0REG`, `A1REG`, `B0REG`, `B1REG`, `CREG`, `DREG`, `MREG`, `PREG`, `CARRYINREG`, `CARRYOUTREG`, `OPMODEREG`[cite: 1].
* **Routing Styles:** `B_INPUT` (`"DIRECT"` or `"CASCADE"`), `RSTTYPE` (`"SYNC"` or `"ASYNC"`)[cite: 1].
