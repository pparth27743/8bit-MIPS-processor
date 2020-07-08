`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:55:33 08/10/2017 
// Design Name: 
// Module Name:    MIPS 
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
module ExecutionBlock(ans_ex,data_out,DM_data,flag_ex,data_in,op_dec,A,B,clk,reset);

input [7:0]A,B,data_in;
input [4:0]op_dec;
input clk,reset;

output wire [7:0]ans_ex,data_out,DM_data;
output wire [3:0]flag_ex;

wire [7:0] ans_tmp,data_out_buff;

//assign temp = ((op_dec==5'b10000) || (op_dec==5'b10001) || (op_dec==5'b10111) ||  (op_dec==5'b11000)  || (op_dec==5'b11100) || (op_dec==5'b11101) || (op_dec==5'b11110) || (op_dec==5'b11111)) ? ans_ex :  A ;

ALU alu(ans_tmp,data_out_buff,flag_ex,data_in,op_dec,A,B,ans_ex,data_out,flag_ex);

Register register(ans_ex,data_out,DM_data,ans_tmp,data_out_buff,B,reset,clk);

endmodule






module ALU(ans_tmp,data_out_buff,flag_ex,data_in,op_dec,A,B,fb_ans_ex,fb_data_out,fb_flag_ex);

input [7:0]A,B,data_in,fb_ans_ex,fb_data_out;
input [4:0]op_dec;
input [3:0]fb_flag_ex;


output wire[7:0]ans_tmp,data_out_buff;
output [3:0]flag_ex;

wire [7:0]temp, temp2, o1, o2, o3, o4, o5, o6, o7, arith_out;
wire [2:0]t1;
wire t3,C,V,P,Z;

assign t1 = B[2:0];

assign o1 = {A[7], A[7:1]};
assign o2 = {A[7], A[7], A[7:2]};
assign o3 = {A[7], A[7], A[7], A[7:3]}; 
assign o4 = {A[7], A[7], A[7], A[7], A[7:4]};	
assign o5 = {A[7], A[7], A[7], A[7], A[7], A[7:5]};
assign o6 = {A[7], A[7], A[7], A[7], A[7], A[7] ,A[7:6]};
assign o7 = {A[7], A[7], A[7], A[7], A[7], A[7] ,A[7], A[7]};

Arithmetic ar(arith_out, V, C, A, B, op_dec);

assign temp = (t1 == 3'b000) ? A: (t1 == 3'b001 ? o1 : (t1==3'b010 ? o2 : (t1 == 3'b011 ? o3 :(t1 == 3'b100 ? o4 : (t1 == 3'b101 ? o5 :(t1 == 3'b110 ? o6 : o7))))));

assign ans_tmp = ((op_dec == 5'b00000) || (op_dec == 5'b00001)) ? arith_out : ((op_dec==5'b00010) ? B : ((op_dec==5'b00100) ? A&B : ((op_dec==5'b00101) ? A|B : ((op_dec==5'b00110) ? A^B : ((op_dec==5'b00111) ? ~B : ((op_dec==5'b01000)||(op_dec==5'b01001)) ? arith_out : ((op_dec==5'b01010) ? B : ((op_dec==5'b01100) ? A&B : ((op_dec==5'b01101) ? A|B : ((op_dec==5'b01110) ? A^B : ((op_dec==5'b01111) ? ~B : ((op_dec==5'b10000) ? fb_ans_ex : ((op_dec==5'b10001) ? fb_ans_ex : ((op_dec==5'b10100) ? A : ((op_dec==5'b10101) ? A : ((op_dec==5'b10110) ? data_in :((op_dec==5'b10111) ? fb_ans_ex : ((op_dec==5'b11000) ? fb_ans_ex : ((op_dec==5'b11001) ? A<<B : ((op_dec==5'b11010) ? A>>B :((op_dec==5'b11011) ? temp :((op_dec==5'b11100) ? fb_ans_ex :((op_dec==5'b11101) ? fb_ans_ex :((op_dec==5'b11110) ? fb_ans_ex : (op_dec==5'b11111) ? fb_ans_ex : 8'b00000000)))))))))))))))))))))));

assign data_out_buff = (op_dec==5'b10111) ? A : fb_data_out;

assign Z = (ans_tmp == 8'b00000000 ?  1'b1 : 1'b0 );
assign P = ans_tmp[0] ^ ans_tmp[1] ^ ans_tmp[2] ^ ans_tmp[3] ^ ans_tmp[4] ^ ans_tmp[5] ^ ans_tmp[6] ^ ans_tmp[7];

assign flag_ex = ((op_dec == 5'b00000) || (op_dec == 5'b00001) || (op_dec == 5'b01000) || (op_dec == 5'b01001)) ?  {P,V,Z,C} : ((op_dec==5'b00010) || (op_dec==5'b00100) || (op_dec==5'b00101) || (op_dec==5'b00110) || (op_dec==5'b00111) || (op_dec==5'b01010) || (op_dec==5'b01100) || (op_dec==5'b01101) || (op_dec==5'b01110) || (op_dec==5'b01111) || (op_dec==5'b10110) || (op_dec==5'b11001) || (op_dec==5'b11010) || (op_dec==5'b11011)  ? {P,1'b0, Z ,1'b0} : ( (op_dec==5'b11100) || (op_dec==5'b11101) || (op_dec==5'b11110) || (op_dec==5'b11111) ) ? fb_flag_ex : {0,0,0,0}) ;  

endmodule




module Arithmetic(arith_out,V,C,A,B,op_dec);

input [7:0] A,B;
input [4:0]op_dec;
output [7:0]arith_out;
output V,C;

wire [6:0] carry_temp;
wire [7:0] temp,temp3;
wire ctrl;

assign ctrl = (op_dec == 5'b00000 || op_dec == 5'b01000) ? 1'b0 : 1'b1;

assign temp[0] = ((~B[0]&ctrl) | (B[0]&(~ctrl)));
assign temp[1] = ((~B[1]&ctrl) | (B[1]&(~ctrl)));
assign temp[2] = ((~B[2]&ctrl) | (B[2]&(~ctrl)));
assign temp[3] = ((~B[3]&ctrl) | (B[3]&(~ctrl)));
assign temp[4] = ((~B[4]&ctrl) | (B[4]&(~ctrl)));
assign temp[5] = ((~B[5]&ctrl) | (B[5]&(~ctrl)));
assign temp[6] = ((~B[6]&ctrl) | (B[6]&(~ctrl)));
assign temp[7] = ((~B[7]&ctrl) | (B[7]&(~ctrl)));	

full_adder fa0 (arith_out[0],	carry_temp[0], A[0], temp[0], ctrl);
full_adder fa1 (arith_out[1], carry_temp[1], A[1], temp[1], carry_temp[0]);
full_adder fa2 (arith_out[2], carry_temp[2], A[2], temp[2], carry_temp[1]);
full_adder fa3 (arith_out[3], carry_temp[3], A[3], temp[3], carry_temp[2]);
full_adder fa4 (arith_out[4],	carry_temp[4], A[4], temp[4], carry_temp[3]);
full_adder fa5 (arith_out[5], carry_temp[5], A[5], temp[5], carry_temp[4]);
full_adder fa6 (arith_out[6], carry_temp[6], A[6], temp[6], carry_temp[5]);
full_adder fa7 (arith_out[7], C, A[7], temp[7], carry_temp[6]);

xor inst(V, C, carry_temp[6]);

endmodule




module full_adder(Sum, Cout, A, B, Cin);

input A, B, Cin;
output  Sum, Cout;

assign {Cout,Sum } = A + B + Cin ;

endmodule





module Register(ans_ex,data_out,DM_data,ans_temp,data_out_buff,B,reset,clk);

input reset,clk;
input [7:0] ans_temp,data_out_buff,B;
output [7:0] ans_ex,data_out,DM_data;

Register_8bit r0(ans_ex,ans_temp,reset,clk);
Register_8bit r1(data_out,data_out_buff,reset,clk);
Register_8bit r2(DM_data,B,reset,clk);

endmodule



module Register_8bit(data_out,data_in,reset,clk);

input reset,clk;
input [7:0] data_in;
output reg [7:0] data_out;

wire [7:0]temp1;
wire [7:0]temp2;

assign temp1 = ((reset == 1'b1) ?  8'b11111111 : 8'b00000000);

assign temp2 = data_in & temp1;

always @(posedge clk)
	data_out = temp2;

endmodule

