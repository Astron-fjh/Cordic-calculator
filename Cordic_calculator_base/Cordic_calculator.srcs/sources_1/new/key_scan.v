`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 小凋
// 
// Create Date: 2023/10/09 23:26:45
// Module Name: key_scan
// Project Name: Cordic_calculator
// Target Devices: Basys3
// Tool Versions: vivado 2018.3
//////////////////////////////////////////////////////////////////////////////////

module key_scan(
    input wire clk, rstn,
    input wire start_key,
    output wire start
    );

    // 时钟主频为100MHz，周期为10ns，设置延时为10ms
    parameter CNT_10MS = 24'd10000000;
    
    reg [23:0] cnt;
    reg        key_n;
    reg        key_r;

    // 延时
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            cnt <= 1'b0;
        else if(cnt == CNT_10MS)
            cnt <= 1'b0;
        else
            cnt <= cnt + 1'b1;
    end

    // 按键输入
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            key_n <= 1'b0;
            key_r <= 1'b0;
        end else if(cnt == CNT_10MS) begin
            key_n <= start_key;
            key_r <= key_n;
        end else begin
            key_n <= key_n;
            key_r <= key_r;
        end
    end

    // 按键扫描
    assign start = key_n & ~key_r;

endmodule
