
// Extract fields from an instruction word and assert control signals.


`include "cpu_defs.sv"
`include "alu_defs.sv"
`include "opcode_defs.sv"
`include "system_defs.sv"
`include "register_defs.sv"

// TODO: This needs better tests.

// TODO: Can I split this up? I had hoped the CSR stuff would be separate.


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
    output [1:0] o_WritebackSource,
    output [2:0] o_Funct,
    output [2:0] o_AluOp,
    output o_AluOpAlt,

    output [11:0] o_CsrNumber,
    output o_CsrAluSource,
    output o_CsrWriteEnable,
    output o_CsrReadEnable,

    // TODO: Better way to output this?
    output o_JALR,

    output o_EnvironmentCall,
    output o_EnvironmentBreak,
    output o_ReturnFromTrap,
    output o_IllegalInstruction

);
    logic [11:0] w_Funct12;
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

    logic [11:0] w_CsrNumber;
    logic w_CsrReadEnable;
    logic w_CsrWriteEnable;
    logic [4:0] w_CSR_uimm;
    logic w_CsrAluSource;

    logic [1:0] w_AluSource1;
    logic [1:0] w_AluSource2;
    logic [2:0] w_AluOp;
    logic w_AluOpAlt;             // ADD/SUB, SRL/SRA, etc.


    logic [1:0] w_WritebackSource;

    logic [31:0] w_IType_Immediate;
    logic [31:0] w_SType_Immediate;
    logic [31:0] w_BType_Immediate;
    logic [31:0] w_UType_Immediate;
    logic [31:0] w_JType_Immediate;
    logic [31:0] w_Immediate;

    logic w_IllegalInstruction;
    logic w_EnvironmentCall;
    logic w_EnvironmentBreak;
    logic w_ReturnFromTrap;


    logic w_JALR;

    always_comb begin

        $display("DECODING instruction %08x", i_InstructionWord);

        w_Funct12       = i_InstructionWord[31:20];
        w_rs2           = i_InstructionWord[24:20];
        w_rs1           = i_InstructionWord[19:15];
        w_Funct3        = i_InstructionWord[14:12];
        w_rd            = i_InstructionWord[11:7];
        w_Opcode        = i_InstructionWord[6:2];
        w_OpcodeSuffix  = i_InstructionWord[1:0];

        // See RISC-V Unprivileged ISA Section 9.1
        w_CsrNumber = i_InstructionWord[31:20];
        w_CSR_uimm = i_InstructionWord[19:15];

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
        w_Immediate = 32'hxxxxxxxx;
        w_JALR = 0;
        w_IllegalInstruction = (w_OpcodeSuffix != 2'b11);

        w_CsrReadEnable = 0;
        w_CsrWriteEnable = 0;
        w_CsrAluSource = `CSRSRC_RS1;

        // TODO: I am concerned that some of these are getting inferred as
        // latches by Verilator if the default value isn't assigned at the
        // top, since the value isn't set in all branches.
        w_EnvironmentBreak = 0;
        w_EnvironmentCall = 0;
        w_ReturnFromTrap = 0;             //  Like this one! After the first MRET it was like ALL instructions were returning from a trap?
        // Is there a way to get Verilator to warn about this for always_comb? Yosys? Vivado?

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
                // TODO: Optimize this?
                w_WritebackSource = `WBSRC_CSR;
                w_Immediate = {27'b0, w_CSR_uimm};

                if (w_Funct12 == `SYSTEM_FUNCT_ECALL) begin
                    w_EnvironmentCall = 1;
                end
                else if (w_Funct12 == `SYSTEM_FUNCT_EBREAK) begin
                    w_EnvironmentBreak = 1;
                end
                else if (w_Funct12 == `SYSTEM_FUNCT_MRET) begin
                    // TODO: SRET and URET
                    w_ReturnFromTrap = 1;
                end
                else case (w_Funct3)

                    `SYSTEM_FUNCT_CSRRW : begin
                        w_CsrReadEnable = w_rd != `REG_x0;
                        w_CsrWriteEnable = 1;
                        w_CsrAluSource = `CSRSRC_RS1;
                    end
                    `SYSTEM_FUNCT_CSRRWI : begin
                        w_CsrReadEnable = w_rd != `REG_x0;
                        w_CsrWriteEnable = 1;
                        w_CsrAluSource = `CSRSRC_IMM;
                    end

                    `SYSTEM_FUNCT_CSRRS,
                    `SYSTEM_FUNCT_CSRRC : begin
                        w_CsrReadEnable = 1;
                        // NOTE: uimm and rs1 refer to the same bits,
                        // so these can be checked together.
                        w_CsrWriteEnable = w_rs1 != `REG_x0;
                        w_CsrAluSource = `CSRSRC_RS1;
                    end
                    `SYSTEM_FUNCT_CSRRSI,
                    `SYSTEM_FUNCT_CSRRCI : begin
                        w_CsrReadEnable = 1;
                        // NOTE: uimm and rs1 refer to the same bits,
                        // so these can be checked together.
                        w_CsrWriteEnable = w_rs1 != `REG_x0;
                        w_CsrAluSource = `CSRSRC_IMM;
                    end

                    default: begin
                        $display("Unimplemented SYSTEM instruction: %08x", i_InstructionWord);
                        w_CsrReadEnable = 0;
                        w_CsrWriteEnable = 0;
                        w_IllegalInstruction = 1;
                    end
                endcase
            end

            default : begin
                $display("Unimplemented or illegal instruction: %08x", i_InstructionWord);
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

    assign o_CsrNumber = w_CsrNumber;
    assign o_CsrAluSource = w_CsrAluSource;
    assign o_CsrWriteEnable = w_CsrWriteEnable;
    assign o_CsrReadEnable = w_CsrReadEnable;

    assign o_EnvironmentCall = w_EnvironmentCall;
    assign o_EnvironmentBreak = w_EnvironmentBreak;
    assign o_ReturnFromTrap = w_ReturnFromTrap;

endmodule
