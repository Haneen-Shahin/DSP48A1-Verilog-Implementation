# Verification Strategy (`DSP_tb.v`)

Overview of test scenarios, toolflow execution, and hardware implementation constraints[cite: 1].

#### Simulation Environment
* **Tool:** QuestaSim[cite: 1].
* **Script:** `Code/Script/run.do`[cite: 1].
* **Test Coverage:** Direct arithmetic patterns, pipeline register latencies, reset conditions, and cascade propagation (`PCIN`/`PCOUT`, `BCIN`/`BCOUT`)[cite: 1].

#### FPGA Synthesis Targets
* **Target Devices:** Xilinx Artix-7 (`xc7a200tffg1156-3`) / Basys3 (`xc7a35tcpg236-1`)[cite: 1].
* **Constraints File:** `constraints/DSP.xdc` enforcing a 100 MHz target clock[cite: 1].
* **Synthesis Results:** Clean run with 0 Errors and 0 Critical Warnings[cite: 1].
