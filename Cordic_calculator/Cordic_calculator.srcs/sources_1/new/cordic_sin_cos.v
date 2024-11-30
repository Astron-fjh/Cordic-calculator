`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: 小凋
// 
// Create Date: 2023/10/08 21:59:54
// Module Name: cordic_sin_cos
// Project Name: Cordic_calculator
// Target Devices: Basys3
// Tool Versions: vivado 2018.3
//////////////////////////////////////////////////////////////////////////////////

module cordic_sin_cos(
    input wire clk, rstn,
    input wire [11:0] angle,
    input wire start,
    output reg signed [31:0] sin,
    output reg signed [31:0] cos,
    output reg sin_sign = 1'b0,
    output reg cos_sign = 1'b0,
    output reg finish
    );

    // cordic 算法参数声明
    parameter rot_0  = 32'd2949120;     // 45° << 16
    parameter rot_1  = 32'd1740970;     // 26.5651° << 16
    parameter rot_2  = 32'd919876;      // 14.0362° << 16
    parameter rot_3  = 32'd466944;      // 7.1250°  << 16
    parameter rot_4  = 32'd234376;      // 3.5763°  << 16
    parameter rot_5  = 32'd117303;      // 1.7899°  << 16
    parameter rot_6  = 32'd58668;       // 0.8952°  << 16
    parameter rot_7  = 32'd29334;       // 0.4476°  << 16
    parameter rot_8  = 32'd14667;       // 0.2238°  << 16
    parameter rot_9  = 32'd7333;        // 0.1119°  << 16
    parameter rot_10 = 32'd3670;        // 0.0560°  << 16
    parameter rot_11 = 32'd1835;        // 0.0280°  << 16
    parameter rot_12 = 32'd918;         // 0.0140°  << 16
    parameter rot_13 = 32'd459;         // 0.0070°  << 16
    parameter rot_14 = 32'd229;         // 0.0035°  << 16
    parameter rot_15 = 32'd118;         // 0.0018°  << 16

    parameter PIPELINE = 5'd16;
    parameter KN       = 32'd39797;     // KN 迭代16次提取出的cosi乘积之和 << 16

    // 旋转有+-，定义为有符号数
    reg signed [31:0]   x0  = 0, y0  = 0, z0  = 0;
    reg signed [31:0]   x1  = 0, y1  = 0, z1  = 0;
    reg signed [31:0]   x2  = 0, y2  = 0, z2  = 0;
    reg signed [31:0]   x3  = 0, y3  = 0, z3  = 0;
    reg signed [31:0]   x4  = 0, y4  = 0, z4  = 0;
    reg signed [31:0]   x5  = 0, y5  = 0, z5  = 0;
    reg signed [31:0]   x6  = 0, y6  = 0, z6  = 0;
    reg signed [31:0]   x7  = 0, y7  = 0, z7  = 0;
    reg signed [31:0]   x8  = 0, y8  = 0, z8  = 0;
    reg signed [31:0]   x9  = 0, y9  = 0, z9  = 0;
    reg signed [31:0]   x10 = 0, y10 = 0, z10 = 0;
    reg signed [31:0]   x11 = 0, y11 = 0, z11 = 0;
    reg signed [31:0]   x12 = 0, y12 = 0, z12 = 0;
    reg signed [31:0]   x13 = 0, y13 = 0, z13 = 0;
    reg signed [31:0]   x14 = 0, y14 = 0, z14 = 0;
    reg signed [31:0]   x15 = 0, y15 = 0, z15 = 0;
    reg signed [31:0]   x16 = 0, y16 = 0, z16 = 0;

    reg [1:0] quadrant = 2'b00;
    reg [6:0] count = 6'b0;

    // 状态机参数声明
    parameter IDLE = 2'b00;
    parameter START_CAL = 2'b01;
    parameter WAIT_CAL  = 2'b10;
    parameter FINISH_CAL = 2'b11;

    reg [1:0] cstate = IDLE;   // 当前状态
    reg [1:0] nstate = IDLE;   // 次态

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

            START_CAL: begin
                finish = 1'b0;
            end

            WAIT_CAL: begin
                if(quadrant == 2'b00) begin
                    sin = y16;
                    cos = x16;
                    sin_sign = 1'b0;
                    cos_sign = 1'b0;
                    finish = 1'b0;
                end else if(quadrant == 2'b01) begin
                    sin = x16;
                    cos = y16;
                    sin_sign = 1'b0;
                    cos_sign = 1'b1;
                    finish = 1'b0;
                end else if(quadrant == 2'b10) begin
                    sin = y16;
                    cos = x16;
                    sin_sign = 1'b1;
                    cos_sign = 1'b1;
                    finish = 1'b0;
                end else if(quadrant == 2'b11) begin
                    sin = x16;
                    cos = y16;
                    sin_sign = 1'b1;
                    cos_sign = 1'b0;
                    finish = 1'b0;
                end
            end

            FINISH_CAL: begin
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
                    nstate = START_CAL;
                else
                    nstate = IDLE;
            end

            START_CAL: begin
                if(count == 7'd17)
                    nstate = WAIT_CAL;
                else
                    nstate = START_CAL;
            end

            WAIT_CAL: begin
                if(count == 7'd109)
                    nstate = FINISH_CAL;
                else
                    nstate = WAIT_CAL;
            end

            FINISH_CAL: begin
                nstate = IDLE;
            end

            default: 
                nstate = IDLE;
        endcase
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            count <= 0;
        else if((cstate == START_CAL) || (cstate == WAIT_CAL)) begin
            if(count != 7'd110)
                count <= count + 1'b1;
        end else
                count <= 0;
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x0 <= 32'b0;
            y0 <= 32'b0;
            z0 <= 32'b0;
        end else if(cstate == START_CAL) begin
            if(angle <= 90) begin   // 第一象限
                x0 <= KN;           // 将初始x坐标扩大 KN 倍
                y0 <= 32'd0;
                z0 <= angle << 16;  // angle左移16位与rot匹配
                quadrant <= 2'b00;
            end else if((angle > 90) && (angle <= 180)) begin   // 第二象限
                x0 <= KN;
                y0 <= 32'd0;
                z0 <= (angle - 90) << 16;
                quadrant <= 2'b01;
            end else if((angle > 180) && (angle <= 270)) begin  // 第三象限
                x0 <= KN;
                y0 <= 32'd0;
                z0 <= (angle - 180) << 16;
                quadrant <= 2'b10;
            end else if((angle > 270) && (angle <= 360)) begin  // 第四象限
                x0 <= KN;
                y0 <= 32'd0;
                z0 <= (angle - 270) << 16;
                quadrant <= 2'b11;
            end
        end else begin
            x0 <= x0;
            y0 <= y0;
            z0 <= z0;
        end
    end

    // 第 1 次迭代
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x1 <= 32'b0;
            y1 <= 32'b0;
            z1 <= 32'b0;
        end else if(cstate == START_CAL) begin
            if(z0[31]) begin    // 如果角度为负数，则顺时针旋转
                x1 <= x0 + y0;
                y1 <= y0 - x0;
                z1 <= z0 + rot_0;
            end else begin      // 如果角度为负数，则逆时针旋转
                x1 <= x0 - y0;
                y1 <= y0 + x0;
                z1 <= z0 - rot_0;
            end
        end else begin
            x1 <= x1;
            y1 <= y1;
            z1 <= z1;
        end
    end

    // 第 2 次迭代
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x2 <= 32'b0;
            y2 <= 32'b0;
            z2 <= 32'b0;
        end else if(cstate == START_CAL) begin
            if(z1[31]) begin
                x2 <= x1 + (y1 >>> 1);  // 由于为有符号数，所以用算数右移 >>>
                y2 <= y1 - (x1 >>> 1);
                z2 <= z1 + rot_1;
            end else begin
                x2 <= x1 - (y1 >>> 1);
                y2 <= y1 + (x1 >>> 1);
                z2 <= z1 - rot_1;
            end
        end else begin
            x2 <= x2;
            y2 <= y2;
            z2 <= z2;
        end
    end

    // 第 3 次迭代
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x3 <= 32'b0;
            y3 <= 32'b0;
            z3 <= 32'b0;
        end else if(cstate == START_CAL) begin
            if(z2[31]) begin
                x3 <= x2 + (y2 >>> 2);
                y3 <= y2 - (x2 >>> 2);
                z3 <= z2 + rot_2;
            end else begin
                x3 <= x2 - (y2 >>> 2);
                y3 <= y2 + (x2 >>> 2);
                z3 <= z2 - rot_2;
            end
        end else begin
            x3 <= x3;
            y3 <= y3;
            z3 <= z3;
        end
    end

    // 第 4 次迭代
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x4 <= 32'b0;
            y4 <= 32'b0;
            z4 <= 32'b0;
        end else if(cstate == START_CAL) begin 
            if(z3[31]) begin
                x4 <= x3 + (y3 >>> 3);
                y4 <= y3 - (x3 >>> 3);
                z4 <= z3 + rot_3;
            end else begin
                x4 <= x3 - (y3 >>> 3);
                y4 <= y3 + (x3 >>> 3);
                z4 <= z3 - rot_3;
            end
        end else begin
            x4 <= x4;
            y4 <= y4;
            z4 <= z4;
        end
    end

    // 第 5 次迭代
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x5 <= 32'b0;
            y5 <= 32'b0;
            z5 <= 32'b0;
        end else if(cstate == START_CAL) begin 
            if(z4[31]) begin
                x5 <= x4 + (y4 >>> 4);
                y5 <= y4 - (x4 >>> 4);
                z5 <= z4 + rot_4;
            end else begin
                x5 <= x4 - (y4 >>> 4);
                y5 <= y4 + (x4 >>> 4);
                z5 <= z4 - rot_4;
            end
        end else begin
            x5 <= x5;
            y5 <= y5;
            z5 <= z5;
        end           
    end

    // 第 6 次迭代
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x6 <= 32'b0;
            y6 <= 32'b0;
            z6 <= 32'b0;
        end else if(cstate == START_CAL) begin
            if(z5[31]) begin
                x6 <= x5 + (y5 >>> 5);
                y6 <= y5 - (x5 >>> 5);
                z6 <= z5 + rot_5;
            end else begin
                x6 <= x5 - (y5 >>> 5);
                y6 <= y5 + (x5 >>> 5);
                z6 <= z5 - rot_5;
            end
        end else begin
            x6 <= x6;
            y6 <= y6;
            z6 <= z6;
        end
    end

    // 第 7 次迭代
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x7 <= 32'b0;
            y7 <= 32'b0;
            z7 <= 32'b0;
        end else if(cstate == START_CAL) begin 
            if(z6[31]) begin
                x7 <= x6 + (y6 >>> 6);
                y7 <= y6 - (x6 >>> 6);
                z7 <= z6 + rot_6;
            end else begin
                x7 <= x6 - (y6 >>> 6);
                y7 <= y6 + (x6 >>> 6);
                z7 <= z6 - rot_6;
            end
        end else begin
            x7 <= x7;
            y7 <= y7;
            z7 <= z7;
        end
    end

    // 第 8 次迭代
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x8 <= 32'b0;
            y8 <= 32'b0;
            z8 <= 32'b0;
        end else if(cstate == START_CAL) begin 
            if(z7[31]) begin
                x8 <= x7 + (y7 >>> 7);
                y8 <= y7 - (x7 >>> 7);
                z8 <= z7 + rot_7;
            end else begin
                x8 <= x7 - (y7 >>> 7);
                y8 <= y7 + (x7 >>> 7);
                z8 <= z7 - rot_7;
            end
        end else begin
            x8 <= x8;
            y8 <= y8;
            z8 <= z8;
        end
    end

    // 第 9 次迭代
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x9 <= 32'b0;
            y9 <= 32'b0;
            z9 <= 32'b0;
        end else if(cstate == START_CAL) begin
            if(z8[31]) begin
                x9 <= x8 + (y8 >>> 8);
                y9 <= y8 - (x8 >>> 8);
                z9 <= z8 + rot_8;
            end else begin
                x9 <= x8 - (y8 >>> 8);
                y9 <= y8 + (x8 >>> 8);
                z9 <= z8 - rot_8;
            end
        end else begin
            x9 <= x9;
            y9 <= y9;
            z9 <= z9;
        end
    end

    // 第 10 次迭代
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x10 <= 32'b0;
            y10 <= 32'b0;
            z10 <= 32'b0;
        end else if(cstate == START_CAL) begin 
            if(z9[31]) begin
                x10 <= x9 + (y9 >>> 9);
                y10 <= y9 - (x9 >>> 9);
                z10 <= z9 + rot_9;
            end else begin
                x10 <= x9 - (y9 >>> 9);
                y10 <= y9 + (x9 >>> 9);
                z10 <= z9 - rot_9;
            end
        end else begin
            x10 <= x10;
            y10 <= y10;
            z10 <= z10;
        end
    end

    // 第 11 次迭代
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x11 <= 32'b0;
            y11 <= 32'b0;
            z11 <= 32'b0;
        end else if(cstate == START_CAL) begin
            if(z10[31]) begin
                x11 <= x10 + (y10 >>> 10);
                y11 <= y10 - (x10 >>> 10);
                z11 <= z10 + rot_10;
            end else begin
                x11 <= x10 - (y10 >>> 10);
                y11 <= y10 + (x10 >>> 10);
                z11 <= z10 - rot_10;
            end
        end else begin
            x11 <= x11;
            y11 <= y11;
            z11 <= z11;
        end
    end

    // 第 12 次迭代
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x12 <= 32'b0;
            y12 <= 32'b0;
            z12 <= 32'b0;
        end else if(cstate == START_CAL) begin
            if(z11[31]) begin
                x12 <= x11 + (y11 >>> 11);
                y12 <= y11 - (x11 >>> 11);
                z12 <= z11 + rot_11;
            end else begin
                x12 <= x11 - (y11 >>> 11);
                y12 <= y11 + (x11 >>> 11);
                z12 <= z11 - rot_11;
            end
        end else begin
            x12 <= x12;
            y12 <= y12;
            z12 <= z12;
        end
    end

    // 第 13 次迭代
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x13 <= 32'b0;
            y13 <= 32'b0;
            z13 <= 32'b0;
        end else if(cstate == START_CAL) begin
            if(z12[31]) begin
                x13 <= x12 + (y12 >>> 12);
                y13 <= y12 - (x12 >>> 12);
                z13 <= z12 + rot_12;
            end else begin
                x13 <= x12 - (y12 >>> 12);
                y13 <= y12 + (x12 >>> 12);
                z13 <= z12 - rot_12;
            end
        end else begin
            x13 <= x13;
            y13 <= y13;
            z13 <= z13;
        end
    end

    // 第 14 次迭代
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x14 <= 32'b0;
            y14 <= 32'b0;
            z14 <= 32'b0;
        end else if(cstate == START_CAL) begin 
            if(z13[31]) begin
                x14 <= x13 + (y13 >>> 13);
                y14 <= y13 - (x13 >>> 13);
                z14 <= z13 + rot_13;
            end else begin
                x14 <= x13 - (y13 >>> 13);
                y14 <= y13 + (x13 >>> 13);
                z14 <= z13 - rot_13;
            end
        end else begin
            x14 <= x14;
            y14 <= y14;
            z14 <= z14;
        end
    end

    // 第 15 次迭代
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x15 <= 32'b0;
            y15 <= 32'b0;
            z15 <= 32'b0;
        end else if(cstate == START_CAL) begin 
            if(z14[31]) begin
                x15 <= x14 + (y14 >>> 14);
                y15 <= y14 - (x14 >>> 14);
                z15 <= z14 + rot_14;
            end else begin
                x15 <= x14 - (y14 >>> 14);
                y15 <= y14 + (x14 >>> 14);
                z15 <= z14 - rot_14;
            end
        end else begin
            x15 <= x15;
            y15 <= y15;
            z15 <= z15;
        end
    end

    // 第 16 次迭代
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            x16 <= 32'b0;
            y16 <= 32'b0;
            z16 <= 32'b0;
        end else if(cstate == START_CAL) begin
            if(z15[31]) begin
                x16 <= x15 + (y15 >>> 15);
                y16 <= y15 - (x15 >>> 15);
                z16 <= z15 + rot_15;
            end else begin
                x16 <= x15 - (y15 >>> 15);
                y16 <= y15 + (x15 >>> 15);
                z16 <= z15 - rot_15;
            end
        end else begin
            x16 <= x16;
            y16 <= y16;
            z16 <= z16;
        end
    end

endmodule
