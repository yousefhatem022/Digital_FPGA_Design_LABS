# Stream Even Parity Generator

A Verilog implementation of a serial 8-bit Even Parity Generator, verified through exhaustive simulation covering all 256 possible input patterns.

## 1. Overview

This project implements a **serial Even Parity Generator** that receives an 8-bit data word one bit at a time through a single-bit input, `serial_in`. Once all 8 bits have been received, the design computes the even parity of the word and asserts a `valid` pulse for one clock cycle to indicate that the result is ready.

The core logic is built around two dedicated Verilog functions — one for shifting in serial data and one for computing parity — combined with a shift register and a bit counter.

## 2. Objective

The objective of this design is to demonstrate a function-based, serial parity generation scheme in Verilog and to verify it with complete functional coverage. Specifically, the design aims to:

- Reconstruct an 8-bit word from a bit-serial input stream.
- Compute the even parity bit for that word using XOR reduction.
- Signal completion of each 8-bit reception with a single-cycle `valid` pulse.
- Be verified exhaustively across all 256 possible 8-bit input combinations rather than a limited set of test vectors.

## 3. System Architecture

The design receives serial data, accumulates it into an 8-bit register, and generates parity once a full byte has been collected:

```
serial_in
    |
    v
+-------------------+
|   8-bit Shift     |
|     Register      |
+---------+---------+
          |
          v
+-------------------+
|  parity_gen()     |
| Even Parity       |
+---------+---------+
          |
          +---------> parity_out
          |
          +---------> valid
```

An internal 3-bit counter (`bit_count`) tracks how many bits of the current byte have been received and determines when the 8th bit has arrived:

```
serial_in --> shift register --> 8 bits received
                                  |
                                  v
                              valid = 1
                                  |
                                  v
                            parity_out valid
```

Both the shift register and the bit counter are updated synchronously on `posedge clk`, with a synchronous active-high `reset` clearing `shift_reg`, `bit_count`, `parity_out`, and `valid`.

## 4. Serial Data Reception

Data arrives one bit per clock cycle on `serial_in`. On every clock edge (while not in reset), the incoming bit is shifted into an 8-bit register, `shift_reg`, and the 3-bit counter `bit_count` increments. Once `bit_count` reaches `3'd7` (i.e., the 8th bit is being received), the module:

1. Shifts in the final bit to complete the 8-bit word.
2. Computes the parity of that completed word.
3. Resets `bit_count` back to zero to begin receiving the next byte.
4. Asserts `valid` for that one clock cycle.

This allows the module to continuously process a stream of bytes without any external framing signal — it only needs a steady stream of bits on `serial_in`.

## 5. Function-Based Design

The RTL uses two Verilog `function` blocks to keep the shifting and parity logic self-contained and reusable within the sequential block.

**`shift_data()`** — shifts the current 8-bit register left and inserts the newly arrived serial bit into the LSB position, building up the word one bit at a time:

```verilog
function  [7:0] shift_data;
    input [7:0] data;
    input       serial_bit;

    begin
        shift_data = {data[6:0], serial_bit};
    end
endfunction
```

**`parity_gen()`** — computes the even parity of an 8-bit word using a single XOR reduction operator. The result is `0` when the word contains an even number of 1s, and `1` when it contains an odd number of 1s:

```verilog
function parity_gen;
    input [7:0] data;

    begin
        parity_gen = ^data;
    end
endfunction
```

Both functions are called directly inside the main sequential `always` block, keeping the shift-and-check logic for each incoming bit compact and readable.

## 6. Even Parity Generation

Parity is computed only once the full 8-bit word has been assembled — specifically at the moment the 8th bit is received:

```verilog
if (bit_count == 3'd7) begin
    shift_reg  <= shift_data(shift_reg, serial_in);
    parity_out <= parity_gen( shift_data(shift_reg, serial_in) );

    bit_count <= 3'b0;
    valid     <= 1'b1;
end
```

Note that `parity_gen()` is called on the freshly shifted-in 8-bit value (`shift_data(shift_reg, serial_in)`), so the parity reflects the complete word including the final bit, not the previous 7-bit partial value.

## 7. Valid Signal

`valid` is a registered, single-cycle pulse. It defaults to `1'b0` on every clock cycle and is only driven to `1'b1` in the clock cycle where the 8th bit of a word is received and `parity_out` is updated. This makes `valid` a reliable "result ready" strobe that downstream logic can use to sample `parity_out` at the correct moment, once per completed byte.

## 8. Verification Strategy

The design is verified using `Stream_Parity_Gen_TB.v`, a self-checking testbench built around reusable tasks:

- **`send_byte` task** — sends a given 8-bit value serially into the DUT, one bit per clock cycle, using a `for` loop over bit positions 7 down to 0. Each bit is applied on `@(negedge clk)` to avoid races with the DUT's sampling edge.
- **Testbench shift register (`tb_shift_reg`)** — as `send_byte` transmits each bit, it independently reconstructs the same 8-bit word inside the testbench, mirroring the DUT's shifting behavior. This reconstructed value is used as the reference for the expected result, independent of the DUT's internal state.
- **`test_all_bytes` task** — iterates `i` from 0 to 255 using a `for` loop, calling `send_byte(i)` for every possible 8-bit pattern, then computes the expected parity as `^tb_shift_reg` and compares it against the DUT's `parity_out`.
- **Self-checking verification** — every comparison is made automatically in the testbench: a mismatch is logged as `FAIL` with the test index, data pattern, expected parity, and actual parity; a match is logged as `PASS`. `pass_count` and `fail_count` tally the results, and a final summary block reports the totals and an overall `ALL TESTS PASSED!` / `SOME TESTS FAILED!` verdict.

## 9. Exhaustive 256-Pattern Verification

Because `serial_in` builds an 8-bit word, there are exactly **2⁸ = 256** distinct possible input combinations, ranging from `00000000` to `11111111`. The testbench's `test_all_bytes` task applies every single one of these 256 patterns to the DUT and checks the resulting parity against an independently reconstructed reference value.

Testing all 256 patterns provides **exhaustive functional coverage** of the design's entire input space — there is no possible 8-bit value that is left unverified. This is practical here specifically because the input space is small (256 combinations); for wider data words, exhaustive testing would need to be replaced with directed or randomized test strategies.

## 10. Simulation Results

The design was simulated in Questa/ModelSim, and the results are recorded in the `transcript` file:

| Metric | Result |
|--------|--------|
| Total Patterns | 256 |
| Passed | 256 |
| Failed | 0 |
| Final Status | ALL TESTS PASSED |

Corresponding summary output from the transcript:

```
==============================================
             TEST SUMMARY
==============================================
Total Tests : 256
Passed      : 256
Failed      :   0
==============================================
              ALL TESTS PASSED!
==============================================
```

Errors: 0
Warnings: 0

## 11. Waveform

The following waveforms were captured using the signal grouping defined in `wave.do` (clock/reset, `serial_in`, testbench shift register, `parity_out`, and `valid`).

**Full simulation waveform**, showing the complete run across multiple transmitted bytes:

![Full Waveform](Results/Full%20WaveForm.png)

**Case where parity is asserted** (`parity_out = 1`), corresponding to a received byte containing an odd number of 1s:

![Parity Detected](Results/Parity%20Detected.png)

**Case where parity is not asserted** (`parity_out = 0`), corresponding to a received byte containing an even number of 1s:

![No Parity Detected](Results/No%20Parity%20Detected.png)

## 12. Project Files

```
Parity_Gen/
├── Stream_Parity_Gen.v         # Main RTL module: shift register, bit counter, shift_data()/parity_gen() functions, valid generation
├── Stream_Parity_Gen_TB.v      # Self-checking testbench with send_byte/test_all_bytes tasks and exhaustive 256-pattern verification
├── Full WaveForm.png            # Complete simulation waveform across the test run
├── Parity Detected.png          # Waveform snapshot where parity_out is asserted (odd number of 1s)
├── No Parity Detected.png       # Waveform snapshot where parity_out is not asserted (even number of 1s)
├── transcript                   # Simulation log and verification summary output
└── wave.do                      # Questa waveform configuration (signal grouping, colors, and display settings)
```

## 13. Tools Used

- **Verilog (IEEE 1364)** for RTL design and testbench.
- **Questa Sim / ModelSim** for compilation, simulation, and waveform generation.

## 14. Conclusion

This project implements a compact, function-based serial Even Parity Generator that reconstructs an 8-bit word from a bit-serial stream and computes its even parity using XOR reduction. The design was verified with a self-checking testbench that exhaustively exercises all 256 possible 8-bit input patterns using reusable tasks and an independent testbench-side shift register for reference generation. The simulation results confirm 256 out of 256 tests passed with zero failures, giving complete functional coverage of the parity generator's input space. This project was verified through simulation only; no FPGA hardware testing was performed.
```
