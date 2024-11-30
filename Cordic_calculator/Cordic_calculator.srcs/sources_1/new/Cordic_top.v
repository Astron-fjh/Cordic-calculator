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
    input wire PS2C, PS2D,
    input wire select_sw1, select_sw2,
    input wire start_key,
    output wire [6:0] seg,
    output wire [3:0] ans,
    output wire [15:0] sin,
    
    output wire hsync, vsync,
    output wire [3:0] red, green, blue
    );

    wire [7:0] xkey;
    wire isDone;

    wire [11:0] angle_bcd;
    wire [11:0] angle_bin;
    wire [31:0] sin_int;
    wire [31:0] cos_int;
    wire [53:0] sin_float;
    wire [53:0] cos_float;
    wire [11:0] sin_bcd;
    wire [11:0] cos_bcd;
    wire [15:0] display_bcd;
    wire sin_sign;
    wire cos_sign;
    wire bcd_finish;
    wire rstn;
    wire start;
    wire finish_cal;
    wire finish_int2float;

    // vga
    wire clk_25M, vidon;
    wire [9:0] hc, vc;

    assign rstn = ~reset;
    assign sin = sin_int[15:0];

    
    clk_div U1(
        .clk_100M   (clk),
        .rstn       (rstn),
        .clk_25M    (clk_25M)
    );

    keyBoard U2(
        .clk        (clk),
        .rstn       (rstn),
        .PS2C       (PS2C),
        .PS2D       (PS2D),
        .isDone     (isDone),
        .xkey       (xkey)
    );

    keyBoard_state U3(
        .clk        (clk),
        .rstn       (rstn),
        .isDone     (isDone),
        .xkey       (xkey),
        .angle_bcd  (angle_bcd),
        .finish     (start)
    );

    display U4(
        .clk            (clk),
        .rstn           (rstn),
        .display_bcd    (display_bcd),
        .seg            (seg),
        .ans            (ans)
    );

    bcd2bin U5(
        .angle_bcd      (angle_bcd),
        .angle_bin      (angle_bin)
    );

    cordic_sin_cos U6(
        .clk        (clk),
        .rstn       (rstn),
        .angle      (angle_bin),
        .start      (start),
        .sin        (sin_int),
        .cos        (cos_int),
        .sin_sign   (sin_sign),
        .cos_sign   (cos_sign),
        .finish     (finish_cal)
    );

    int2float U7(
        .clk        (clk),
        .rstn       (rstn),
        .start      (finish_cal),
        .sin_int    (sin_int),
        .cos_int    (cos_int),
        .sin        (sin_float),
        .cos        (cos_float),
        .finish     (finish_int2float)
    );

    bin2bcd_54bits U8(
        .clk        (clk),
        .rstn       (rstn),
        .sin_bin    (sin_float),
        .cos_bin    (cos_float),
        .start      (finish_int2float),
        .sin_bcd    (sin_bcd),
        .cos_bcd    (cos_bcd),
        .finish     (bcd_finish)
    );

    seg_select U9(
        .clk            (clk),
        .switch1        (select_sw1),
        .switch2        (select_sw2),
        .bcd_finish     (bcd_finish),
        .sin_sign       (sin_sign),
        .cos_sign       (cos_sign),
        .sin_bcd        (sin_bcd),
        .cos_bcd        (cos_bcd),
        .angle_bcd      (angle_bcd),
        .display_bcd    (display_bcd)
    );

    vga_640_480 U10(
        .clk        (clk_25M),
        .rstn       (rstn),
        .hsync      (hsync),
        .vsync      (vsync),
        .hc         (hc),
        .vc         (vc),
        .vidon      (vidon)
    );

    vga_initials U11(
        .clk            (clk_25M),
        .rstn           (rstn),
        .vidon          (vidon),
        .select_sw1     (select_sw1),
        .hc             (hc),
        .vc             (vc),
        .display_bcd    (display_bcd),
        .red            (red),
        .green          (green),
        .blue           (blue)
    );
endmodule
