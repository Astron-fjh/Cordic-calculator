`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 小凋
// 
// Create Date: 2023/10/08 12:05:57
// Module Name: testbench
// Project Name: Cordic_calculator
// Target Devices: Basys3
// Tool Versions: vivado 2018.3
//////////////////////////////////////////////////////////////////////////////////

module testbench();
    reg clk, reset;
    reg sw0, sw1, sw2, sw3;
    reg sw4, sw5, sw6, sw7;
    reg select_sw1, select_sw2;
    reg start_key;

    wire [6:0] seg;
    wire [3:0] ans;

    Cordic_top Cordic_calculator(
        .clk    (clk),
        .reset  (reset),
        .sw0    (sw0),
        .sw1    (sw1),
        .sw2    (sw2),
        .sw3    (sw3),
        .sw4    (sw4),
        .sw5    (sw5),
        .sw6    (sw6),
        .sw7    (sw7),
        .seg    (seg),
        .ans    (ans),
        .select_sw1 (select_sw1),
        .select_sw2 (select_sw2),
        .start_key  (start_key)
    );

    initial begin
        clk = 0;
        reset = 1;
        sw0 = 0;
        sw1 = 0;
        sw2 = 0;
        sw3 = 0;
        sw4 = 0;
        sw5 = 0;
        sw6 = 0;
        sw7 = 0;
        select_sw1 = 0;
        select_sw2 = 0;

        #20 reset = 0;
        sw0 = 1;
        sw1 = 0;
        sw2 = 0;
        sw3 = 1;
        sw4 = 0;
        sw5 = 0;
        sw6 = 1;
        sw7 = 0;
        select_sw1 = 1;
        select_sw2 = 0;
    
        #40 start_key = 1'b1;

        #100000000 start_key = 1'b0;

        #100000000 start_key = 1'b1;

        #100000000 start_key = 1'b0;
    end

    always begin
        #5 clk = ~clk;
    end

    
endmodule
