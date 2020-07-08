`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:26:06 08/18/2017 
// Design Name: 
// Module Name:    Register_Bank_Block 
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
module Register_Bank_Block(A, B, clk, ans_dm, ans_ex, ans_wb, imm, RW_dm, mux_sel_A, mux_sel_B, imm_sel, ins);

input [23:0]ins;
input [7:0]ans_ex, ans_wb, ans_dm, imm;
input [1:0] mux_sel_A, mux_sel_B;
input [4:0]RW_dm;
input imm_sel, clk;

output [7:0]A, B;

reg [7:0] AR,BR;
wire [7:0]BI;
reg [7:0]Register_Bank[0:31];//32x8 Memory

always @(posedge clk)
begin
	AR <= Register_Bank[ins[13:9]];
	BR <= Register_Bank[ins[8:4]];
	Register_Bank[RW_dm] <= ans_dm;
end
	
assign A = (mux_sel_A==2'b00) ? AR : ((mux_sel_A==2'b01) ? ans_ex : ((mux_sel_A==2'b10) ? ans_dm : ans_wb));
assign BI = (mux_sel_B==2'b00) ? BR : ((mux_sel_B==2'b01) ? ans_ex : ((mux_sel_B==2'b10) ? ans_dm : ans_wb));
assign B = (imm_sel==2'b00) ? BI : imm;

endmodule
