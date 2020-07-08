`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:25:23 09/08/2017 
// Design Name: 
// Module Name:    Jump_Control_Block 
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
module Jump_Control_Block(jmp_loc, pc_mux_sel, ins, current_address, flag_ex, interrupt, clk, reset);

input [23:0]ins;
input [7:0]current_address;
input [3:0]flag_ex;
input interrupt,clk,reset;

output [7:0]jmp_loc;
output pc_mux_sel;

wire JC, JNC, JZ, JNZ, JMP, RET;//and gate variables
reg Q1, Q2;//Ouput of two 1 bit D-Flip Flop
reg [3:0]Q3;//Ouput of 4 bits D-Flip Flop
reg [7:0]Q4;//Ouput of 8 bits D-Flip Flop
wire temp1,temp2;//for two 1 bit D-Flip Flop
wire [3:0]temp5, temp3;//for 4 bits D-Flip Flop
wire [3:0]mux1, mux2;//for two 4 bits mux
wire [7:0]temp6, temp4;//for 8 bits D-Flip Flop
wire [7:0]program_counter;
wire [7:0]mux3, mux4;//for two 8 bits mux
wire a5, a6, a7, a8;//and gate variables

and jc(JC, ~ins[19], ~ins[20], ins[21], ins[22], ins[23]);//Jump if carry
and jnc(JNC, ins[19], ~ins[20], ins[21], ins[22], ins[23]);//Jump if not carry
and jz(JZ, ~ins[19], ins[20], ins[21], ins[22], ins[23]);//Jump if zero
and jnz(JNZ, ins[19], ins[20], ins[21], ins[22], ins[23]);//Jump if not zero
and jmp(JMP, ~ins[19], ~ins[20], ~ins[21], ins[22], ins[23]);//Unconditional jump
and ret(RET, ~ins[19], ~ins[20], ~ins[21], ~ins[22], ins[23]);//return

//1 bit D-FlipFlop
and a1(temp1, interrupt, reset);
always @(posedge clk)
	Q1<=temp1;

and a2(temp2, Q1, reset);
always @(posedge clk)
	Q2<=temp2;

//4 bits D-FlipFlop
assign temp3 = (reset == 1'b1) ? ~(4'b0): (4'b0);  
assign temp5 = mux1 & temp3;
always @(posedge clk)
	Q3<=temp5;

//8 bits D-FlipFlop
assign temp4 = (reset == 1'b1) ? ~(8'b0): (8'b0) ;
assign temp6 = mux3 & temp4;
always @(posedge clk)
	Q4<=temp6;

//1 bit mux
assign mux1 = (Q2 == 1'b0) ? Q3 : flag_ex;
assign mux2 = (RET == 1'b0) ? flag_ex : Q3;

assign program_counter = current_address + 8'b00000001;

//8 bits mux
assign mux3 = (interrupt == 1'b0) ? Q4 : program_counter;

assign mux4 = (Q1 == 1'b0) ? ins[7:0] : 8'hf0;
assign jmp_loc = (RET == 1'b0) ? mux4 : Q4;

//for pc_mux_sel
and A5(a5, JC, mux2[0]);
and A6(a6, JNC, ~mux2[0]);
and A7(a7, JZ, mux2[1]);
and A8(a8, JNZ, ~mux2[1]);

or pc(pc_mux_sel, a5, a6, a7, a8, JMP, RET, Q1);

endmodule

