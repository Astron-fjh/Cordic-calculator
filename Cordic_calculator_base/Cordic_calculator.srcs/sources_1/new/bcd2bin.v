`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 小凋
// 
// Create Date: 2023/10/08 10:58:06
// Module Name: bcd2bin
// Project Name: Cordic_calculator
// Target Devices: Basys3
// Tool Versions: vivado 2018.3
//////////////////////////////////////////////////////////////////////////////////

module bcd2bin(
    input wire [7:0] angle_bcd, // 8位8421BCD输入
    output reg [7:0] angle_bin = 8'b0000_0000 // 8位二进制输出
    );

    integer i;

    always @(*) begin
        angle_bin = angle_bcd[3:0];
        for(i = 4; i <= 7; i = i+1) begin
            if(angle_bcd[i] == 1'b1)
                angle_bin = angle_bin + (8'b0000_1010 << (i-4)); 
        end
    end
endmodule