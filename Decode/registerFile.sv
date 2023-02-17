`timescale 1ns / 1ps

module registerFile(
      input write_enable
    , input [4:0] rs1_address
    , input [4:0] rs2_address
    , input [4:0] write_address
    , input [31:0] write_data
    , output logic [31:0] rs1
    , output logic [31:0] rs2
    );
    
    //integer w, r1, r2;

    reg [31:0] x[0:31];
    
    always_comb
    begin
      x[0] = 32'b0;
      if (write_enable)
      begin               
      //w = write_address;
      x[write_address] = write_data;
      end
      rs1 = x[rs1_address];
      rs2 = x[rs2_address];
    end
    
    /*always_ff @ (posedge clk_i)
        begin
        r1 <= rs1_address;
        r2 <= rs2_address;
        rs1 <= x[r1];
        rs2 <= x[r2];
        end*/
endmodule