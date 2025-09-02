`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/11 17:25:18
// Design Name: 
// Module Name: signed_floating_point_multiplier
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



module signed_floating_point_multiplier(
  input wire [15:0] operand_a,
  input wire [15:0] operand_b,
  input clk,
  input rst,
  output reg [15:0] result
);

  wire sign_a;
  wire sign_b;
  wire sign;
  wire [4:0] exponent_a;
  wire [4:0] exponent_b;
  wire [9:0] fraction_a;
  wire [9:0] fraction_b;

  // Splitting the operands into sign, exponent, and fraction
  assign sign_a = operand_a[15];
  assign sign_b = operand_b[15];
  assign sign = sign_a ^ sign_b;
  assign exponent_a = operand_a[14:10];
  assign exponent_b = operand_b[14:10];
  assign fraction_a = operand_a[9:0];
  assign fraction_b = operand_b[9:0];


  // Adjusting the exponent
  reg [4:0] adjusted_exponent;
  reg [9:0] shifted_fraction;

  // Multiplying the fractions
  reg [21:0] multiplied_fraction;
  
  reg flag;
  
  always@(posedge clk)begin
    multiplied_fraction = {1'b1, fraction_a} * {1'b1, fraction_b};
    if(multiplied_fraction[21] == 0)
        flag = 0;
    else 
        flag = 1;
  
    adjusted_exponent = flag ? (exponent_a + exponent_b - 5'b01111 + 1'b1) : (exponent_a + exponent_b - 5'b01111);
    shifted_fraction = flag ? (multiplied_fraction[20:11]) : (multiplied_fraction[19:10]);
    
    if(operand_a == 16'b0000000000000000 || operand_b == 16'b0000000000000000)begin
        result = 16'b0000000000000000;
    end
    else begin
        result = {sign, adjusted_exponent, shifted_fraction};
    end
    end
endmodule
