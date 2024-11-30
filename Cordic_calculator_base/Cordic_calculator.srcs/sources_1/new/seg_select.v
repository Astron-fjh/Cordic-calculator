`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/09 19:57:05
// Design Name: 
// Module Name: seg_select
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module seg_select(
    input wire clk,
    input wire switch1, // 选择角度或计算结果
    input wire switch2, // 选择sin或cos
    input wire bcd_finish,
    input wire [11:0] sin_bcd,
    input wire [11:0] cos_bcd,
    input wire [7:0]  angle_bcd,
    output reg [11:0] display_bcd
    );

    reg [11:0] sin = 12'b0000_0000_0000, cos = 12'b0000_0000_0000;
    always @(posedge clk) begin
        if(bcd_finish == 1'b1) begin
            sin <= sin_bcd;
            cos <= cos_bcd;
        end
    end

    always @(*) begin
        if(switch1 == 1'b0)
            display_bcd = {4'b0000,angle_bcd};
        else if(switch2 == 1'b0)
            display_bcd = sin;
        else
            display_bcd = cos;
    end

endmodule
