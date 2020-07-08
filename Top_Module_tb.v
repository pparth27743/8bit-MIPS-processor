`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:34:08 10/11/2017
// Design Name:   Top_Module_Block
// Module Name:   E:/study/xilinx/MIPS2/Topmodule_tb.v
// Project Name:  MIPS2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Top_Module_Block
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Topmodule_tb;

	// Inputs
	reg [7:0] data_in;
	reg clk;
	reg interrupt;
	reg reset;

	// Outputs
	wire [7:0] data_out;

	// Instantiate the Unit Under Test (UUT)
	Top_Module_Block uut (
		.data_in(data_in), 
		.clk(clk), 
		.interrupt(interrupt), 
		.reset(reset), 
		.data_out(data_out)
	);

	initial begin
		// Initialize Inputs
		data_in = 0;
		clk = 0;
		interrupt = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		data_in = 0;
		interrupt = 0;
		clk = 0;
		reset = 1;
		#200; reset = 0;
		#500; reset = 1;
end
	always

		#500 clk = ~clk;
      
endmodule
