`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 小凋
// 
// Create Date: 2023/11/14 17:28:14
// Module Name: vga_initials
// Project Name: Cordic_calculator
// Target Devices: Basys3
// Tool Versions: vivado 2018.3
//////////////////////////////////////////////////////////////////////////////////

module vga_initials(
    input wire clk, rstn,
    input wire vidon,
    input wire select_sw1,
    input wire [9:0] hc,
    input wire [9:0] vc,
    input wire [15:0] display_bcd,
    output reg [3:0] red, green, blue
    );

    parameter hbp = 10'b00_1001_0000;   // 行显示后沿 = 144(96+48)
    parameter vbp = 10'b00_0010_0010;       // 场显示后沿 = 35(2+33)
    
    // 屏幕中央两个字符的显示区域
	parameter up_pos = 267;
	parameter down_pos = 274;
	parameter left_pos = 441;
	parameter right_pos = 470;
    
    parameter W = 35;   // 字符宽
    parameter H = 8;    // 字符长

    wire [10:0] rom_addr, rom_pix;
    wire [7:0] pixel[34:0];
    wire [3:0] point, sign;
    reg spriteon, R, G, B;
    
    assign point = select_sw1? 4'b1101:4'b1110;
    assign sign  = select_sw1? display_bcd[15:12]:4'b1110;

    always @(*) begin
        if((hc >= left_pos) && (hc < left_pos + W) && (vc >= up_pos) && (vc < up_pos + H))
            spriteon = 1;
        else
            spriteon = 0;
    end

    // 输出信号
    always @(*) begin
        red = 0;
        green = 0;
        blue = 0;
        if((spriteon == 1) && (vidon == 1)) begin
            R = pixel[hc - left_pos][vc - up_pos];
            G = pixel[hc - left_pos][vc - up_pos];
            B = pixel[hc - left_pos][vc - up_pos];
            red = {R, R, R, R};
            green = {G, G, G, G};
            blue = {B, B, B, B};
        end
    end

    RAM_set u_ram_1 (
        .clk(clk),
		.rstn(rstn),
		.data(sign),
		.col0(pixel[0]),
		.col1(pixel[1]),
		.col2(pixel[2]),
		.col3(pixel[3]),
		.col4(pixel[4]),
		.col5(pixel[5]),
		.col6(pixel[6])
    );

    RAM_set u_ram_2 (
        .clk(clk),
		.rstn(rstn),
		.data(display_bcd[11:8]),
		.col0(pixel[7]),
		.col1(pixel[8]),
		.col2(pixel[9]),
		.col3(pixel[10]),
		.col4(pixel[11]),
		.col5(pixel[12]),
		.col6(pixel[13])
    );

    RAM_set u_ram_3 (
        .clk(clk),
		.rstn(rstn),
		.data(point),
		.col0(pixel[14]),
		.col1(pixel[15]),
		.col2(pixel[16]),
		.col3(pixel[17]),
		.col4(pixel[18]),
		.col5(pixel[19]),
		.col6(pixel[20])
    );

    RAM_set u_ram_4 (
        .clk(clk),
		.rstn(rstn),
		.data(display_bcd[7:4]),
		.col0(pixel[21]),
		.col1(pixel[22]),
		.col2(pixel[23]),
		.col3(pixel[24]),
		.col4(pixel[25]),
		.col5(pixel[26]),
		.col6(pixel[27])
    );

    RAM_set u_ram_5 (
        .clk(clk),
		.rstn(rstn),
		.data(display_bcd[3:0]),
		.col0(pixel[28]),
		.col1(pixel[29]),
		.col2(pixel[30]),
		.col3(pixel[31]),
		.col4(pixel[32]),
		.col5(pixel[33]),
		.col6(pixel[34])
    );
endmodule
