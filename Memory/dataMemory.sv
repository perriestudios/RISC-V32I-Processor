`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2023 01:49:03
// Design Name: 
// Module Name: dataMemory
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


module dataMemory(
    input clk_i,
    input reset_i,
    input mem_en,
    input [11:0] addr_i,
    input wr_en,
    input [31:0] data_i,
    output logic [31:0] data_o
    );
    
    reg [7:0] memory [4095:0];
    
    logic [2:0] clkCount;
      initial begin
          clkCount = 3'b0;
      end
    
    always @ (posedge clk_i, posedge reset_i)
    begin
        if (reset_i == 1) begin
            clkCount <= 0;
        end
        else if (clkCount == 4)
            clkCount <= 0;
        else if(clkCount == 3 & wr_en & mem_en)
            begin
                memory[addr_i] <= data_i[7:0];
                memory[addr_i + 1] <= data_i[15:8];
                memory[addr_i + 2] <= data_i[23:16];
                memory[addr_i + 3] <= data_i[31:24];
            end    
        else if(clkCount == 3 & mem_en)
            begin
                data_o[7:0] <= memory[addr_i];
                data_o[15:8] <= memory [addr_i + 1];
                data_o[23:16] <= memory [addr_i + 2];
                data_o[31:24] <= memory [addr_i + 3];
            end
        else if(clkCount == 3)
            data_o <= data_i;
        else
            clkCount <= clkCount + 1'b1;
    end
    
endmodule
