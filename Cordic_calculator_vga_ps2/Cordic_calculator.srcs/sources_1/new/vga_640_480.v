`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 小凋
// 
// Create Date: 2023/10/19 16:39:24
// Module Name: vga_640_480
// Project Name: Cordic_calculator
// Target Devices: Basys3
// Tool Versions: vivado 2018.3
//////////////////////////////////////////////////////////////////////////////////


module vga_640_480(
    input wire clk,
    input wire rstn,
    output reg hsync,
    output reg vsync,
    output reg [9:0] hc,    // 记录行像素点
    output reg [9:0] vc,    // 记录行数
    output reg vidon
    );
    parameter hpixels = 10'b11_0010_0000;   // 每行像素点 = 800
    parameter vlines = 10'b10_0000_1101;    // 行数 = 525
    parameter hbp = 10'b00_1001_0000;       // 行显示后沿 = 144(96+48)
    parameter hfp = 10'b11_0001_0000;       // 行显示前沿 = 784(96+48+640)
    parameter vbp = 10'b00_0010_0011;       // 场显示后沿 = 35(2+33)
    parameter vfp = 10'b10_0000_0011;       // 场显示前沿 = 515(2+33+480)
    reg vsenable;   // 使能vc

    // 行同步信号计数器
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            hc <= 0;
        else begin
            // 一行结束
            if(hc == hpixels - 1) begin
                hc <= 0;    // 计数器复位
                vsenable <= 1;  // 纵向开始计数
            end else begin
                hc <= hc + 1;
                vsenable <= 0;
            end
        end
    end

    // 产生hsync脉冲
    always @(*) begin
        if(hc < 96)
            hsync = 1;
        else
            hsync = 0;
    end

    // 场同步信号计数器
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            vc <= 0;
        else begin
            if(vsenable == 1) begin
                // 列结束
                if(vc == vlines - 1)
                    vc <= 0;
                else
                    vc <= vc + 1;
            end
        end
    end

    // 产生vsync脉冲
    always @(*) begin
        if(vc < 2)
            vsync = 1;
        else
            vsync = 0;
    end

    // 使能显示器显示
    always @(*) begin
        if((hc < hfp) && (hc >= hbp) && (vc < vfp) && (vc >= vbp))
            vidon = 1;
        else
            vidon = 0;
    end
endmodule
