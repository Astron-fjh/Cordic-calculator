`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 小凋
// 
// Create Date: 2023/10/11 14:57:54
// Module Name: int2float
// Project Name: Cordic_calculator
// Target Devices: Basys3
// Tool Versions: vivado 2018.3
//////////////////////////////////////////////////////////////////////////////////

module int2float(
    input wire clk, rstn,
    input wire start,
    input wire signed [31:0] sin_int,
    input wire signed [31:0] cos_int,
    output reg [53:0] sin,
    output reg [53:0] cos,
    output reg finish
    );

    reg [53:0] x0  = 0, y0  = 0;
    reg [53:0] x1  = 0, y1  = 0;
    reg [53:0] x2  = 0, y2  = 0;
    reg [53:0] x3  = 0, y3  = 0;
    reg [53:0] x4  = 0, y4  = 0;
    reg [53:0] x5  = 0, y5  = 0;
    reg [53:0] x6  = 0, y6  = 0;
    reg [53:0] x7  = 0, y7  = 0;
    reg [53:0] x8  = 0, y8  = 0;
    reg [53:0] x9  = 0, y9  = 0;
    reg [53:0] x10 = 0, y10 = 0;
    reg [53:0] x11 = 0, y11 = 0;
    reg [53:0] x12 = 0, y12 = 0;
    reg [53:0] x13 = 0, y13 = 0;
    reg [53:0] x14 = 0, y14 = 0;
    reg [53:0] x15 = 0, y15 = 0;
    reg [53:0] x16 = 0, y16 = 0;
    
    reg [6:0]  count = 7'b0;

    // 状态机参数声明
    parameter IDLE = 2'b00;
    parameter START_TO = 2'b01;
    parameter WAIT_TO  = 2'b10;
    parameter FINISH_TO = 2'b11;

    reg [1:0] cstate = IDLE;    // 当前状态
    reg [1:0] nstate = IDLE;    // 次态

    // 状态寄存器
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            cstate <= IDLE;
        else
            cstate <= nstate;
    end

    // 当前状态的组合逻辑
    always @(*) begin
        case(cstate)
            IDLE: begin
                finish = 1'b0;
            end

            START_TO: begin
                finish = 1'b0;
            end

            WAIT_TO: begin
                sin = x16;
                cos = y16;
                finish = 1'b0;
            end

            FINISH_TO: begin
                finish = 1'b1;
            end

            default: begin
                finish = 1'b0;
            end
        endcase
    end

    // 次态的组合逻辑
    always @(*) begin
        case(cstate)
            IDLE: begin
                if(start == 1'b1)
                    nstate = START_TO;
                else
                    nstate = IDLE;
            end

            START_TO: begin
                if(count == 7'd17)
                    nstate = WAIT_TO;
                else
                    nstate = START_TO;
            end

            WAIT_TO: begin
                if(count == 7'd109)
                    nstate = FINISH_TO;
                else
                    nstate = WAIT_TO;
            end

            FINISH_TO: begin
                nstate = IDLE;
            end

            default: 
                nstate = IDLE;
        endcase
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            count <= 0;
        else if((cstate == START_TO) || (cstate == WAIT_TO)) begin
            if(count != 7'd110)
                count <= count + 1'b1;
        end else
                count <= 0;
    end

    // 第 1 次累加
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x0 <= 54'b0;
            y0 <= 54'b0;
        end else if (cstate == START_TO) begin
            if(sin_int[16] == 1'b1)
                x0 <= 54'd10000000000000000;
            else
                x0 <= 54'b0;
            if(cos_int[16] == 1'b1)
                y0 <= 54'd10000000000000000;
            else
                y0 <= 54'b0;
        end else begin
            x0 <= x0;
            y0 <= y0;
        end
    end
    
    // 第 2 次累加
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x1 <= 54'b0;
            y1 <= 54'b0;
        end else if (cstate == START_TO) begin
            if(sin_int[15] == 1'b1)
                x1 <= x0 + 54'd5000000000000000;
            else
                x1 <= x0;
            if(cos_int[15] == 1'b1)
                y1 <= y0 + 54'd5000000000000000;
            else
                y1 <= y0;
        end else begin
            x1 <= x1;
            y1 <= y1;
        end
    end

    // 第 3 次累加
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x2 <= 54'b0;
            y2 <= 54'b0;
        end else if (cstate == START_TO) begin
            if(sin_int[14] == 1'b1)
                x2 <= x1 + 54'd2500000000000000;
            else
                x2 <= x1;
            if(cos_int[14] == 1'b1)
                y2 <= y1 + 54'd2500000000000000;
            else
                y2 <= y1;
        end else begin
            x2 <= x2;
            y2 <= y2;
        end
    end

    // 第 4 次累加
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x3 <= 54'b0;
            y3 <= 54'b0;
        end else if (cstate == START_TO) begin
            if(sin_int[13] == 1'b1)
                x3 <= x2 + 54'd1250000000000000;
            else
                x3 <= x2;
            if(cos_int[13] == 1'b1)
                y3 <= y2 + 54'd1250000000000000;
            else
                y3 <= y2;
        end else begin
            x3 <= x3;
            y3 <= y3;
        end
    end

    // 第 5 次累加
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x4 <= 54'b0;
            y4 <= 54'b0;
        end else if (cstate == START_TO) begin
            if(sin_int[12] == 1'b1)
                x4 <= x3 + 54'd625000000000000;
            else
                x4 <= x3;
            if(cos_int[12] == 1'b1)
                y4 <= y3 + 54'd625000000000000;
            else
                y4 <= y3;
        end else begin
            x4 <= x4;
            y4 <= y4;
        end
    end

    // 第 6 次累加
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x5 <= 54'b0;
            y5 <= 54'b0;
        end else if (cstate == START_TO) begin
            if(sin_int[11] == 1'b1)
                x5 <= x4 + 54'd312500000000000;
            else
                x5 <= x4;
            if(cos_int[11] == 1'b1)
                y5 <= y4 + 54'd312500000000000;
            else
                y5 <= y4;
        end else begin
            x5 <= x5;
            y5 <= y5;
        end
    end

    // 第 7 次累加
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x6 <= 54'b0;
            y6 <= 54'b0;
        end else if (cstate == START_TO) begin
            if(sin_int[10] == 1'b1)
                x6 <= x5 + 54'd156250000000000;
            else
                x6 <= x5;
            if(cos_int[10] == 1'b1)
                y6 <= y5 + 54'd156250000000000;
            else
                y6 <= y5;
        end else begin
            x6 <= x6;
            y6 <= y6;
        end
    end

    // 第 8 次累加
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x7 <= 54'b0;
            y7 <= 54'b0;
        end else if (cstate == START_TO) begin
            if(sin_int[9] == 1'b1)
                x7 <= x6 + 54'd78125000000000;
            else
                x7 <= x6;
            if(cos_int[9] == 1'b1)
                y7 <= y6 + 54'd78125000000000;
            else
                y7 <= y6;
        end else begin
            x7 <= x7;
            y7 <= y7;
        end
    end

    // 第 9 次累加
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x8 <= 54'b0;
            y8 <= 54'b0;
        end else if (cstate == START_TO) begin
            if(sin_int[8] == 1'b1)
                x8 <= x7 + 54'd39062500000000;
            else
                x8 <= x7;
            if(cos_int[8] == 1'b1)
                y8 <= y7 + 54'd39062500000000;
            else
                y8 <= y7;
        end else begin
            x8 <= x8;
            y8 <= y8;
        end
    end

    // 第 10 次累加
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x9 <= 54'b0;
            y9 <= 54'b0;
        end else if (cstate == START_TO) begin
            if(sin_int[7] == 1'b1)
                x9 <= x8 + 54'd19531250000000;
            else
                x9 <= x8;
            if(cos_int[7] == 1'b1)
                y9 <= y8 + 54'd19531250000000;
            else
                y9 <= y8;
        end else begin
            x9 <= x9;
            y9 <= y9;
        end
    end

    // 第 11 次累加
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x10 <= 54'b0;
            y10 <= 54'b0;
        end else if (cstate == START_TO) begin
            if(sin_int[6] == 1'b1)
                x10 <= x9 + 54'd9765625000000;
            else
                x10 <= x9;
            if(cos_int[6] == 1'b1)
                y10 <= y9 + 54'd9765625000000;
            else
                y10 <= y9;
        end else begin
            x10 <= x10;
            y10 <= y10;
        end
    end

    // 第 12 次累加
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x11 <= 54'b0;
            y11 <= 54'b0;
        end else if (cstate == START_TO) begin
            if(sin_int[5] == 1'b1)
                x11 <= x10 + 54'd4882812500000;
            else
                x11 <= x10;
            if(cos_int[5] == 1'b1)
                y11 <= y10 + 54'd4882812500000;
            else
                y11 <= y10;
        end else begin
            x11 <= x11;
            y11 <= y11;
        end
    end

    // 第 13 次累加
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x12 <= 54'b0;
            y12 <= 54'b0;
        end else if (cstate == START_TO) begin
            if(sin_int[4] == 1'b1)
                x12 <= x11 + 54'd2441406250000;
            else
                x12 <= x11;
            if(cos_int[4] == 1'b1)
                y12 <= y11 + 54'd2441406250000;
            else
                y12 <= y11;
        end else begin
            x12 <= x12;
            y12 <= y12;
        end
    end

    // 第 14 次累加
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x13 <= 54'b0;
            y13 <= 54'b0;
        end else if (cstate == START_TO) begin
            if(sin_int[3] == 1'b1)
                x13 <= x12 + 54'd1220703125000;
            else
                x13 <= x12;
            if(cos_int[3] == 1'b1)
                y13 <= y12 + 54'd1220703125000;
            else
                y13 <= y12;
        end else begin
            x13 <= x13;
            y13 <= y13;
        end
    end

    // 第 15 次累加
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x14 <= 54'b0;
            y14 <= 54'b0;
        end else if (cstate == START_TO) begin
            if(sin_int[2] == 1'b1)
                x14 <= x13 + 54'd610351562500;
            else
                x14 <= x13;
            if(cos_int[2] == 1'b1)
                y14 <= y13 + 54'd610351562500;
            else
                y14 <= y13;
        end else begin
            x14 <= x14;
            y14 <= y14;
        end
    end

    // 第 16 次累加
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x15 <= 54'b0;
            y15 <= 54'b0;
        end else if (cstate == START_TO) begin
            if(sin_int[1] == 1'b1)
                x15 <= x14 + 54'd305175781250;
            else
                x15 <= x14;
            if(cos_int[1] == 1'b1)
                y15 <= y14 + 54'd305175781250;
            else
                y15 <= y14;
        end else begin
            x15 <= x15;
            y15 <= y15;
        end
    end

    // 第 17 次累加
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x16 <= 54'b0;
            y16 <= 54'b0;
        end else if (cstate == START_TO) begin
            if(sin_int[0] == 1'b1)
                x16 <= x15 + 54'd152587890625;
            else
                x16 <= x15;
            if(cos_int[0] == 1'b1)
                y16 <= y15 + 54'd152587890625;
            else
                y16 <= y15;
        end else begin
            x16 <= x16;
            y16 <= y16;
        end
    end
endmodule
