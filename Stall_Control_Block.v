`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:37:41 09/01/2017 
// Design Name: 
// Module Name:    Stall_Control_Block 
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
module Stall_Control_Block(Stall, Stall_pm, ins, clk, reset);

input [23:0]ins;
input clk, reset;

output Stall;
output reg Stall_pm;

wire HLT, Ld, JUMP;	//And gate instances
reg Q1,Q2,Q3;	//Output of the flip-flop
wire temp, temp1, temp2, temp3;	//Input of the filp-flop

and hlt(HLT, ins[23], ~ins[22], ~ins[21], ~ins[20], ins[19]);
and ld(Ld, ins[23], ~ins[22], ins[21], ~ins[20], ~ins[19], ~Q1);
and jump(JUMP, ins[23], ins[22], ins[21], ~Q3);

//D flip-flop
and a1(temp,Ld,reset);	// Reset D filp-flop or pass input to D filp-flop 
always @(posedge clk)
	Q1<=temp;

//D flip-flop
and a2(temp1,JUMP,reset); 	// Reset D filp-flop or pass input to D filp-flop
always @(posedge clk)
	Q2<=temp1;

//D flip-flop
and a3(temp2,Q2,reset);		// Reset D filp-flop or pass input to D filp-flop
always @(posedge clk)
	Q3<=temp2;
	
// Stall_pm
and a4(temp3,Stall,reset);	// Reset D filp-flop or pass input to D filp-flop
always @(posedge clk)
	Stall_pm<=temp3;

//Stall
or o1(Stall, HLT, Ld, JUMP);

endmodule
