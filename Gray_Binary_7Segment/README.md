# Gray Code to Binary to 7-Segment

## Overview

This project implements a complete digital design that converts a **4-bit Gray Code input** into its corresponding Binary value and then displays the result on a 7-Segment display.

The design consists of two main modules:

- **Gray-to-Binary Converter** – Converts the 4-bit Gray Code input into its equivalent Binary value.
- **Binary-to-7-Segment Decoder** – Converts the Binary value into the corresponding 7-Segment display pattern.

The complete conversion path is:

```text
4-bit Gray Code
      │
      ▼
Gray-to-Binary Converter
      │
      ▼
4-bit Binary
      │
      ▼
Binary-to-7-Segment Decoder
      │
      ▼
7-Segment Output
```

The testbench verifies all 16 possible 4-bit Gray Code input combinations.

---

## Design Architecture

The system is divided into two main stages.

```text
        Gray Input
         [3:0]
           │
           ▼
    ┌─────────────────┐
    │ Gray to Binary  │
    │    Converter    │
    └─────────────────┘
           │
           │ Binary [3:0]
           ▼
    ┌─────────────────┐
    │ Binary to       │
    │ 7-Segment       │
    │ Decoder         │
    └─────────────────┘
           │
           │ seg_out [6:0]
           ▼
      7-Segment
       Display
```

---

# 1. Gray-to-Binary Converter

## 1.1 Description

The Gray-to-Binary converter transforms a Gray Code input into its equivalent Binary representation.

The module is parameterized using `WIDTH`, allowing the same design to be used for different input widths.

The conversion is performed using XOR operations.

The MSB is directly copied:

```text
Binary[MSB] = Gray[MSB]
```

The remaining bits are calculated using:

```text
Binary[i] = Binary[i+1] XOR Gray[i]
```

## 1.2 Module

[`gray_to_binary.v`](gray_to_binary.v)

```verilog
module gray_to_binary #(
    parameter WIDTH = 4
)(
    input  wire [WIDTH-1:0] gray_in,
    output reg  [WIDTH-1:0] binary_out
);

    integer i;

    always @(*) begin
        //Binary MSB = Gray MSB
        binary_out[WIDTH-1] = gray_in[WIDTH-1];

        //Binary[i] = Binary[i+1] XOR Gray[i]
        for (i = WIDTH-2; i >= 0; i = i - 1) begin
            binary_out[i] = binary_out[i+1] ^ gray_in[i];
        end
    end

endmodule
```

---

# 2. Binary-to-7-Segment Decoder

## 2.1 Description

The Binary-to-7-Segment decoder converts the 4-bit Binary output into a 7-bit control signal for a 7-Segment display.

The seven output bits represent the seven display segments:

```text
abcdefg
```

The decoder supports hexadecimal values from:

```text
0 → 9
A → F
```

The output patterns are active-low.

## 2.2 Module

[`binary_to_7seg.v`](binary_to_7seg.v)

```verilog
module binary_to_7seg (
    input  wire [3:0] binary_in,
    output reg  [6:0] seg_out
);

    always @(*) begin
        case (binary_in)
            
            //7 segments pattern 
            //                 abcdefg                 
            4'h0: seg_out = 7'b0000001;
            4'h1: seg_out = 7'b1001111;
            4'h2: seg_out = 7'b0010010;
            4'h3: seg_out = 7'b0000110;
            4'h4: seg_out = 7'b1001100;
            4'h5: seg_out = 7'b0100100;
            4'h6: seg_out = 7'b0100000;
            4'h7: seg_out = 7'b0001111;
            4'h8: seg_out = 7'b0000000;
            4'h9: seg_out = 7'b0000100;

            4'hA: seg_out = 7'b0001000;
            4'hB: seg_out = 7'b1100000;
            4'hC: seg_out = 7'b0110001;
            4'hD: seg_out = 7'b1000010;
            4'hE: seg_out = 7'b0110000;
            4'hF: seg_out = 7'b0111000;

            default: seg_out = 7'b1111111;

        endcase
    end

endmodule
```

---

# 3. Testbench

## 3.1 Description

The testbench verifies the complete Gray Code to 7-Segment conversion path.

The testbench applies all possible 4-bit Gray Code values from `0000` to `1111`.

For each input, it displays:

- Gray Code input
- Binary output
- Hexadecimal value
- 7-Segment output pattern

The testbench checks a total of:

```text
2^4 = 16 test cases
```

## 3.2 Testbench Module

[`TestBench.v`](TestBench.v)

```verilog
module tb_Gray_to_7Segment;

    reg  [3:0] gray_in_tb;
    wire [3:0] binary_out_tb;
    wire [6:0] seg_out_tb;

    integer i;

    // Gray to Binary
    gray_to_binary #(
        .WIDTH(4)
    ) DUT_Gray (
        .gray_in(gray_in_tb),
        .binary_out(binary_out_tb)
    );

    // Binary to 7-Segment
    binary_to_7seg DUT_7Seg (
        .binary_in(binary_out_tb),
        .seg_out(seg_out_tb)
    );

    initial begin

        $display("==============================================================");
        $display("          Gray Code to Binary to 7-Segment Test               ");
        $display("==============================================================");
        $display(" Gray    Binary    Hexa    7-Segment");
        $display("--------------------------------------------------------------");

        // Test all 16 possible 4-bit Gray inputs
        for (i = 0; i < 16; i = i + 1) begin

            gray_in_tb = i;
            #10;

            $display(" %b     %b      %h       %b",
                     gray_in_tb, binary_out_tb, binary_out_tb, seg_out_tb);

        end

        $display("==============================================================");
        $display("              All Tests Completed");
        $display("==============================================================");

        $finish;
    end

endmodule
```

---

# 4. Simulation Results

The design was simulated using **Questa Sim 2024.1**.

All 16 possible 4-bit Gray Code inputs were tested.

| Gray | Binary | Hex | 7-Segment |
|------|--------|-----|-----------|
| 0000 | 0000 | 0 | 0000001 |
| 0001 | 0001 | 1 | 1001111 |
| 0010 | 0011 | 3 | 0000110 |
| 0011 | 0010 | 2 | 0010010 |
| 0100 | 0111 | 7 | 0001111 |
| 0101 | 0110 | 6 | 0100000 |
| 0110 | 0100 | 4 | 1001100 |
| 0111 | 0101 | 5 | 0100100 |
| 1000 | 1111 | F | 0111000 |
| 1001 | 1110 | E | 0110000 |
| 1010 | 1100 | C | 0110001 |
| 1011 | 1101 | D | 1000010 |
| 1100 | 1000 | 8 | 0000000 |
| 1101 | 1001 | 9 | 0000100 |
| 1110 | 1011 | B | 1100000 |
| 1111 | 1010 | A | 0001000 |

## Simulation Status

The simulation completed successfully with:

```text
Errors   : 0
Warnings : 0
```

The final testbench output was:

```text
==============================================================
          Gray Code to Binary to 7-Segment Test               
==============================================================
 Gray    Binary    Hexa    7-Segment
--------------------------------------------------------------
 0000     0000      0       0000001
 0001     0001      1       1001111
 0010     0011      3       0000110
 0011     0010      2       0010010
 0100     0111      7       0001111
 0101     0110      6       0100000
 0110     0100      4       1001100
 0111     0101      5       0100100
 1000     1111      f       0111000
 1001     1110      e       0110000
 1010     1100      c       0110001
 1011     1101      d       1000010
 1100     1000      8       0000000
 1101     1001      9       0000100
 1110     1011      b       1100000
 1111     1010      a       0001000
==============================================================
              All Tests Completed
==============================================================
```

The simulation finished at:

```text
Time: 160 ns
Errors: 0
Warnings: 0
```

---

# 5. Waveform

The waveform was generated using Questa Sim and contains the main testbench signals:

- `gray_in_tb`
- `binary_out_tb`
- `seg_out_tb`
- `i`

The waveform confirms the conversion from Gray Code to Binary and the corresponding 7-Segment output.

### Simulation Waveform

![Simulation Waveform](WaveForm.png)

---

# 6. Files

| File | Description |
|------|-------------|
| [`gray_to_binary.v`](gray_to_binary.v) | Parameterized Gray-to-Binary converter |
| [`binary_to_7seg.v`](binary_to_7seg.v) | Binary-to-7-Segment decoder |
| [`TestBench.v`](TestBench.v) | Verification testbench |
| [`transcript`](Results/transcript) | Questa simulation transcript |
| [`WaveForm.png`](Results/WaveForm.png) | Simulation waveform |

---

# 7. Tools Used

- **Verilog HDL**
- **Questa Sim 2024.1**
- **GitHub**

---

# Conclusion

The **Gray Code to Binary to 7-Segment** design was successfully implemented using Verilog HDL.

The design consists of a parameterized Gray-to-Binary converter followed by a Binary-to-7-Segment decoder.

The testbench verified all **16 possible 4-bit Gray Code inputs**, and the simulation results confirmed that the conversion stages produce the expected Binary and 7-Segment outputs.

The simulation completed successfully with:

```text
Errors   : 0
Warnings : 0
```

Overall, the simulation results confirm the correct operation of the complete:

```text
Gray Code → Binary → 7-Segment
```

conversion system.
