`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/15 16:37:46
// Design Name: 
// Module Name: PE
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


module PE(
    input clk, rst,
    input WR_EN, 
    input [31:0] PSUM, 
    input [15:0] Weight,
    input [15:0] ACT,
    input flag,
    output reg [15:0] out_Weight,
    output reg [15:0] out_ACT,
    output reg [31:0] out_PSUM
    );
    
    reg [15:0] LRF;
    
    always@(posedge clk) begin
        if(rst) begin
            LRF = 16'b0;
            out_PSUM = 32'b0;
            out_ACT = 16'b0;      
        end
        else begin
            if(WR_EN)begin
                LRF = Weight;
            end
            out_PSUM = (LRF * ACT) + PSUM;
            out_ACT = ACT;
            if(!flag)
                out_Weight = Weight;
        end    
    end
    
endmodule
