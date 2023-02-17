`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2023 00:02:04
// Design Name: 
// Module Name: programMemory
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


module programMemory(
    input [11:0] addr_i,
    output logic [0:31] data_o //starting with 0 to 31 for endianess
    );
    
    reg [7:0] memory[4095:0];
    
    initial
        begin
            $readmemh("test.mem", memory);
        end
        
    assign data_o = {memory[addr_i+3],memory[addr_i+2],memory[addr_i+1],memory[addr_i]};
    /*always_comb 
        begin
            data_o[0:7] = memory[addr_i];
            data_o[8:15] = memory[addr_i+1];
            data_o[16:23] = memory[addr_i+2];
            data_o[24:31] = memory[addr_i+3];
        end */
endmodule
