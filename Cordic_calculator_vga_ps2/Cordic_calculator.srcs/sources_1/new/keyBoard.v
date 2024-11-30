`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 小凋
// 
// Create Date: 2023/11/16 20:48:39
// Module Name: keyBoard
// Project Name: Cordic_calculator
// Target Devices: Basys3
// Tool Versions: Vivado 2018.3
//////////////////////////////////////////////////////////////////////////////////

module keyBoard(
    input wire clk,
    input wire rstn,
    input wire PS2C,
    input wire PS2D,
    output reg isDone,
    output reg [7:0] xkey
    );

    reg	key_clk_r0 = 1'b1, key_clk_r1 = 1'b1; 
    reg	key_data_r0 = 1'b1, key_data_r1 = 1'b1;
    
    //对键盘时钟数据信号进行延时锁存
    always @ (posedge clk or negedge rstn) begin
        if(!rstn) begin
            key_clk_r0 <= 1'b1;
            key_clk_r1 <= 1'b1;
            key_data_r0 <= 1'b1;
            key_data_r1 <= 1'b1;
        end else begin
            key_clk_r0 <= PS2C;
            key_clk_r1 <= key_clk_r0;
            key_data_r0 <= PS2D;
            key_data_r1 <= key_data_r0;
        end
    end
    
    //键盘时钟信号下降沿检测
    wire key_clk_neg = key_clk_r1 & (~key_clk_r0); 
    
    reg	[3:0] cnt;
    reg	[7:0] temp_data;

    //根据键盘的时钟信号的下降沿读取数据
    always @ (posedge clk or negedge rstn) begin
        if(!rstn) begin
            cnt <= 4'd0;
            isDone <= 1'b0;
            temp_data <= 8'd0;
        end else if(key_clk_neg) begin 
            if(cnt >= 4'd10) cnt <= 4'd0;
            else cnt <= cnt + 1'b1;
            case (cnt)
                4'd0: isDone <= 0;	//起始位
                4'd1: begin
                    temp_data[0] <= key_data_r1;  //数据位bit0
                    isDone <= 0;
                end
                4'd2: begin
                    temp_data[1] <= key_data_r1;  //数据位bit1
                    isDone <= 0;
                end
                4'd3: begin
                    temp_data[2] <= key_data_r1;  //数据位bit2
                    isDone <= 0;
                end
                4'd4: begin
                    temp_data[3] <= key_data_r1;  //数据位bit3
                    isDone <= 0;
                end
                4'd5: begin
                    temp_data[4] <= key_data_r1;  //数据位bit4
                    isDone <= 0;
                end
                4'd6: begin
                    temp_data[5] <= key_data_r1;  //数据位bit5
                    isDone <= 0;
                end
                4'd7: begin
                    temp_data[6] <= key_data_r1;  //数据位bit6
                    isDone <= 0;
                end
                4'd8: begin
                    temp_data[7] <= key_data_r1;  //数据位bit7
                    isDone <= 0;
                end
                4'd9: begin     //校验位
                    isDone <= 0;
                end
                4'd10: begin    //结束位
                    isDone <= 1; 
                    xkey <= temp_data; 
                end
                default: isDone <= 0;
            endcase
        end else
            isDone <= 0;
    end
endmodule

