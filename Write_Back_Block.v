`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:37:58 09/01/2017 
// Design Name: 
// Module Name:    Write_Back_Block 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

// 8 bit Register for Write Back Block
module Write_Back_Block(ans_wb,ans_dm,reset,clk);

input reset,clk;
input [7:0] ans_dm;
output reg [7:0] ans_wb;

wire [7:0]temp1;
wire [7:0]temp2;

// Reset Register or pass input to Register 
assign temp1 = ((reset == 1'b1) ?  8'b11111111 : 8'b00000000);
assign temp2 = ans_dm & temp1;                              

always @(posedge clk)
	ans_wb <= temp2;

endmodule
