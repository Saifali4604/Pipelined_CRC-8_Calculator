# Pipelined CRC-8 Computation with Alternating Clock Edges

This Verilog module implements a pipelined CRC-8 computation using a 9-stage XOR division pipeline. It alternates between posedge and negedge clock triggering to improve data throughput while maintaining correctness. The CRC is computed using the polynomial  (0x07) and compared against an expected value (0x02) to determine if the data transmission is valid.

![image](https://github.com/Saifali4604/Pipelined_CRC-8_Calculator/blob/main/image.png)
---

## Key Features:

### Polynomial Used: POLY = 8'h07 (CRC-8 polynomial: ).

### Pipeline with Alternating Clocks:

Uses posedge and negedge clock edges for each XOR division step, reducing latency.


### Bitwise Processing:

9 pipeline stages, each performing one bitwise XOR shift.


### Control Signals:

#### 1. first: Marks the start of a new CRC calculation.

#### 2. last: Indicates the last byte in the sequence.

#### 3. valid: Ensures data is only processed when valid.


#### 4. Final CRC Check: Compares computed CRC with a predefined expected value (0x02).

### Output Flags:

#### done: CRC computation completed.

#### pass: Computed CRC matches the expected value.

#### fail: Computed CRC does not match the expected value.

---

## Pipeline Breakdown (Stage-by-Stage Processing)

### 1. Stage 1 (posedge clk):

Fetch the new 8-bit data and append 8 zero bits to initialize CRC computation.



### 2. Stages 2-9 (Alternating Clock Edges):

Each stage performs a 1-bit left shift and a polynomial XOR (if MSB is 1).

Odd stages use negedge clk, and even stages use posedge clk.



### 3. Stage 9 (Final Computation, posedge clk):

Extract the final 8-bit CRC value from reg_stage9[15:8].





---

## How It Works:

### 1. On first signal:

Initializes the CRC computation with the new 8-bit data.



### 2. On every valid signal:

The 9-stage pipeline processes the data sequentially, applying polynomial division.



### 3. When last is asserted:

The last data is processed, and the final CRC value is extracted.



### 4. The computed CRC is compared with expected = 8'h02:

If match → pass = 1, fail = 0.

If mismatch → pass = 0, fail = 1.

done is asserted to indicate completion.





---

## Optimizations & Notes:

Pipelining reduces latency by processing the CRC computation in stages.

Alternating posedge/negedge clock edges improve timing efficiency.

Uses shift registers for intermediate computations, ensuring high throughput.

This design is ideal for real-time embedded applications where CRC integrity checks are required for data transmission.

