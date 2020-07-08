`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:44:20 09/29/2017 
// Design Name: 
// Module Name:    Dependency_Check_Block 
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
module Dependency_Check_Block(imm ,RW_dm,op_dec,mux_sel_A,mux_sel_B,imm_sel,mem_en_ex,mem_rw_ex,mem_mux_sel_dm,ins,clk,reset);

// Inputs
input [23:0]ins;
input clk,reset;

// Outputs
output reg[7:0]imm;
output reg [4:0]RW_dm, op_dec;
output [1:0]mux_sel_A, mux_sel_B;
output reg imm_sel, mem_en_ex, mem_rw_ex, mem_mux_sel_dm;


wire [18:0] t2,Ext;
wire [7:0] temp8;
wire [4:0] temp1,temp2,temp3,temp4,temp5,temp6,temp7;
wire temp9;
wire JMP, Cond_Jmp, LD1, Imme, LD2, ST;
wire t1,t3,t4,t5,t6,t7,t8,t9;
wire c1,c2,c3,c4,c5,c6;
wire nr;

reg [4:0] r2,r3,r5,rA,rB;
reg Q1,Q2,Q3,Q4,Q6;


// Opcode
assign temp1 = ins[23:19] & ((reset == 1'b1) ?  ~(5'b0) : 5'b0); 
always @(posedge clk)
	op_dec<=temp1;

// Jump, Cond_Jump, LD
and jmp(JMP, ins[23], ins[22], ~ins[21], ~ins[20], ~ins[19]);
and cond_jmp(Cond_Jmp, ins[23], ins[22], ins[21]);
and ld1(LD1, ins[23], ~ins[22], ins[21], ~ins[20], ~ins[19], ~Q1);

// 1 bit Filp-flop
and a1(t1, LD1, reset);
always @(posedge clk)
	Q1<=t1;

nor nor1(nr1,JMP,Cond_Jmp,Q1);

// Extend
assign Ext = (nr1 == 1'b1) ? ~(19'b0): 19'b0;

assign t2 =  ins[18:0] & Ext;
	
// This Register contain ins[13:9]
assign temp2 = t2[13:9] & ((reset == 1'b1) ?  ~(5'b0) : 5'b0); 
always @(posedge clk)
	rA<=temp2;
	
// This Register contain ins[8:4]	
assign temp3 = t2[8:4] & ((reset == 1'b1) ?  ~(5'b0) : 5'b0); 
always @(posedge clk)
	rB<=temp3;

// Register chain
assign temp4 = t2[18:14] & ((reset == 1'b1) ?  ~(5'b0) : 5'b0);
always @(posedge clk)
	r2<=temp4;
	
assign temp5 = r2 & ((reset == 1'b1) ?  ~(5'b0) : 5'b0);
always @(posedge clk)
	r3<=temp5;
	
assign temp6 =  r3 & ((reset == 1'b1) ?  ~(5'b0) : 5'b0);	
always @(posedge clk)
	RW_dm<=temp6;
	
assign temp7 = RW_dm & ((reset == 1'b1) ?  ~(5'b0) : 5'b0);
always @(posedge clk)
	r5<=temp7;
	
// Comparator	
assign c1 = (r3 == rA)? 1'b1 : 1'b0; 
assign c2 = (RW_dm == rA)? 1'b1 : 1'b0;
assign c3 = (r5 == rA)? 1'b1 : 1'b0;

and a3(t3,~c1,c2);
and a4(t4,~c1,~c2,c3);

// Priority Encoder
Pri_encoder p1(mux_sel_A,{t4, t3, c1, 1'b1});

// Comparator
assign c4 = (r3 == rB)? 1'b1 : 1'b0;
assign c5 = (RW_dm == rB)? 1'b1 : 1'b0;
assign c6 = (r5 == rB)? 1'b1 : 1'b0;	

and a5(t5,~c4,c5);
and a6(t6,~c4,~c5,c6);

// Priority Encoder
Pri_encoder p2(mux_sel_B,{t6, t5, c4, 1'b1});





// For Immediate
and immediate(Imme, ~ins[23], ins[22]);

// imm_sel
assign temp9 = Imme & ((reset == 1'b1) ?  ~(1'b0) : 1'b0);
always @(posedge clk)
	imm_sel<=temp9;

// imm
assign temp8 = ins[8:1] & ((reset == 1'b1) ?  ~(8'b0) : 8'b0);
always @(posedge clk)
	imm<=temp8;





// Ld, ST
and ld2(LD2, ins[23], ~ins[22], ins[21], ~ins[20], ~ins[19]);
and st(ST, ins[23], ~ins[22], ins[21], ~ins[20], ins[19]);
 
assign temp10 = ins[19] & ((reset == 1'b1) ?  ~(1'b0) : 1'b0);
always @(posedge clk)
	Q2<=temp10;
	
and a7(t7,LD2,~Q3);

assign temp11 = t7 & ((reset == 1'b1) ?  ~(1'b0) : 1'b0);
always @(posedge clk)
	Q3<=temp11;

assign temp12 = ST & ((reset == 1'b1) ?  ~(1'b0) : 1'b0);
always @(posedge clk)
	Q4<=temp12;
	
or or1(t8,Q3,Q4);
and a8(t9,t8,~Q2);

// mem_rw_ex
assign temp13 = Q2 & ((reset == 1'b1) ?  ~(1'b0) : 1'b0);
always @(posedge clk)
	mem_rw_ex<=temp13;

assign temp14 = t9 & ((reset == 1'b1) ?  ~(1'b0) : 1'b0);
always @(posedge clk)
	Q6<=temp14;
	
// mem_en_ex
assign temp15 = t8 & ((reset == 1'b1) ?  ~(1'b0) : 1'b0);
always @(posedge clk)
	mem_en_ex<=temp15;

// mem_mux_sel_dm
assign temp16 = Q6 & ((reset == 1'b1) ?  ~(1'b0) : 1'b0);
always @(posedge clk)
	mem_mux_sel_dm<=temp16;

	
endmodule


module Pri_encoder(y,w);

input [3:0] w;
output reg[1:0] y;

always @(w)
begin
	casex(w)
		4'b1xxx: y = 2'b11;
		4'b01xx: y = 2'b10;
		4'b001x: y = 2'b01;
		4'b0001: y = 2'b00;
		default: y = 2'bxx;
	endcase
	
end
endmodule

