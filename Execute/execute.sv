`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.02.2023 19:53:39
// Design Name: 
// Module Name: execute
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module execute(
    input clk_i
  , input reset_i
  , input [31:0] r1
  , input [31:0] r2
  , input [3:0] alu_control
  , input mem_en_i
  , input mem_wr_i
  , input [11:0] mem_addr_i
  , output logic [31:0] data_o
  , output logic mem_en_o
  , output logic mem_wr_o
  , output logic [11:0] mem_addr_o
  );
  
  logic [31:0] alu_result;
  
  alu ALU_module(
      .r1(r1),
      .r2(r2),
      .alu_control(alu_control),
      .alu_result(alu_result)
      );
      
  logic [2:0] clkCount;
      
  initial begin
      clkCount = 3'b0;
  end
  
  always @ (posedge clk_i, posedge reset_i)
  if (reset_i == 1) begin
    clkCount <= 0;
  end
  else if (clkCount == 4)
    clkCount <= 0;
  else if (clkCount == 2)
  begin
      data_o <= alu_result;
      mem_en_o <= mem_en_i;
      mem_wr_o <= mem_wr_i;
      mem_addr_o <= mem_addr_i;
  end
  else
      clkCount <= clkCount + 1'b1;
endmodule
