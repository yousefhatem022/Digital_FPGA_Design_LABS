module top_module (
    input wire        clk,
    input wire        rst_n,
    input wire        level,

    output wire [6:0] R,
    output wire [6:0] R_C,
    output wire [6:0] F,
    output wire [6:0] F_C,
    output wire [6:0] t,
    output wire [6:0] t_C
);

    //========================================
    // 50 MHz -> 100 Hz Clock Divider
    //========================================

    wire clk_100Hz;

    clk_divider CLK_DIV (
        .clk     (clk),
        .rst_n   (rst_n),
        .clk_out (clk_100Hz)
    );


    //========================================
    // Moore Rising/Falling Edge Detector
    //========================================

    wire Rising_tick;
    wire Falling_tick;
    wire Edge_tick;

    Rising_Falling_Edge_moore DETECTOR (
        .clk          (clk_100Hz),
        .rst_n        (rst_n),
        .level        (level),

        .Rising_tick  (Rising_tick),
        .Falling_tick (Falling_tick),
        .Edge_tick    (Edge_tick)
    );


    //========================================
    // Edge Counter
    //========================================

    wire [3:0] Rising_Count;
    wire [3:0] Falling_Count;
    wire [3:0] Edge_Count;

    Rising_Falling_Edge_Counter COUNTER (
        .clk           (clk_100Hz),
        .rst_n         (rst_n),

        .R_tick        (Rising_tick),
        .F_tick        (Falling_tick),
        .E_tick        (Edge_tick),

        .Rising_Count  (Rising_Count),
        .Falling_Count (Falling_Count),
        .Edge_Count    (Edge_Count)
    );


    //========================================
    // Six 7-Segment Decoder
    //========================================

    six_7seg_decoder SEVEN_SEG (
        .rst_n   (rst_n),

        .R_count (Rising_Count),
        .F_count (Falling_Count),
        .T_count (Edge_Count),

        .R       (R),
        .R_C     (R_C),
        .F       (F),
        .F_C     (F_C),
        .t       (t),
        .t_C     (t_C)
    );

endmodule