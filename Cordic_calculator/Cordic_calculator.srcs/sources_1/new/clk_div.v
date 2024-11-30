`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 小凋
// 
// Create Date: 2023/10/19 19:08:48
// Module Name: clk_div
// Project Name: Cordic_calculator
// Target Devices: Basys3
// Tool Versions: vivado 2018.3
//////////////////////////////////////////////////////////////////////////////////


module clk_div(
    input wire clk_100M,
    input wire rstn,
    output reg clk_25M = 1'b0
    );

    reg [1:0] counter = 2'b00;  // 计数器

    always @(posedge clk_100M or negedge rstn) begin
        if (!rstn) begin
            counter <= 2'b00;  // 复位时重置计数器为0
            clk_25M <= 1'b0;  // 复位时将输出时钟置为0
        end else begin
            if (counter == 2'b01) begin
                counter <= 2'b00;
                clk_25M <= ~clk_25M;
            end else begin
                counter <= counter + 1'b1;
                clk_25M <= clk_25M;
            end
        end
    end

endmodule
