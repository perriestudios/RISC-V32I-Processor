`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.02.2023 20:38:50
// Design Name: 
// Module Name: control_tb
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


module control_tb(
    );
    
    logic [3:0] aluControl;
    logic [31:0] instruction, op1, op2;
    logic clk, reset;
    
    initial begin
                  reset = 0;
                  #50 reset = 1;
                  #10 reset = 0;
          end
    
    initial begin
        clk = 1;
        forever
            begin
                #10;
                clk = ~clk;
            end
        end
        
    initial
            #1000 $finish;
    
    initial 
                begin
                    #50
                    instruction = 32'h02258513; //addi a0, a1, 34
                    #90
                    instruction = 32'h40c58533; //sub a0, a1, a2
                end
                
    controlUnit CU (
     .clk_i(clk)
    ,.reset_i(reset)
    ,.instruction_i(instruction)
    ,.write_data(0)
    ,.aluControl_o(aluControl)
    ,.op1(op1)
    ,.op2(op2)
    ,.mem_en()
    ,.mem_wr()
    ,.mem_addr()
    );
    
   
endmodule
