
`include "decode_unit.svh"
`include "pipeline_signals.svh"
`include "alu.svh"
`include "stage_execution.svh"
`include "data_cache.svh"
`include "stage_writeback.svh"


module decode_unit (
    input [31:0] i_InstructionWord,

    output EX_Control_t o_EX_Control,
    output MEM_Control_t o_MEM_Control,
    output WB_Control_t o_WB_Control,
    output RegisterIDs_t o_RegisterIDs,
    output [31:0] o_Immediate,

    output o_Branch
    output o_Jump,
    output o_JALR,

    output o_EnvCall,
    output o_EnvBreak,

    output o_IllegalInstruction
);

    logic [11:0] w_Funct12;
    logic [2:0] w_Funct3;
    logic [4:0] w_Opcode;
    logic [1:0] w_OpcodeSuffix;

    logic [31:0] w_IType_Immediate;
    logic [31:0] w_SType_Immediate;
    logic [31:0] w_BType_Immediate;
    logic [31:0] w_UType_Immediate;
    logic [31:0] w_JType_Immediate;

    assign w_Funct12           = i_InstructionWord[31:20];
    assign o_RegisterIDs.rs2   = i_InstructionWord[24:20];
    assign o_RegisterIDs.rs1   = i_InstructionWord[19:15];
    assign w_Funct3            = i_InstructionWord[14:12];
    assign o_RegisterIDs.rd    = i_InstructionWord[11:7];
    assign w_Opcode            = i_InstructionWord[6:2];
    assign w_OpcodeSuffix      = i_InstructionWord[1:0];

    assign w_IType_Immediate = {{21{i_InstructionWord[31]}}, i_InstructionWord[30:20]};
    assign w_SType_Immediate = {{21{i_InstructionWord[31]}}, i_InstructionWord[30:25], i_InstructionWord[11:7]};
    assign w_BType_Immediate = {{20{i_InstructionWord[31]}}, i_InstructionWord[7], i_InstructionWord[30:25], i_InstructionWord[11:8], 1'b0};
    assign w_UType_Immediate = {i_InstructionWord[31:12], 12'b0};
    assign w_JType_Immediate = {{12{i_InstructionWord[31]}}, i_InstructionWord[19:12], i_InstructionWord[20], i_InstructionWord[30:25], i_InstructionWord[24:21], 1'b0};


    always_comb begin
        o_IllegalInstruction = w_OpcodeSuffix != 2'b11;

        // Default values
        //
        o_Jump = 0;
        o_Branch = 0;
        o_JALR = 0;
        //
        o_EX_Control.AluSrc1 = `ALUSRC1_RS1;
        o_EX_Control.AluSrc2 = `ALUSRC2_RS2;
        o_EX_Control.AluOp = w_Funct3;
        o_EX_Control.AluOpAlt = i_InstructionWord[30];
        //
        o_MEM_Control.MemRead = 0;
        o_MEM_Control.MemWrite = 0;
        o_MEM_Control.MemMode = w_Funct3;
        //
        o_WB_Control.WritebackSrc = `WBSRC_ALU;
        o_WB_Control.RegWrite = 0;
        //
        o_Immediate = 32'h00000000;

        case (w_Opcode)

            `OPCODE_OP : begin
                o_WB_Control.RegWrite = 1;
            end

            `OPCODE_OP_IMM : begin
                o_WB_Control.RegWrite = 1;
                o_EX_Control.AluSrc2 = `ALUSRC2_IMM;
                o_Immediate = w_IType_Immediate;

                // The only OP_IMM instruction for which this
                // applies is SRAI. This will cause problems for
                // e.g. ADDI, where with an immediate with the right
                // bit set will subtract instead of add.
                o_EX_Control.AluOpAlt = o_EX_Control.AluOpAlt && (o_EX_Control.AluOp == `ALUOP_SRL);
            end

            `OPCODE_AUIPC : begin
                o_WB_Control.RegWrite = 1;
                o_EX_Control.AluSrc1 = `ALUSRC1_PC;
                o_EX_Control.AluSrc2 = `ALUSRC2_IMM;
                o_Immediate = w_UType_Immediate;
            end

            `OPCODE_LUI : begin
                o_WB_Control.RegWrite = 1;
                o_EX_Control.AluSrc1 = `ALUSRC1_CONST_0;
                o_EX_Control.AluSrc2 = `ALUSRC2_IMM;
                o_Immediate = w_UType_Immediate;
            end

            `OPCODE_LOAD : begin
                o_WB_Control.RegWrite = 1;
                o_MEM_Control.MemRead = 1;
                o_EX_Control.AluOp = `ALUOP_ADD;
                o_EX_Control.AluOpAlt = `ALUOP_ALT_ADD;
                o_EX_Control.AluSrc2 = `ALUSRC2_IMM;
                o_WB_Control.WritebackSrc = `WBSRC_MEM;
                o_Immediate = w_IType_Immediate;
            end

            `OPCODE_STORE : begin
                o_MEM_Control.MemWrite = 1;
                o_EX_Control.AluOp = `ALUOP_ADD;
                o_EX_Control.AluOpAlt = `ALUOP_ALT_ADD;
                o_EX_Control.AluSrc2 = `ALUSRC2_IMM;
                o_Immediate = w_SType_Immediate;
            end

            `OPCODE_BRANCH : begin
                o_Branch = 1;
                o_EX_Control.AluOp = `ALUOP_ADD;
                o_EX_Control.AluOpAlt = `ALUOP_ALT_SUB;
                o_Immediate = w_BType_Immediate;
            end

            `OPCODE_JAL : begin
                o_Jump = 1;
                o_WB_Control.RegWrite = 1;
                o_EX_Control.AluOp = `ALUOP_ADD;
                o_EX_Control.AluOpAlt = `ALUOP_ALT_ADD;
                o_EX_Control.AluSrc1 = `ALUSRC1_PC;
                o_EX_Control.AluSrc2 = `ALUSRC2_CONST_4;
                o_Immediate = w_JType_Immediate;
            end

            `OPCODE_JALR : begin
                o_Jump = 1;
                o_WB_Control.RegWrite = 1;
                o_EX_Control.AluOp = `ALUOP_ADD;
                o_EX_Control.AluOpAlt = `ALUOP_ALT_ADD;
                o_EX_Control.AluSrc1 = `ALUSRC1_PC;
                o_EX_Control.AluSrc2 = `ALUSRC2_CONST_4;
                o_Immediate = w_JType_Immediate;
                o_JALR = 1;
            end

            `OPCODE_SYSTEM : begin
                o_EnvCall = w_Funct12 == `SYSTEM_FUNCT_ECALL;
                o_EnvBreak = w_Funct12 == `SYSTEM_FUNCT_EBREAK;
            end

            default : begin
                o_IllegalInstruction = 1;
            end

        endcase

    end

endmodule
