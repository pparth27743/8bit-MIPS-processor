`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:30:34 08/11/2017 
// Design Name: 
// Module Name:    PCIM 
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
module PCIM(ins,Current_Address,jmp_loc,pc_mux_sel,Stall,Stall_pm,reset,clk);

input [7:0] jmp_loc;
input pc_mux_sel,Stall,Stall_pm,reset,clk;

output [23:0] ins;
output [7:0] Current_Address;

wire [7:0] CAJ, CAR, Hold_Address, Next_Address,IA;
wire [23:0] ins_pm, PM_out, ins_prv;

// 8 bit Mux
assign CAJ = (Stall == 1'b1) ?  Hold_Address  : Next_Address   ;  // Which is lead by Stall 
assign CAR = (pc_mux_sel == 1'b1) ?  jmp_loc  : CAJ  ;				// Which is lead by pc_mux_sel
assign Current_Address = (reset == 1'b1) ? CAR : 8'b0 ;				// Which is lead by reset

// Program Memory
Program_Mem ROM (
  .clka(clk), // input clka
  .addra(Current_Address), // input [7 : 0] addra
  .douta(PM_out) // output [23 : 0] douta
);


// 24 Bit Mux 
assign ins_pm = (Stall_pm == 1'b1) ? ins_prv :PM_out;				// Which is lead by Stall_pm
assign ins = (reset == 1'b1) ? ins_pm : 24'b0;						// Which is lead by reset

assign IA =  Current_Address + 8'b00000001;							// Address add by 1

// Current_Address and add by 1 Address store into Program counter.
Program_Counter PC(Hold_Address, Next_Address,Current_Address,IA,reset,clk);				

// Store the instuctions.
Register_24bit R(ins_prv,ins,reset,clk);// 24 bit register to store instructions.


endmodule


// Program Counter  Module for storing Hold_Address and Next_Address
module Program_Counter(Hold_Address, Next_Address,in1,in2,reset,clk);

input reset,clk;
input [7:0] in1,in2;
output [7:0] Hold_Address, Next_Address;

Register_8bit r1(Hold_Address,in1,reset,clk);								// 8 bit regisster for  
Register_8bit r2(Next_Address,in2,reset,clk);

endmodule



// 24 bit Register for Storing instructions
module Register_24bit(out,in,reset,clk);       							

input reset,clk;
input [23:0] in;
output reg [23:0] out;

wire [23:0]temp1;
wire [23:0]temp2;

// Reset register 
assign temp1 = (reset == 1'b1) ? ~(24'b0): (24'b0) ;    
assign temp2 = in & temp1;

always @(posedge clk)
	out <= temp2;

endmodule

