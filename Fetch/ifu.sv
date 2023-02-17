`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.02.2023 16:13:03
// Design Name: 
// Module Name: ifu
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
module ifu(
    input clk_i
    ,input reset_i
    ,output logic [31:0] instruction_o
    );
    
 logic[31:0] PC;
 logic [2:0] clkCount;
 initial begin
 PC = 32'b0;  // 32-bit program counter is initialized to zero
 clkCount = 3'b0;
 end   
        // Initializing the instruction memory block
       programMemory progMem(
        .addr_i(PC[11:0])
       ,.data_o(instruction_o)
       );
        logic first;
        always @(posedge clk_i, posedge reset_i)
        begin
            if (reset_i == 1) begin
                PC <= 0;
                clkCount <= 0;
                first <= 1;
            end
            /*begin
                if(reset_i == 1)  //If reset is one, clear the program counter
                PC <= 0;
                else
                PC <= PC+4;
            end */   // Increment program counter on positive clock edge
            else if (clkCount == 4) begin
                clkCount <= 0;
                first <= 0;
            end
            else if (clkCount == 0 & first == 0) begin
                PC <= PC + 4;
                clkCount <= clkCount + 1'b1;
            end
            else
                clkCount <= clkCount + 1'b1;
        end
endmodule
