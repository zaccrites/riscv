
`include "cpu_defs.sv"
`include "memory_defs.sv"   // TODO: Remove this, once the instruction memory is replaced.
`include "programming_defs.sv"

/* verilator lint_off UNUSED */

module cpu(
    input i_Clock,
    input i_Reset,

    input i_ExternalInterrupt,

    output [31:0] o_InstructionPointer,

    // These should trap, but we still have to communicate with the
    // simulator somehow.
    output o_EnvironmentCall,
    output o_EnvironmentBreak
);

    assign o_EnvironmentCall = w_EnvironmentCall;
    assign o_EnvironmentBreak = w_EnvironmentBreak;

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
    logic w_CsrWriteEnable;


    logic w_DoJump;
    logic [31:0] w_JumpAddress;
    program_counter pc (
        .i_Clock                  (i_Clock),
        .i_Reset                  (i_Reset),
        // .i_Jump                   (w_DoJump),
        .i_Jump                   (w_Jump | w_ExceptionRaised | w_ReturnFromTrap),  // TODO: This is ugly
        .i_Branch                 (w_Branch),
        .i_BranchType             (w_Funct),
        // .i_BranchAddress          (w_JumpAddress),
        .i_BranchAddress          (w_BranchAddress),
        .i_AluZero                (w_AluZero),
        .i_AluLessThan            (w_AluLessThan),
        .i_AluLessThanUnsigned    (w_AluLessThanUnsigned),
        .o_InstructionPointer     (w_InstructionPointer)
    );

    // Note that instruction memory can't have a bad access mode,
    // but CAN have a misaligned instruction memory access.
    logic w_InstructionAddressMisaligned;
    logic _dummy1;
    memory instruction_memory (
        .i_Clock                  (i_Clock),
        .i_ReadEnable             (1),
        .i_WriteEnable            (0),
        .i_Address                (w_InstructionPointer),
        .i_DataIn                 (32'b0),
        .i_Mode                   (`LOAD_WORD),
        .o_DataOut                (w_InstructionWord)

        ,
        .o_MisalignedAccess(w_InstructionAddressMisaligned),
        .o_BadInstruction  (_dummy1)
    );

    // logic w_IllegalInstruction;
    logic w_IllegalInstructionDecode;
    logic w_Breakpoint;
    logic w_EnvironmentCall;
    logic w_EnvironmentBreak;
    logic w_ReturnFromTrap;                // TODO: PC <= MEPC (+4 ?)
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
        .o_JALR                   (w_JALR),

        .o_EnvironmentCall        (w_EnvironmentCall),
        .o_EnvironmentBreak       (w_EnvironmentBreak),
        .o_ReturnFromTrap         (w_ReturnFromTrap),
        .o_IllegalInstruction     (w_IllegalInstructionDecode),

        .o_CsrNumber              (w_CsrNumber),
        .o_CsrAluSource           (w_CsrAluSource),
        .o_CsrReadEnable          (w_CsrReadEnable),
        .o_CsrWriteEnable         (w_CsrWriteEnable)
    );

    // TODO: Implement properly with CSRs, but I wonder if I can get
    // exceptions working without them for now by injecting an external
    // interrupt and responding to internal synchronous exceptions
    // (including ECALL and EBREAK).
    //
    // I may still have to make mepc, mtval, etc. readable though.
    // Certainly MRET will need to return to the value in mepc.
    //
    logic w_Interrupt;
    logic w_ExceptionRaised;
    logic [3:0] w_ExceptionCause;  // written to mcause when w_ExceptionRaised
    exception_unit exc (
        .i_ExternalInterrupt           (i_ExternalInterrupt),
        .i_SoftwareInterrupt           (0),  // bit set in mip ??
        .i_TimerInterrupt              (0),  // timer register ??
        .i_InstructionAddressMisaligned(w_InstructionAddressMisaligned),
        .i_InstructionAccessFault      (0),  // TODO: e.g. When reading past end of memory?
        .i_IllegalInstruction          (w_IllegalInstruction),
        .i_EnvironmentBreak            (w_EnvironmentBreak),
        .i_EnvironmentCall             (w_EnvironmentCall),
        .i_LoadAddressMisaligned       (w_LoadAddressMisaligned),
        .i_LoadAccessFault             (0),  // TODO: e.g. When reading past end of memory?

        .o_Interrupt                   (w_Interrupt),
        .o_ExceptionRaised             (w_ExceptionRaised),
        .o_ExceptionCause              (w_ExceptionCause)

        // TODO: These should be written as bits in the MIP CSR and cleared
        // by software as they are handled, I believe.
        // Does this implementation lose track of interrupts not handled
        // immediately? What about nested interrupts?

        // According to Privileged Spec Table Table 3.7, only one
        // cause is reported in mcause according to a specified order.
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


    logic [31:0] w_CsrOutput;

    logic [31:0] w_csr_mepc;
    csr_file CSRs (
        .i_Clock          (i_Clock),
        .i_Reset          (i_Reset),
        .i_InputData      (w_CsrInputData),
        .i_CsrNumber      (w_CsrNumber),

        .i_ReadEnable (w_CsrReadEnable),
        .i_WriteEnable (w_CsrWriteEnable),

        .i_AluOp          (w_Funct),

        .i_ExceptionRaised             (w_ExceptionRaised),
        .i_Interrupt                   (w_Interrupt),
        .i_ExceptionCause              (w_ExceptionCause),
        .i_ExceptionInstructionPointer (w_InstructionPointer),

        .o_mepc           (w_csr_mepc),
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

    logic w_LoadAddressMisaligned;
    logic w_IllegalLoadInstruction;
    memory data_memory (
        .i_Clock                  (i_Clock),
        .i_Address                (w_AluOutput),
        .i_ReadEnable             (w_MemRead),
        .i_WriteEnable            (w_MemWrite),
        .i_DataIn                 (w_rs2Value),
        .i_Mode                   (w_Funct),
        .o_DataOut                (w_MemValue)

        ,
        .o_MisalignedAccess(w_LoadAddressMisaligned),
        .o_BadInstruction  (w_IllegalLoadInstruction)
    );

    always_comb begin

        // TODO: When this is pipelined, the target address of the exception
        // will be different depending on which instruction causes it.
        w_IllegalInstruction = w_IllegalLoadInstruction | w_IllegalInstructionDecode;

        // TODO: This seems ugly
        // w_DoJump = w_Jump | w_ReturnFromTrap;
        if (w_ExceptionRaised) begin
            $display("w_BranchAddress = `INTERRUPT_VECTOR_ADDRESS;");
            w_BranchAddress = `INTERRUPT_VECTOR_ADDRESS;
        end
        else if (w_ReturnFromTrap) begin
            // $display("w_BranchAddress = w_csr_mepc;");
            w_BranchAddress = w_csr_mepc;
        end
        else if (w_JALR) begin
            // $display("w_BranchAddress = w_rs1Value + w_ImmediateData;");
            w_BranchAddress = w_rs1Value + w_ImmediateData;
        end
        else begin
            // $display("w_BranchAddress = w_InstructionPointer + w_ImmediateData;");
            w_BranchAddress = w_InstructionPointer + w_ImmediateData;
        end

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
            `CSRSRC_RS1 : w_CsrInputData = w_rs1Value;
            `CSRSRC_IMM : w_CsrInputData = w_ImmediateData;
        endcase

        case (w_WritebackSource)
            `WBSRC_ALU : w_WritebackValue = w_AluOutput;
            `WBSRC_MEM : w_WritebackValue = w_MemValue;
            `WBSRC_CSR : w_WritebackValue = w_CsrOutput;
            default    : w_WritebackValue = 32'hxxxxxxxx;
        endcase

    end

    assign o_InstructionPointer = w_InstructionPointer;

endmodule
