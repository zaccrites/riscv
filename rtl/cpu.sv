
`include "cpu_defs.sv"
`include "memory_defs.sv"   // TODO: Remove this, once the instruction memory is replaced.

/* verilator lint_off UNUSED */

module cpu(
    input i_Clock,
    input i_Reset,

    output [31:0] o_InstructionPointer,

    // For now we'll just catch an "illegal" ecall instruction
    // to communicate with the simulator by peering into the register file.
    output o_Syscall
);

    logic [31:0] w_InstructionPointer;
    logic [31:0] w_InstructionWord;

    logic [31:0] w_ImmediateData;
    logic [4:0] w_rd;
    logic [4:0] w_rs1;
    logic [4:0] w_rs2;
    logic w_Branch;
    logic w_Jump;
    logic w_RegWrite;
    logic w_MemWrite;
    logic w_MemRead;
    logic [1:0] w_AluSource1;
    logic [1:0] w_AluSource2;
    logic [1:0] w_WritebackSource;
    logic [2:0] w_Funct;
    logic [2:0] w_AluOp;
    logic w_AluOpAlt;
    logic w_IllegalInstruction;
    logic w_JALR;

    logic [31:0] w_BranchAddress;
    logic w_AluZero;
    logic w_AluLessThan;
    logic w_AluLessThanUnsigned;

    logic [31:0] w_AluOutput;
    logic [31:0] w_AluInput1;
    logic [31:0] w_AluInput2;

    logic [31:0] w_WritebackValue;
    logic [31:0] w_rs1Value;
    logic [31:0] w_rs2Value;
    logic [31:0] w_MemValue;

    logic w_CsrAluSource;
    logic [11:0] w_CsrNumber;
    logic [31:0] w_CsrInputData;
    logic w_CsrReadEnable;
    logic w_WriteReadEnable;


    program_counter pc (
        .i_Clock                  (i_Clock),
        .i_Reset                  (i_Reset),
        .i_Jump                   (w_Jump),
        .i_Branch                 (w_Branch),
        .i_BranchType             (w_Funct),
        .i_BranchAddress          (w_BranchAddress),
        .i_AluZero                (w_AluZero),
        .i_AluLessThan            (w_AluLessThan),
        .i_AluLessThanUnsigned    (w_AluLessThanUnsigned),
        .o_InstructionPointer     (w_InstructionPointer)
    );

    // Note that instruction memory can't have a bad access mode,
    // but CAN have a misaligned instruction memory access.
    logic w1, w2;
    memory instruction_memory (
        .i_Clock                  (i_Clock),
        .i_ReadEnable             (1),
        .i_WriteEnable            (0),
        .i_Address                (w_InstructionPointer),
        .i_DataIn                 (32'b0),
        .i_Mode                   (`LOAD_WORD),
        .o_DataOut                (w_InstructionWord)

        ,
        .o_MisalignedAccess(w1),
        .o_BadInstruction  (w2)
    );

    instruction_decode decode (
        .i_InstructionWord        (w_InstructionWord),
        .o_ImmediateData          (w_ImmediateData),
        .o_rd                     (w_rd),
        .o_rs1                    (w_rs1),
        .o_rs2                    (w_rs2),
        .o_Branch                 (w_Branch),
        .o_Jump                   (w_Jump),
        .o_RegWrite               (w_RegWrite),
        .o_MemWrite               (w_MemWrite),
        .o_MemRead                (w_MemRead),
        .o_AluSource1             (w_AluSource1),
        .o_AluSource2             (w_AluSource2),
        .o_WritebackSource        (w_WritebackSource),
        .o_Funct                  (w_Funct),
        .o_AluOp                  (w_AluOp),
        .o_AluOpAlt               (w_AluOpAlt),
        .o_IllegalInstruction     (w_IllegalInstruction),
        .o_JALR                   (w_JALR),

        .o_CsrNumber              (w_CsrNumber),
        .o_CsrAluSource           (w_CsrAluSource),
        .o_CsrReadEnable          (w_CsrReadEnable),
        .o_CsrWriteEnable         (w_CsrWriteEnable)
    );

    register_file registers (
        .i_Clock                  (i_Clock),
        .i_WriteEnable            (w_RegWrite),
        .i_RegDest                (w_rd),
        .i_RegSource1             (w_rs1),
        .i_RegSource2             (w_rs2),
        .i_DataIn                 (w_WritebackValue),
        .o_DataOut1               (w_rs1Value),
        .o_DataOut2               (w_rs2Value)
    );

    csr csr1(
        .i_Clock          (i_Clock),
        .i_InputData      (w_CsrInput),
        .i_CsrNumber      (w_CsrNumber),

        .i_ReadEnable (w_CsrReadEnable),
        .i_WriteEnable (w_CsrWriteEnable),

        .i_AluOp          (w_Funct),

        // TODO: Use priority encoder to select incoming exception source
        .i_ExceptionSource (0),

        .i_rd             (w_rd),

        .o_OutputData     (w_CsrOutput)
    );

    alu alu1 (
        .i_AluOp                  (w_AluOp),
        .i_AluOpAlt               (w_AluOpAlt),
        .i_Source1                (w_AluInput1),
        .i_Source2                (w_AluInput2),
        .o_Zero                   (w_AluZero),
        .o_LessThan               (w_AluLessThan),
        .o_LessThanUnsigned       (w_AluLessThanUnsigned),
        .o_Output                 (w_AluOutput)
    );

    logic w3, w4;
    memory data_memory (
        .i_Clock                  (i_Clock),
        .i_Address                (w_AluOutput),
        .i_ReadEnable             (w_MemRead),
        .i_WriteEnable            (w_MemWrite),
        .i_DataIn                 (w_rs2Value),
        .i_Mode                   (w_Funct),
        .o_DataOut                (w_MemValue)

        ,
        .o_MisalignedAccess(w3),
        .o_BadInstruction  (w4)
    );

    always_comb begin

        case (w_JALR)
            0 : w_BranchAddress = w_InstructionPointer + w_ImmediateData;
            1 : w_BranchAddress = w_rs1Value + w_ImmediateData;
        endcase

        case (w_AluSource1)
            `ALUSRC1_RS1     : w_AluInput1 = w_rs1Value;
            `ALUSRC1_PC      : w_AluInput1 = w_InstructionPointer;
            `ALUSRC1_CONST_0 : w_AluInput1 = 32'd0;
            default          : w_AluInput1 = 32'hxxxxxxxx;
        endcase

        case (w_AluSource2)
            `ALUSRC2_RS2     : w_AluInput2 = w_rs2Value;
            `ALUSRC2_IMM     : w_AluInput2 = w_ImmediateData;
            `ALUSRC2_CONST_4 : w_AluInput2 = 32'd4;
            default          : w_AluInput2 = 32'hxxxxxxxx;
        endcase

        case (w_CsrAluSource)
            `CSRSRC_RS1 : w_CsrInput = w_rs1Value;
            `CSRSRC_IMM : w_CsrInput = w_ImmediateData;
        endcase

        case (w_WritebackSource)
            `WBSRC_ALU : w_WritebackValue = w_AluOutput;
            `WBSRC_MEM : w_WritebackValue = w_MemValue;
            `WBSRC_CSR : w_WritebackValue = w_CsrOutput;
            default    : w_WritebackValue = 32'hxxxxxxxx;
        endcase

        o_InstructionPointer = w_InstructionPointer;

        // TODO: Remove this!
        o_Syscall = w_IllegalInstruction;

    end

endmodule
