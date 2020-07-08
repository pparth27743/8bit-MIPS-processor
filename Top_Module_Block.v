`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:46:49 09/29/2017 
// Design Name: 
// Module Name:    Top_Module_Block 
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
module Top_Module_Block(data_in,clk,interrupt,reset,data_out);


wire [23:0] ins;
wire [7:0] A;
wire [7:0] B;
wire [7:0] Current_Address;
wire [7:0] ans_ex;
wire [7:0] ans_dm;
wire [7:0] ans_wb;
wire [1:0] mux_sel_A;
wire [1:0] mux_sel_B;
wire imm_sel;
output [7:0] data_out;

input [7:0] data_in;
input clk;
input interrupt;
input reset;

wire [7:0] jmp_loc;
wire pc_mux_sel,Stall,Stall_pm,clk;
wire [7:0]DM_data;
wire mem_rw_ex, mem_en_ex, mem_mux_sel_dm;
wire [4:0]op_dec;
wire [3:0]flag_ex;
wire [7:0]imm;
wire [4:0]RW_dm;


PCIM PM(ins,Current_Address,jmp_loc,pc_mux_sel,Stall,Stall_pm,reset,clk);
Data_Memory_Block DM(ans_dm, ans_ex, DM_data, mem_rw_ex, mem_en_ex, mem_mux_sel_dm, reset, clk);
ExecutionBlock EB(ans_ex,data_out,DM_data,flag_ex,data_in,op_dec,A,B,clk,reset);
Jump_Control_Block JC(jmp_loc, pc_mux_sel, ins, Current_Address, flag_ex, interrupt, clk, reset);
Stall_Control_Block SC(Stall, Stall_pm, ins, clk, reset);
Register_Bank_Block RB(A, B, clk, ans_dm, ans_ex, ans_wb, imm, RW_dm, mux_sel_A, mux_sel_B, imm_sel, ins);
Write_Back_Block WB(ans_wb,ans_dm,reset,clk);
Dependency_Check_Block DC(imm ,RW_dm,op_dec,mux_sel_A,mux_sel_B,imm_sel,mem_en_ex,mem_rw_ex,mem_mux_sel_dm,ins,clk,reset);



endmodule
