# Pipelining Submodule (`register.v`)

A parameter-driven building block used throughout the DSP slice to inject delay stages or pass data combinationally.

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `WIDTH` | Integer | `18` | Data bus bit-width |
| `XREG` | Integer | `1` | `1` enables internal flip-flops; `0` bypasses combinationally |
| `RSTTYPE` | String | `"SYNC"` | Selects `"SYNC"` or `"ASYNC"` reset behavior |

#### Port Interface
* `clk`: System clock.
* `RSTX`: Active-high reset signal.
* `CEX`: Active-high clock enable.
* `X` / `XOUT`: Data input and output buses [`WIDTH-1:0`].
