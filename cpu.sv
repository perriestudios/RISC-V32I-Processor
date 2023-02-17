`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.02.2023 18:27:24
// Design Name: 
// Module Name: cpu
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
module cpu(
     input clk_i,
     input reset_i
    );
    
    logic [31:0] instruction;               //IFU to CU
    
    logic [31:0] op1, op2;                  //CU to Execute
    
    logic [3:0] aluControl;                 //CU to Execute
    
    logic [31:0] executeData;               //Execute to Data Memory
    
    logic memoryEnable1, memoryWrite1, memoryEnable2, memoryWrite2;  //CU to Execute to Data Memory 
    
    logic [11:0] memoryAddress1, memoryAddress2;             //CU to Execute to Data Memory
    
    logic [31:0] registerData;              //Data Memory to Register
    
    ifu fetch (
     .clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.instruction_o(instruction)
    );
    
    controlUnit decode (
     .clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.instruction_i(instruction)
    ,.write_data(registerData)
    ,.aluControl_o(aluControl)
    ,.op1(op1)
    ,.op2(op2)
    ,.mem_en(memoryEnable1)
    ,.mem_wr(memoryWrite1)
    ,.mem_addr(memoryAddress1)
    );
    
    execute execute (
     .clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.alu_control(aluControl)
    ,.r1(op1)
    ,.r2(op2)
    ,.mem_en_i(memoryEnable1)
    ,.mem_wr_i(memoryWrite1)
    ,.mem_addr_i(memoryAddress1)
    ,.mem_en_o(memoryEnable2)
    ,.mem_wr_o(memoryWrite2)
    ,.mem_addr_o(memoryAddress2)
    ,.data_o(executeData)
    );
    
    dataMemory memory (
     .clk_i(clk_i)
    ,.reset_i(reset_i)
    ,.mem_en(memoryEnable2)
    ,.addr_i(memoryAddress2)
    ,.wr_en(memoryWrite2)
    ,.data_i(executeData)
    ,.data_o(registerData) 
    );
    
endmodule
