`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 小凋
// 
// Create Date: 2023/10/07 16:01:50
// Module Name: display
// Project Name: Cordic_calculator
// Target Devices: Basys3
// Tool Versions: vivado 2018.3
//////////////////////////////////////////////////////////////////////////////////


module display(
    input wire clk, rstn,
    input wire [15:0] display_bcd,
    output wire [6:0] seg,
    output reg [3:0] ans
    );

    reg [19:0] count = 0;
    reg [3:0] digit = 0;

    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            count = 0;
        else
            count = count + 1;
    end

    always @(posedge clk) begin
        case(count[19:18])
            0:begin
                ans = 4'b0111;      // 选择千位数码管
                digit = display_bcd[15:12];
            end
            1:begin
                ans = 4'b1011;      // 选择百位数码管
                digit = display_bcd[11:8];
            end
            2:begin
                ans = 4'b1101;      // 选择十位数码管
                digit = display_bcd[7:4];
            end
            3:begin
                ans = 4'b1110;      // 选择个位数码管
                digit = display_bcd[3:0];
            end
        endcase
    end

    seg7 U1(
        .din(digit),
        .dout(seg)
    );
endmodule
