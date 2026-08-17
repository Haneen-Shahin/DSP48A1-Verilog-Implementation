# Pipelining Submodule (`register.v`)

A parameter-driven building block used throughout the DSP slice to inject delay stages or pass data combinationally[cite: 1].

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `WIDTH` | Integer | `18` | Data bus bit-width[cite: 1] |
| `REG` | Integer | `1` | `1` enables internal flip-flops; `0` bypasses combinationally[cite: 1] |
| `RSTTYPE` | String | `"SYNC"` | Selects `"SYNC"` or `"ASYNC"` reset behavior[cite: 1] |

#### Port Interface
* `clk`: System clock[cite: 1].
* `RSTX`: Active-high reset signal[cite: 1].
* `CEX`: Active-high clock enable[cite: 1].
* `X` / `XOUT`: Data input and output buses [`WIDTH-1:0`][cite: 1].
