`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:10:29 08/18/2017 
// Design Name: 
// Module Name:    Data_Memory_Block 
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
module Data_Memory_Block(ans_dm, ans_ex, DM_data, mem_rw_ex, mem_en_ex, mem_mux_sel_dm, reset, clk);

input [7:0]ans_ex, DM_data;
input mem_rw_ex, mem_en_ex, mem_mux_sel_dm, reset, clk;

output [7:0]ans_dm;

wire [7:0]DM_out;
reg [7:0]Ex_out;
reg [7:0]ans_reg;

//For register
wire [7:0]temp1, temp2;

Data_Memory your_instance_name (
  .clka(clk), // input clka
  .ena(mem_en_ex), // input ena
  .wea(mem_rw_ex), // input [0 : 0] wea
  .addra(ans_ex), // input [7 : 0] addra
  .dina(DM_data), // input [7 : 0] dina
  .douta(DM_out) // output [7 : 0] douta
);

assign temp1 = ((reset == 1'b1) ?  8'b11111111 : 8'b00000000);
assign temp2 = ans_ex & temp1;

always @(posedge clk)
begin
	Ex_out <= temp2;
end

assign ans_dm = (mem_mux_sel_dm==2'b00) ? Ex_out : DM_out;


endmodule




