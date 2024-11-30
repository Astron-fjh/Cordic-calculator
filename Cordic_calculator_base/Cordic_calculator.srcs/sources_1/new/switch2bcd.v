`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 小凋
// 
// Create Date: 2023/10/07 16:01:50
// Module Name: switch2bcd
// Project Name: Cordic_calculator
// Target Devices: Basys3
// Tool Versions: vivado 2018.3
//////////////////////////////////////////////////////////////////////////////////


module switch2bcd(
    input wire clk, rstn,
    input wire sw0, sw1, sw2, sw3,
    input wire sw4, sw5, sw6, sw7,
    output reg [7:0] angle_bcd = 8'b0000_0000
    );
    
    wire [3:0] bcd0;
    wire [3:0] bcd1;
    assign bcd0[3:0] = {sw3,sw2,sw1,sw0};
    assign bcd1[3:0] = {sw7,sw6,sw5,sw4};
    
    always @(posedge clk or negedge rstn) begin
        if(!rstn)   // 复位
            angle_bcd[7:0] <= 8'b0000_0000;
        else if((bcd0 > 4'b1001) || (bcd1 > 4'b1001) || ({bcd1,bcd0} > 8'b1001_0000)) // 不符合 BCD编码要求 || 超过90°
            angle_bcd[7:0] <= 8'b1111_1111; 
        else
            angle_bcd[7:0] <= {bcd1,bcd0}; 
    end
endmodule
