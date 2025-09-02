`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/26 15:46:35
// Design Name: 
// Module Name: matrix_multiplier
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


module matrix_multiplier(
    input clk,
    input rst,
    input mat_mul,
    input [3:0] m1_address1, m1_address2,
    input [31:0] m1_data,
    input [3:0] m2_address1, m2_address2,
    input [31:0] m2_data,
    output [31:0] out_data
    );
    
    reg [31:0] matrix_A [0:3][0:3];
    reg [31:0] matrix_B [0:3][0:3];
    reg [31:0] matrix_t_B [0:3][0:3];
    
    reg [31:0] matrix_C [0:3][0:3];
    
    reg scale;
    
    integer i, j, k;
    //mat_mul C = A*B
    
    always @(posedge clk) begin
        if(rst)begin
            for(i = 0; i < 4; i=i+1)begin
                for(j = 0; j < 4; j=j+1)begin
                    matrix_C[i][j] = 32'b0;
                    scale = 1;
                end
            end    
        end
        else begin
            matrix_A[m1_address1][m1_address2] = m1_data;
            matrix_B[m2_address1][m2_address2] = m2_data;
        end
    end
    
    always@(posedge clk)begin
        if(mat_mul) begin
            for(i = 0; i < 4; i=i+1)begin
                for(j = 0; j < 4; j=j+1)begin
                    matrix_t_B[i][j] = matrix_B[j][i];
                end
            end
            for(i = 0; i < 4; i=i+1)begin
                for(j = 0; j < 4; j=j+1)begin
                    for(k = 0; k < 4; k=k+1)begin
                        matrix_C[i][j] = matrix_C[i][j] + (matrix_A[i][k] * matrix_B[k][j]);
                        if(scale)begin
                            matrix_C[i][j] = matrix_C[i][j] >> 2;
                        end
                    end
                end
            end 
        end
    end
    
endmodule
