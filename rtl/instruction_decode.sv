
// Extract fields from an instruction word and assert control signals.


`include "cpu_defs.sv"
`include "alu_defs.sv"
`include "opcode_defs.sv"

// TODO: This needs better tests.


module instruction_decode(
    input [31:0] i_InstructionWord,

    output [31:0] o_ImmediateData,
    output [4:0] o_rd,
    output [4:0] o_rs1,
    output [4:0] o_rs2,
    output o_Branch,
    output o_Jump,
    output o_RegWrite,
    output o_MemWrite,
    output o_MemRead,
    output [1:0] o_AluSource1,
    output [1:0] o_AluSource2,
    output o_WritebackSource,
    output [2:0] o_Funct,
    output [2:0] o_AluOp,
    output o_AluOpAlt,

    // TODO: Better way to output this?
    output o_JALR,

    output o_IllegalInstruction

);
    logic [2:0] w_Funct3;
    logic [4:0] w_rs2;
    logic [4:0] w_rs1;
    logic [4:0] w_rd;
    logic [4:0] w_Opcode;
    logic [1:0] w_OpcodeSuffix;

    // TODO: FENCE instruction

    logic w_Branch;
    logic w_Jump;

    logic w_RegWrite;

    logic w_MemWrite;
    logic w_MemRead;
    // logic w_MemReadUnsigned;
    // logic [1:0] w_MemAlignment;


    logic [1:0] w_AluSource1;
    logic [1:0] w_AluSource2;
    logic [2:0] w_AluOp;
    logic w_AluOpAlt;             // ADD/SUB, SRL/SRA, etc.


    logic w_WritebackSource;

    logic [31:0] w_IType_Immediate;
    logic [31:0] w_SType_Immediate;
    logic [31:0] w_BType_Immediate;
    logic [31:0] w_UType_Immediate;
    logic [31:0] w_JType_Immediate;
    logic [31:0] w_Immediate;

    logic w_IllegalInstruction;

    logic w_JALR;

    always_comb begin
        w_rs2           = i_InstructionWord[24:20];
        w_rs1           = i_InstructionWord[19:15];
        w_Funct3        = i_InstructionWord[14:12];
        w_rd            = i_InstructionWord[11:7];
        w_Opcode        = i_InstructionWord[6:2];
        w_OpcodeSuffix  = i_InstructionWord[1:0];

        // See RISC-V Unprivileged ISA Figure 2.4
        w_IType_Immediate = {{21{i_InstructionWord[31]}}, i_InstructionWord[30:20]};
        w_SType_Immediate = {{21{i_InstructionWord[31]}}, i_InstructionWord[30:25], i_InstructionWord[11:7]};
        w_BType_Immediate = {{20{i_InstructionWord[31]}}, i_InstructionWord[7], i_InstructionWord[30:25], i_InstructionWord[11:8], 1'b0};
        w_UType_Immediate = {i_InstructionWord[31:12], 12'b0};
        w_JType_Immediate = {{12{i_InstructionWord[31]}}, i_InstructionWord[19:12], i_InstructionWord[20], i_InstructionWord[30:25], i_InstructionWord[24:21], 1'b0};

        // Some of these can likely be set to don't-cares, but since the
        // signals are all set via a LUT entry anyway then it probably
        // doesn't cost anything extra to have them set to a specific value.
        w_Jump = 0;
        w_Branch = 0;
        w_RegWrite = 0;
        w_MemWrite = 0;
        w_MemRead = 0;
        w_AluSource1 = `ALUSRC1_RS1;
        w_AluSource2 = `ALUSRC2_RS2;
        w_AluOp = w_Funct3;
        w_AluOpAlt = i_InstructionWord[30];
        w_WritebackSource = `WBSRC_ALU;
        w_Immediate = 32'x;
        w_JALR = 0;
        w_IllegalInstruction = (w_OpcodeSuffix != 2'b11);

        case (w_Opcode)

            `OPCODE_LOAD : begin
                w_RegWrite = 1;
                w_MemRead = 1;
                w_AluOp = `ALUOP_ADD;
                w_AluOpAlt = 0;
                w_AluSource2 = `ALUSRC2_IMM;
                w_WritebackSource = `WBSRC_MEM;
                w_Immediate = w_IType_Immediate;
            end

            `OPCODE_OP_IMM : begin
                w_RegWrite = 1;
                w_AluSource1 = `ALUSRC1_RS1;
                w_AluSource2 = `ALUSRC2_IMM;
                w_Immediate = w_IType_Immediate;

                // The only OP_IMM instruction for which this
                // applies is SRAI. This will cause problems for
                // e.g. ADDI, where with an immediate with the right
                // bit set will subtract instead of add.
                w_AluOpAlt = w_AluOpAlt && (w_AluOp == `ALUOP_SRL);
            end

            `OPCODE_AUIPC : begin
                w_RegWrite = 1;
                w_AluSource1 = `ALUSRC1_PC;
                w_AluSource2 = `ALUSRC2_IMM;
                w_Immediate = w_UType_Immediate;
            end

            `OPCODE_STORE : begin
                w_MemWrite = 1;
                w_AluOp = `ALUOP_ADD;
                w_AluOpAlt = 0;
                w_AluSource2 = `ALUSRC2_IMM;
                w_Immediate = w_SType_Immediate;
            end

            `OPCODE_OP : begin
                w_RegWrite = 1;
            end

            `OPCODE_LUI : begin
                w_RegWrite = 1;
                w_AluSource1 = `ALUSRC1_CONST_0;
                w_AluSource2 = `ALUSRC2_IMM;
                w_Immediate = w_UType_Immediate;
            end

            `OPCODE_BRANCH : begin
                w_Branch = 1;
                w_AluOp = `ALUOP_ADD;
                w_AluOpAlt = 1;
                w_Immediate = w_BType_Immediate;
            end

            `OPCODE_JALR : begin
                w_Jump = 1;
                w_RegWrite = 1;
                w_AluOp = `ALUOP_ADD;
                w_AluOpAlt = 0;
                w_AluSource1 = `ALUSRC1_PC;
                w_AluSource2 = `ALUSRC2_CONST_4;
                w_Immediate = w_IType_Immediate;
                w_JALR = 1;
            end

            `OPCODE_JAL : begin
                w_Jump = 1;
                w_RegWrite = 1;
                w_AluOp = `ALUOP_ADD;
                w_AluOpAlt = 0;
                w_AluSource1 = `ALUSRC1_PC;
                w_AluSource2 = `ALUSRC2_CONST_4;
                w_Immediate = w_JType_Immediate;
            end

            `OPCODE_SYSTEM : begin
                // TODO: Implement and add test for ECALL, EBREAK, and CSR instructions
                //
                // These are just dummy parameters to get some data out
                // of the simulator to the C++ environment (what could be
                // called an AEE, I guess).
                w_RegWrite = 0;
                w_MemWrite = 0;

                // $display("System! word=%08x", i_InstructionWord);
                w_IllegalInstruction = 1;
            end

            default : begin
                // Unimplemented or illegal instruction
                $display("Unimplemented! word=%08x", i_InstructionWord);
                w_IllegalInstruction = 1;
            end

        endcase

    end


    assign o_AluOpAlt = w_AluOpAlt;

    assign o_IllegalInstruction = w_IllegalInstruction;
    assign o_rs2 = w_rs2;
    assign o_rs1 = w_rs1;
    assign o_rd = w_rd;

    assign o_AluOp = w_AluOp;
    assign o_Funct = w_Funct3;

    assign o_ImmediateData = w_Immediate;

    assign o_Branch = w_Branch;
    assign o_Jump = w_Jump;
    assign o_RegWrite = w_RegWrite;
    assign o_MemWrite = w_MemWrite;
    assign o_MemRead = w_MemRead;

    assign o_AluSource1 = w_AluSource1;
    assign o_AluSource2 = w_AluSource2;
    assign o_WritebackSource = w_WritebackSource;

    assign o_JALR = w_JALR;

endmodule
