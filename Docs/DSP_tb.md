# Verification Strategy (`DSP_tb.v`)

Overview of test scenarios, toolflow execution, and hardware implementation constraints

#### Simulation Environment
* **Tool:** QuestaSim.
* **Script:** `Code/Script/run.do`.
* **Test Coverage:** Direct arithmetic patterns, pipeline register latencies, reset conditions, and cascade propagation (`PCIN`/`PCOUT`, `BCIN`/`BCOUT`).

#### FPGA Synthesis Targets
* **Target Devices:** Xilinx Artix-7 (`xc7a200tffg1156-3`) / Basys3 (`xc7a35tcpg236-1`).
* **Constraints File:** `constraints/DSP.xdc` enforcing a 100 MHz target clock.
* **Synthesis Results:** Clean run with 0 Errors and 0 Critical Warnings.
