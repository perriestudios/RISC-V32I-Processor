module controlUnit(
    input clk_i,
    input reset_i,
    input [31:0] instruction_i,
    //input opcode[6:0],
    //input funct7[6:0],
    //input funct3[2:0],
    input [31:0] write_data,
    //input write_enable,
    output logic [3:0] aluControl_o,
    output logic [31:0] op1,
    output logic [31:0] op2,
    output logic mem_en,
    output logic mem_wr,
    output logic [11:0] mem_addr
);

logic [6:0] opcode, funct7;
logic [2:0] funct3;
logic [31:0] rs1, rs2, rf_writeData;
logic [3:0] alu_control;

//logic [3:0] add_rs1, add_rs2;

logic [4:0] rs1_address, rs2_address, rf_writeAddress;
logic [11:0] memoryAddress;
logic rf_writeEnable;

registerFile RF(
     .write_enable(rf_writeEnable)
    ,.rs1_address(rs1_address)
    ,.rs2_address(rs2_address)
    ,.write_address(rf_writeAddress)
    ,.write_data(rf_writeData)
    ,.rs1(rs1)
    ,.rs2(rs2)
);

assign opcode = instruction_i[6:0];
assign funct7 = instruction_i[31:25];
assign funct3 = instruction_i[14:12];

logic [2:0] clkCount;

initial begin
    clkCount = 3'b0;
end

always_comb
    begin
        if (opcode == 7'b0110011) 
        begin // R-type instructions
            //regwrite_control = 1;
            case(funct3)
            0: begin
                if(funct7==0)
                alu_control= 4'b0000; //ADD
                else if(funct7==32)
                alu_control= 4'b1000; //SUB
            end
            1: alu_control= 4'b0001; //SLL
            2: alu_control= 4'b0010; //SLT
            3: alu_control= 4'b0011;//SLTU
            4: alu_control= 4'b0100; // XOR
            5: begin
                if(funct7==0)
                alu_control= 4'b0101; //SRL
                else if(funct7==32)
                alu_control= 4'b1001; //SRA
            end
            6: alu_control= 4'b0110; // OR
            7: alu_control= 4'b0111; // AND
            endcase
            rs1_address = instruction_i[19:15];
            rs2_address = instruction_i[24:20];
            rf_writeAddress = instruction_i [11:7];
            rf_writeEnable = 1;
        end

        if (opcode == 7'b0010011) 
        begin // I-type instructions
       // regwrite_control = 1;
            case(funct3)
            0: alu_control= 4'b0000; //ADDI
            1: alu_control= 4'b0001; //SLLI
            2: alu_control= 4'b0010; //SLTI
            3: alu_control= 4'b0011;//SLTIU
            4: alu_control= 4'b0100; // XORI
            5: begin
                if(funct7==0)
                alu_control=  4'b1011; //SRLI
                if(funct7==32)
                alu_control=  4'b1100; //SRAI
            end
            6: alu_control= 4'b0110; // ORI
            7: alu_control= 4'b0111; // ANDI
            endcase

            rs1_address = instruction_i[19:15];
            rf_writeAddress = instruction_i [11:7];
            rf_writeEnable = 1;
        end

        if (opcode == 7'b0110111)  //LUI
           alu_control=  4'b1101;
           rf_writeAddress = instruction_i [11:7];
           rf_writeEnable = 1;
        
        if (opcode == 7'b0000011)  //Load
           begin
           //alu_control= 4'b0000; //ADDI
           rs1_address = instruction_i[19:15];
           //write_address = instruction_i[11:7];
           //write_enable=1;
           memoryAddress = rs1[11:0] + instruction_i [31:20];
           rf_writeAddress = instruction_i [11:7];
           rf_writeEnable = 1;
           end

        if (opcode == 7'b0100011)  //Store
           begin
           alu_control= 4'b0000; //ADD
           //rs1_address = instruction_i[19:15];
           //write_address = instruction_i[11:7];
           //write_enable=1;
           rs1_address = instruction_i[19:15];
           memoryAddress = rs1[11:0] + {instruction_i [31:25],instruction_i [11:7]};
           rs2_address = instruction_i[24:20];
           end

    end


    always @ (posedge clk_i, posedge reset_i)
    begin
        if (reset_i == 1) begin
            clkCount <= 0;
        end
        else if (clkCount == 4) begin
            rf_writeData <= write_data;
            clkCount <= 0;
        end
        else if (clkCount == 1)
        begin
            clkCount <= clkCount + 1'b1;
            if (opcode == 7'b0110011)    //ALU
            begin
                op1 <= rs1;
                op2 <= rs2;
                aluControl_o <= alu_control;
                mem_en <= 0;
                mem_wr <= 0;
                mem_addr <= 0;
                
            end
            else if(opcode == 7'b0010011)  //ALU
            begin
                op1 <= rs1;
                op2 <= instruction_i[31:20];
                aluControl_o <= alu_control;
                mem_en <= 0;
                mem_wr <= 0;
                mem_addr <= 0;
            end
            else if(opcode == 7'b0110111)  //ALU
            begin
                op1 <= instruction_i[31:12];
                op2 <= 0;
                aluControl_o <= alu_control;
                mem_en <= 0;
                mem_wr <= 0;
                mem_addr <= 0;
            end
            else if(opcode == 7'b0000011) //Load
            begin
                op1 <= 0;
                op2 <= 0;
                aluControl_o <= 0;
                mem_en <= 1;
                mem_wr <= 0;
                mem_addr <= memoryAddress;
                //op1 <= rs1;
                //op2 <= instruction_i[31:20];
            end
           
           else if(opcode == 7'b0100011) //Store
            begin
                  op1 <= rs2;
                  op2 <= 0;
                  aluControl_o <= alu_control;
                  mem_en <= 1;
                  mem_wr <= 1;
                  mem_addr <= memoryAddress;
                //op1 <= rs1;
                //op2 <= {instruction_i[31:25], instruction_i[11:7]};
            end
            end
            else
               clkCount <= clkCount + 1'b1;
        end
endmodule