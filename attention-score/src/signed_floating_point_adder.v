`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/17 14:47:00
// Design Name: 
// Module Name: signed_floating_point_adder
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

module signed_floating_point_adder(
  input wire [15:0] operand_a,
  input wire [15:0] operand_b,
  input clk,
  input rst,
  output reg [15:0] result
);

    wire sign_a;
    wire sign_b;
    reg sign;
    wire flag;
    wire [4:0] exponent_a;
    wire [4:0] exponent_b;
    wire [9:0] fraction_a;
    wire [9:0] fraction_b;
    
    // Splitting the operands into sign, exponent, and fraction
    assign sign_a = operand_a[15];
    assign sign_b = operand_b[15];
    assign flag = sign_a ^ sign_b;
    assign exponent_a = operand_a[14:10];
    assign exponent_b = operand_b[14:10];
    assign fraction_a = operand_a[9:0];
    assign fraction_b = operand_b[9:0];
    
    reg [4:0] adjusted_exponent;
    
    wire [10:0] normalized_fraction_a;
    wire [10:0] normalized_fraction_b;
    assign normalized_fraction_a = {1'b1, fraction_a};
    assign normalized_fraction_b = {1'b1, fraction_b};
    reg [11:0] sum_fraction;
    
  // Shifting the fractions
    reg [10:0] shifted_fraction_a;
    reg [10:0] shifted_fraction_b;
    reg [9:0] normalized_sum_fraction;
    
    reg [3:0] nomal;
    
    reg [1:0] state;
    
    always@(posedge clk)begin
        if(rst)begin
            state = 0;
        end
        else begin
        case(state)
        1'b0: begin
            shifted_fraction_a = (exponent_a > exponent_b) ? normalized_fraction_a : normalized_fraction_a >> (exponent_b - exponent_a);
                                                            
            shifted_fraction_b = (exponent_a > exponent_b) ? normalized_fraction_b >> (exponent_a - exponent_b) : normalized_fraction_b;
            
            if(flag)begin //부호가 다를 경우
                if(shifted_fraction_a > shifted_fraction_b) begin //a가 b보다 클경우
                    sum_fraction = shifted_fraction_a - shifted_fraction_b;
                    sign = sign_a;
                end
                else begin  //a가 b보다 작을 경우
                    sum_fraction = shifted_fraction_b - shifted_fraction_a;
                    sign = sign_b;
                end
            end
            else begin //부호가 같을 경우
                sum_fraction = shifted_fraction_a + shifted_fraction_b;
                sign = sign_a;
            end
            
            state = 1;
        end
        1'b1: begin
        
            casex(sum_fraction)
                12'b1xxxxxxxxxxx: begin nomal = 4'b1011; end 
                12'b01xxxxxxxxxx: begin nomal = 4'b1010; end 
                12'b001xxxxxxxxx: begin nomal = 4'b1001; end 
                12'b0001xxxxxxxx: begin nomal = 4'b1000; end 
                12'b00001xxxxxxx: begin nomal = 4'b0111; end 
                12'b000001xxxxxx: begin nomal = 4'b0110; end 
                12'b0000001xxxxx: begin nomal = 4'b0101; end 
                12'b00000001xxxx: begin nomal = 4'b0100; end 
                12'b000000001xxx: begin nomal = 4'b0011; end 
                12'b0000000001xx: begin nomal = 4'b0010; end 
                12'b00000000001x: begin nomal = 4'b0001; end 
                12'b000000000001: begin nomal = 4'b0000; end 
                12'b000000000000: begin nomal = 4'b1111; end 
            endcase
            
            adjusted_exponent = (exponent_a > exponent_b) ? exponent_a : exponent_b;
                    
            case(nomal)
                4'b1011: begin adjusted_exponent = adjusted_exponent + 1; 
                        normalized_sum_fraction = sum_fraction[10:1]; end 
                4'b1010: begin adjusted_exponent = adjusted_exponent; 
                        normalized_sum_fraction = sum_fraction[9:0]; end 
                4'b1001: begin adjusted_exponent = adjusted_exponent - 1; 
                        normalized_sum_fraction = {sum_fraction[8:0], 1'b0}; end 
                4'b1000: begin adjusted_exponent = adjusted_exponent - 2; 
                        normalized_sum_fraction = {sum_fraction[7:0], 2'b00}; end
                4'b0111: begin adjusted_exponent = adjusted_exponent - 3; 
                        normalized_sum_fraction = {sum_fraction[6:0], 3'b000}; end
                4'b0110: begin adjusted_exponent = adjusted_exponent - 4; 
                        normalized_sum_fraction = {sum_fraction[5:0], 4'b0000}; end
                4'b0101: begin adjusted_exponent = adjusted_exponent - 5; 
                        normalized_sum_fraction = {sum_fraction[4:0], 5'b00000}; end
                4'b0100: begin adjusted_exponent = adjusted_exponent - 6; 
                        normalized_sum_fraction = {sum_fraction[3:0], 6'b000000}; end
                4'b0011: begin adjusted_exponent = adjusted_exponent - 7; 
                        normalized_sum_fraction = {sum_fraction[2:0], 7'b0000000}; end
                4'b0010: begin adjusted_exponent = adjusted_exponent - 8; 
                        normalized_sum_fraction = {sum_fraction[1:0], 8'b00000000}; end
                4'b0001: begin adjusted_exponent = adjusted_exponent - 9; 
                        normalized_sum_fraction = {sum_fraction[0:0], 9'b000000000}; end
                4'b0000: begin adjusted_exponent = adjusted_exponent - 10; 
                        normalized_sum_fraction = {10'b0000000000}; end
                4'b1111: begin adjusted_exponent = 0; //sub = 0
                        normalized_sum_fraction = {10'b0000000000}; end
            endcase
            
            if(operand_a == 16'b0000000000000000)
                result = operand_b;
            else if(operand_b == 16'b0000000000000000)
                result = operand_a;
            else if(operand_a == 16'b0000000000000000 && operand_b == 16'b0000000000000000)
                result = 16'b0000000000000000;
            else
                result = {sign, adjusted_exponent, normalized_sum_fraction};
            state = 0;
        end
        endcase
        end
    end
    
endmodule