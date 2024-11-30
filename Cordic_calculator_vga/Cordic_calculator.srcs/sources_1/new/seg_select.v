`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 小凋
// 
// Create Date: 2023/11/09 19:57:05
// Module Name: seg_select
// Project Name: Cordic_calculator
// Target Devices: Basys3
// Tool Versions: vivado 2018.3
//////////////////////////////////////////////////////////////////////////////////

module seg_select(
    input wire clk,
    input wire switch1, // 选择角度或计算结果
    input wire switch2, // 选择sin或cos
    input wire bcd_finish,
    input wire sin_sign,
    input wire cos_sign,
    input wire [11:0] sin_bcd,
    input wire [11:0] cos_bcd,
    input wire [11:0] angle_bcd,
    output reg [15:0] display_bcd
    );

    reg [15:0] sin = 16'b0000_0000_0000_0000, cos = 16'b0000_0000_0000_0000;
    always @(posedge clk) begin
        if(bcd_finish == 1'b1) begin
            if(sin_sign == 1'b1)
                sin <= {4'b1111, sin_bcd};
            else
                sin <= {4'b1110, sin_bcd};
            if(cos_sign == 1'b1)
                cos <= {4'b1111, cos_bcd};
            else
                cos <= {4'b1110, cos_bcd};
        end
    end

    always @(*) begin
        if(switch1 == 1'b0)
            display_bcd = {4'b1110,angle_bcd};
        else if(switch2 == 1'b0)
            display_bcd = sin;
        else
            display_bcd = cos;
    end

endmodule
