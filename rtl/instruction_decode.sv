
// Extract fields from an instruction word and assert control signals.


`include "cpudefs.sv"



module instruction_decode(

    input [31:0] i_InstructionWord,

    output [6:0] o_Opcode,
    output [31:0] o_ImmediateData,

    output [4:0] o_rd,
    output [4:0] o_rs1,
    output [4:0] o_rs2,

    // output [2:0] o_funct3,
    // output [6:0] o_funct7

    output o_IllegalInstruction

);





    logic [4:0] w_Shamt;
    logic [6:0] w_Funct7;
    logic [2:0] w_Funct3;
    logic [4:0] w_rs2;
    logic [4:0] w_rs1;
    logic [4:0] w_rd;
    logic [5:0] w_Opcode;
    logic [1:0] w_OpcodeSuffix;
    always_comb begin
        w_Funct7        = i_InstructionWord[31:25];
        w_rs2           = i_InstructionWord[24:20];
        w_rs1           = i_InstructionWord[19:15];
        w_Funct3        = i_InstructionWord[14:12];
        w_rd            = i_InstructionWord[11:7];
        w_Opcode        = i_InstructionWord[6:2];
        w_OpcodeSuffix  = i_InstructionWord[1:0];

        w_Shamt = w_rs2;
    end




    // TODO: FENCE instruction

    logic w_AluOP;
    logic w_AUIPC
    logic w_Branch;
    logic w_JAL;
    logic w_JALR;
    logic w_LUI;
    logic w_STORE;
    logic w_LOAD;

    // TODO: Other SYSTEM instructions
    logic w_SYSTEM;
    logic w_SYSTEM_EBREAK;

    logic w_MemRead;
    logic w_MemWrite;
    logic [1:0] w_MemAlignment;
    logic w_MemReadUnsigned;

    logic w_RegWrite;

    logic w_AluSource1;
    logic w_AluSource2;

    logic w_IllegalInstruction;
    always_comb begin


        w_MemReadUnsigned = w_Funct3[2];
        w_MemAlignment = w_Funct3[1:0];



        if (w_Opcode == OPCODE_OP) begin
            // Use Funct7/shamt
        end
        else if (w_Opcode == OPCODE_OP_IMM) begin
            // Use Funct3
        end
        else begin
            // ???
        end

        w_AUIPC = w_Opcode == OPCODE_AUIPC;
        w_JAL = w_Opcode == OPCODE_JAL;
        w_JALR = w_Opcode == OPCODE_JALR;
        w_LUI = w_Opcode == OPCODE_LUI;

        w_LOAD = w_Opcode ==

        w_SYSTEM = w_Opcode == OPCODE_SYSTEM;
        w_SYSTEM_EBREAK = w_Opcode[20];

        w_IllegalInstruction = (w_OpcodeSuffix != 2'b11) || w_Opcode inside {
            // Used for RV64
            OPCODE_OP_32, OPCODE_OP_IMM_32,
            // Used for Extension "A"
            OPCODE_AMO,
            // Used for Extension "F"
            OPCODE_LOAD_FP, OPCODE_STORE_FP, OPCODE_OP_FP,
            OPCODE_MADD, OPCODE_MSUB, OPCODE_NMADD, OPCODE_NMSUB,
            // Unused custom opcodes
            OPCODE_CUSTOM_0, OPCODE_CUSTOM_1, OPCODE_CUSTOM_2, OPCODE_CUSTOM_3,
            // Reserved opcodes
            OPCODE_RESERVED_0, OPCODE_RESERVED_1, OPCODE_RESERVED_2
        };


        // Set control signal outputs
        w_MemWrite = w_STORE;
        w_MemRead = w_LOAD;


        // TODO: Use decoded opcode to determine which immediate format to use
        // The immediate bits are different depending on instruction type.



    end



    assign o_IllegalInstruction = w_IllegalInstruction;
    assign o_rs2 = w_rs2;
    assign o_rs1 = w_rs1;
    assign o_rd = w_rd;


endmodule
