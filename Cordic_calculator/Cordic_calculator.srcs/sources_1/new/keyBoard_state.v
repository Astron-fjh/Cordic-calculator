`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 小凋
// 
// Create Date: 2023/11/16 21:02:22
// Module Name: keyBoard_state
// Project Name: Cordic_calculator
// Target Devices: Basys3
// Tool Versions: Vivado 2018.3
//////////////////////////////////////////////////////////////////////////////////


module keyBoard_state(
    input wire clk, rstn,
    input wire isDone,
    input wire [7:0] xkey,
    output reg [11:0] angle_bcd = 12'b0000_0000_0000,
    output reg finish
    );

    reg [7:0] data_before = 8'd0, data_after = 8'd0;
    reg [7:0] temp_data = 8'b0000_0000;

    //对键盘数据信号进行延时锁存
    always @ (posedge clk or negedge rstn) begin
        if(!rstn) begin
            data_before <= 8'd0;
            data_after <= 8'd0;
        end else if(isDone) begin
            data_after <= xkey;
            data_before <= data_after;
        end
    end

    // 状态机
    parameter IDLE    = 3'b000;
    parameter DATA_1  = 3'b001;
    parameter WAIT_1  = 3'b010;
    parameter DATA_2  = 3'b011;
    parameter WAIT_2  = 3'b100;
    parameter DATA_3  = 3'b101;
    parameter FINISH  = 3'b110;

    reg [2:0] cstate = IDLE;    // 当前状态
    reg [2:0] nstate = IDLE;    // 次态

    // 状态寄存器
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            cstate <= IDLE;
        else
            cstate <= nstate;
    end

    // 当前状态的组合逻辑
    always @(posedge clk) begin
        case(cstate)
            IDLE: begin
                finish <= 1'b0;
            end

            DATA_1: begin
                case(temp_data)
                    8'h45: begin    // 0
                        angle_bcd[11:8] <= 4'b0000;
                    end
                    8'h16: begin
                        angle_bcd[11:8] <= 4'b0001;    // 1
                    end
                    8'h1E: begin
                        angle_bcd[11:8] <= 4'b0010;    // 2
                    end
                    8'h26: begin
                        angle_bcd[11:8] <= 4'b0011;    // 3
                    end
                    8'h25: begin
                        angle_bcd[11:8] <= 4'b0100;    // 4
                    end
                    8'h2E: begin
                        angle_bcd[11:8] <= 4'b0101;    // 5
                    end
                    8'h36: begin
                        angle_bcd[11:8] <= 4'b0110;    // 6
                    end
                    8'h3D: begin
                        angle_bcd[11:8] <= 4'b0111;    // 7
                    end
                    8'h3E: begin
                        angle_bcd[11:8] <= 4'b1000;    // 8
                    end
                    8'h46: begin
                        angle_bcd[11:8] <= 4'b1001;    // 9
                    end
                endcase
                finish <= 1'b0;
            end

            WAIT_1: begin
                finish <= 1'b0;
            end

            DATA_2: begin
                case(temp_data)
                    8'h45: begin    // 0
                        angle_bcd[7:4] <= 4'b0000;
                    end
                    8'h16: begin
                        angle_bcd[7:4] <= 4'b0001;    // 1
                    end
                    8'h1E: begin
                        angle_bcd[7:4] <= 4'b0010;    // 2
                    end
                    8'h26: begin
                        angle_bcd[7:4] <= 4'b0011;    // 3
                    end
                    8'h25: begin
                        angle_bcd[7:4] <= 4'b0100;    // 4
                    end
                    8'h2E: begin
                        angle_bcd[7:4] <= 4'b0101;    // 5
                    end
                    8'h36: begin
                        angle_bcd[7:4] <= 4'b0110;    // 6
                    end
                    8'h3D: begin
                        angle_bcd[7:4] <= 4'b0111;    // 7
                    end
                    8'h3E: begin
                        angle_bcd[7:4] <= 4'b1000;    // 8
                    end
                    8'h46: begin
                        angle_bcd[7:4] <= 4'b1001;    // 9
                    end
                endcase
                finish <= 1'b0;
            end

            WAIT_2: begin
                finish <= 1'b0;
            end

            DATA_3: begin
                case(temp_data)
                    8'h45: begin    // 0
                        angle_bcd[3:0] <= 4'b0000;
                    end
                    8'h16: begin
                        angle_bcd[3:0] <= 4'b0001;    // 1
                    end
                    8'h1E: begin
                        angle_bcd[3:0] <= 4'b0010;    // 2
                    end
                    8'h26: begin
                        angle_bcd[3:0] <= 4'b0011;    // 3
                    end
                    8'h25: begin
                        angle_bcd[3:0] <= 4'b0100;    // 4
                    end
                    8'h2E: begin
                        angle_bcd[3:0] <= 4'b0101;    // 5
                    end
                    8'h36: begin
                        angle_bcd[3:0] <= 4'b0110;    // 6
                    end
                    8'h3D: begin
                        angle_bcd[3:0] <= 4'b0111;    // 7
                    end
                    8'h3E: begin
                        angle_bcd[3:0] <= 4'b1000;    // 8
                    end
                    8'h46: begin
                        angle_bcd[3:0] <= 4'b1001;    // 9
                    end
                endcase
                finish <= 1'b0;
            end

            FINISH: begin
                finish <= 1'b1;
            end
        endcase
    end

    // 次态的组合逻辑
    always @(posedge clk) begin
        case(cstate)
            IDLE: begin
                if((data_before == 8'hF0) && (data_after != 8'h5A)) begin 
                    nstate <= DATA_1;
                    temp_data <= data_after;
                end else 
                    nstate <= IDLE;
            end

            DATA_1: begin
                if({data_before, data_after} == 16'hF05A) begin 
                    nstate <= WAIT_1;
                end else
                    nstate <= DATA_1;
            end

            WAIT_1: begin
                if((data_before == 8'hF0) && (data_after != 8'h5A)) begin 
                    nstate <= DATA_2;
                    temp_data <= data_after;
                end else
                    nstate <= WAIT_1;
            end

            DATA_2: begin
                if({data_before, data_after} == 16'hF05A) begin 
                    nstate <= WAIT_2;
                end else
                    nstate <= DATA_2;
            end

            WAIT_2: begin
                if((data_before == 8'hF0) && (data_after != 8'h5A)) begin 
                    nstate <= DATA_3;
                    temp_data <= data_after;
                end else
                    nstate <= WAIT_2;
            end

            DATA_3: begin
                if({data_before, data_after} == 16'hF05A) begin 
                    nstate <= FINISH;
                end else
                    nstate <= DATA_3;
            end

            FINISH: begin
                nstate <= IDLE;
            end

            default: 
                nstate <= IDLE;
        endcase
    end

endmodule
