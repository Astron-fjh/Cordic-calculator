`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 小凋
// 
// Create Date: 2023/10/07 19:01:06
// Module Name: Cordic_top
// Project Name: Cordic_calculator
// Target Devices: Basys3
// Tool Versions: vivado 2018.3
//////////////////////////////////////////////////////////////////////////////////

module Cordic_top(
    input wire clk, reset,
    input wire sw0, sw1, sw2, sw3,
    input wire sw4, sw5, sw6, sw7,
    input wire select_sw1, select_sw2,
    input wire start_key,
    output wire [6:0] seg,
    output wire [3:0] ans,
    output wire [15:0] sin
    );

    wire [7:0] angle_bcd;
    wire [7:0] angle_bin;
    wire [31:0] sin_int;
    wire [31:0] cos_int;
    wire [53:0] sin_float;
    wire [53:0] cos_float;
    wire [11:0] sin_bcd;
    wire [11:0] cos_bcd;
    wire [11:0] display_bcd;
    wire bcd_finish;
    wire rstn;
    wire start;
    wire finish_cal;
    wire finish_int2float;

    assign rstn = ~reset;
    assign sin = sin_int[15:0];

    switch2bcd U1(
        .clk        (clk),
        .rstn       (rstn),
        .sw0        (sw0),
        .sw1        (sw1),
        .sw2        (sw2),
        .sw3        (sw3),
        .sw4        (sw4),
        .sw5        (sw5),
        .sw6        (sw6),
        .sw7        (sw7),
        .angle_bcd  (angle_bcd)
    );

    display U2(
        .clk            (clk),
        .rstn           (rstn),
        .display_bcd    (display_bcd),
        .seg            (seg),
        .ans            (ans)
    );

    bcd2bin U3(
        .angle_bcd  (angle_bcd),
        .angle_bin  (angle_bin)
    );

    key_scan U4(
        .clk        (clk),
        .rstn       (rstn),
        .start_key  (start_key),
        .start      (start)
    );

    cordic_sin_cos U5(
        .clk        (clk),
        .rstn       (rstn),
        .angle      (angle_bin),
        .start      (start),
        .sin        (sin_int),
        .cos        (cos_int),
        .finish     (finish_cal)
    );

    int2float U6(
        .clk        (clk),
        .rstn       (rstn),
        .start      (finish_cal),
        .sin_int    (sin_int),
        .cos_int    (cos_int),
        .sin        (sin_float),
        .cos        (cos_float),
        .finish     (finish_int2float)
    );

    bin2bcd_54bits U7(
        .clk        (clk),
        .rstn       (rstn),
        .sin_bin    (sin_float),
        .cos_bin    (cos_float),
        .start      (finish_int2float),
        .sin_bcd    (sin_bcd),
        .cos_bcd    (cos_bcd),
        .finish     (bcd_finish)
    );

    seg_select U8(
        .clk            (clk),
        .switch1        (select_sw1),
        .switch2        (select_sw2),
        .bcd_finish     (bcd_finish),
        .sin_bcd        (sin_bcd),
        .cos_bcd        (cos_bcd),
        .angle_bcd      (angle_bcd),
        .display_bcd    (display_bcd)
    );

endmodule
