`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 小凋
// 
// Create Date: 2023/10/07 16:01:50
// Module Name: seg7
// Project Name: Cordic_calculator
// Target Devices: Basys3
// Tool Versions: vivado 2018.3
//////////////////////////////////////////////////////////////////////////////////


module seg7(
    input wire [3:0] din,
    output reg [6:0] dout
    );
    always @(*) begin
        case(din)
            0: dout = 7'b000_0001;
            1: dout = 7'b100_1111;
            2: dout = 7'b001_0010;
            3: dout = 7'b000_0110;
            4: dout = 7'b100_1100;
            5: dout = 7'b010_0100;
            6: dout = 7'b010_0000;
            7: dout = 7'b000_1111;
            8: dout = 7'b000_0000;
            9: dout = 7'b000_0100;
            14: dout = 7'b111_1111; 
            15: dout = 7'b111_1110;
            default: dout = 7'b000_0001;
        endcase
    end
endmodule
