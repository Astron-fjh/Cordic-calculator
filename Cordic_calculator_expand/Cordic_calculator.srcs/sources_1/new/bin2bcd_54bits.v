`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/31 14:47:56
// Design Name: 
// Module Name: bin2bcd_54bits
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bin2bcd_54bits(
    input wire clk, rstn,
    input wire [53:0] sin_bin,
    input wire [53:0] cos_bin,
    input wire start,
    output reg [11:0] sin_bcd,
    output reg [11:0] cos_bcd,
    output reg finish
    );

    reg [121:0] sin_data_shift = 122'b0;
    reg [121:0] cos_data_shift = 122'b0;
    reg [5:0] cnt_shift = 6'b0;
    reg shift_flag = 1'b0;

    parameter IDLE = 2'b00;
    parameter START_TO = 2'b01;
    parameter FINISH_TO = 2'b10;

    reg [1:0] cstate = IDLE;
    reg [1:0] nstate = IDLE;

    reg [6:0]  count = 7'b0;

    // 状态寄存器
    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            cstate <= IDLE;
        else
            cstate <= nstate;
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            count <= 0;
        else if(cstate == START_TO) begin
            if(count != 7'd110)
                count <= count + 1'b1;
        end else
                count <= 0;
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
                if(count == 7'd109)
                    nstate = FINISH_TO;
                else
                    nstate = START_TO;
            end
            
            FINISH_TO: begin
                nstate = IDLE;
            end

            default: 
                nstate = IDLE;
        endcase
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

            FINISH_TO: begin
                sin_bcd = sin_data_shift[121:110];
                cos_bcd = cos_data_shift[121:110];
                finish = 1'b1;
            end

            default: begin
                finish = 1'b0;
            end
        endcase
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            cnt_shift <= 6'd0;
        else if((cnt_shift == 6'd54) && (shift_flag == 1'b1))
            cnt_shift <= 6'd0;
        else if((shift_flag == 1'b1) && (cstate == START_TO))
            cnt_shift <= cnt_shift + 1;
        else
            cnt_shift <= cnt_shift;
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            sin_data_shift <= 122'b0;
            cos_data_shift <= 122'b0;
        end else if(cnt_shift == 6'd0) begin
            sin_data_shift <= {68'b0, sin_bin};
            cos_data_shift <= {68'b0, cos_bin};
        end else if((cstate == START_TO) && (cnt_shift <= 54) && (shift_flag == 1'b0)) begin
            sin_data_shift[057:054] <= (sin_data_shift[057:054] > 4) ? (sin_data_shift[057:054] + 2'd3) : (sin_data_shift[057:054]);
            sin_data_shift[061:058] <= (sin_data_shift[061:058] > 4) ? (sin_data_shift[061:058] + 2'd3) : (sin_data_shift[061:058]);
            sin_data_shift[065:062] <= (sin_data_shift[065:062] > 4) ? (sin_data_shift[065:062] + 2'd3) : (sin_data_shift[065:062]);
            sin_data_shift[069:066] <= (sin_data_shift[069:066] > 4) ? (sin_data_shift[069:066] + 2'd3) : (sin_data_shift[069:066]);
            sin_data_shift[073:070] <= (sin_data_shift[073:070] > 4) ? (sin_data_shift[073:070] + 2'd3) : (sin_data_shift[073:070]);
            sin_data_shift[077:074] <= (sin_data_shift[077:074] > 4) ? (sin_data_shift[077:074] + 2'd3) : (sin_data_shift[077:074]);
            sin_data_shift[081:078] <= (sin_data_shift[081:078] > 4) ? (sin_data_shift[081:078] + 2'd3) : (sin_data_shift[081:078]);
            sin_data_shift[085:082] <= (sin_data_shift[085:082] > 4) ? (sin_data_shift[085:082] + 2'd3) : (sin_data_shift[085:082]);
            sin_data_shift[089:086] <= (sin_data_shift[089:086] > 4) ? (sin_data_shift[089:086] + 2'd3) : (sin_data_shift[089:086]);
            sin_data_shift[093:090] <= (sin_data_shift[093:090] > 4) ? (sin_data_shift[093:090] + 2'd3) : (sin_data_shift[093:090]);
            sin_data_shift[097:094] <= (sin_data_shift[097:094] > 4) ? (sin_data_shift[097:094] + 2'd3) : (sin_data_shift[097:094]);
            sin_data_shift[101:098] <= (sin_data_shift[101:098] > 4) ? (sin_data_shift[101:098] + 2'd3) : (sin_data_shift[101:098]);
            sin_data_shift[105:102] <= (sin_data_shift[105:102] > 4) ? (sin_data_shift[105:102] + 2'd3) : (sin_data_shift[105:102]);
            sin_data_shift[109:106] <= (sin_data_shift[109:106] > 4) ? (sin_data_shift[109:106] + 2'd3) : (sin_data_shift[109:106]);
            sin_data_shift[113:110] <= (sin_data_shift[113:110] > 4) ? (sin_data_shift[113:110] + 2'd3) : (sin_data_shift[113:110]);
            sin_data_shift[117:114] <= (sin_data_shift[117:114] > 4) ? (sin_data_shift[117:114] + 2'd3) : (sin_data_shift[117:114]);
            sin_data_shift[121:118] <= (sin_data_shift[121:118] > 4) ? (sin_data_shift[121:118] + 2'd3) : (sin_data_shift[121:118]);
        
            cos_data_shift[057:054] <= (cos_data_shift[057:054] > 4) ? (cos_data_shift[057:054] + 2'd3) : (cos_data_shift[057:054]);
            cos_data_shift[061:058] <= (cos_data_shift[061:058] > 4) ? (cos_data_shift[061:058] + 2'd3) : (cos_data_shift[061:058]);
            cos_data_shift[065:062] <= (cos_data_shift[065:062] > 4) ? (cos_data_shift[065:062] + 2'd3) : (cos_data_shift[065:062]);
            cos_data_shift[069:066] <= (cos_data_shift[069:066] > 4) ? (cos_data_shift[069:066] + 2'd3) : (cos_data_shift[069:066]);
            cos_data_shift[073:070] <= (cos_data_shift[073:070] > 4) ? (cos_data_shift[073:070] + 2'd3) : (cos_data_shift[073:070]);
            cos_data_shift[077:074] <= (cos_data_shift[077:074] > 4) ? (cos_data_shift[077:074] + 2'd3) : (cos_data_shift[077:074]);
            cos_data_shift[081:078] <= (cos_data_shift[081:078] > 4) ? (cos_data_shift[081:078] + 2'd3) : (cos_data_shift[081:078]);
            cos_data_shift[085:082] <= (cos_data_shift[085:082] > 4) ? (cos_data_shift[085:082] + 2'd3) : (cos_data_shift[085:082]);
            cos_data_shift[089:086] <= (cos_data_shift[089:086] > 4) ? (cos_data_shift[089:086] + 2'd3) : (cos_data_shift[089:086]);
            cos_data_shift[093:090] <= (cos_data_shift[093:090] > 4) ? (cos_data_shift[093:090] + 2'd3) : (cos_data_shift[093:090]);
            cos_data_shift[097:094] <= (cos_data_shift[097:094] > 4) ? (cos_data_shift[097:094] + 2'd3) : (cos_data_shift[097:094]);
            cos_data_shift[101:098] <= (cos_data_shift[101:098] > 4) ? (cos_data_shift[101:098] + 2'd3) : (cos_data_shift[101:098]);
            cos_data_shift[105:102] <= (cos_data_shift[105:102] > 4) ? (cos_data_shift[105:102] + 2'd3) : (cos_data_shift[105:102]);
            cos_data_shift[109:106] <= (cos_data_shift[109:106] > 4) ? (cos_data_shift[109:106] + 2'd3) : (cos_data_shift[109:106]);
            cos_data_shift[113:110] <= (cos_data_shift[113:110] > 4) ? (cos_data_shift[113:110] + 2'd3) : (cos_data_shift[113:110]);
            cos_data_shift[117:114] <= (cos_data_shift[117:114] > 4) ? (cos_data_shift[117:114] + 2'd3) : (cos_data_shift[117:114]);
            cos_data_shift[121:118] <= (cos_data_shift[121:118] > 4) ? (cos_data_shift[121:118] + 2'd3) : (cos_data_shift[121:118]);
        end else if((cstate == START_TO) && (cnt_shift <= 54) && (shift_flag == 1'b1)) begin
            sin_data_shift <= sin_data_shift << 1;
            cos_data_shift <= cos_data_shift << 1;
        end else begin
            sin_data_shift <= sin_data_shift;
            cos_data_shift <= cos_data_shift;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if(!rstn)
            shift_flag <= 1'b0;
        else if(cstate == START_TO)
            shift_flag <= ~shift_flag;
        else
            shift_flag <= 1'b0;
    end
    
endmodule
