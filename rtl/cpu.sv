
module cpu (
    input i_Clock,
    input i_Reset,

    // TODO: Remove this
    output [31:0] o_PC,
    output [31:0] o_InstructionWord
);


// verilator lint_off UNUSED


logic [31:0] w_IF_ID_PC;
logic [31:0] w_IF_ID_NextPC;
logic [31:0] w_IF_ID_InstructionWord;
logic w_IF_ID_InstructionAddressMisaligned;
stage_instruction_fetch stage_IF (
    .i_Clock            (i_Clock),
    .i_Reset            (i_Reset),

    .o_NextPC           (w_IF_ID_NextPC),
    .o_InstructionWord  (w_IF_ID_InstructionWord),
    .o_PC               (w_IF_ID_PC),
    .o_InstructionAddressMisaligned  (w_IF_ID_InstructionAddressMisaligned)
);



logic w_ID_EX_MemWrite;
stage_instruction_decode stage_ID (
    .i_Clock       (i_Clock),
    .i_Reset       (i_Reset),
    .o_MemWrite    (w_ID_EX_MemWrite)

    .i_RegWrite (w_RegWrite)
);



logic w_EX_MEM_MemWrite;
stage_execution stage_EX (
    .i_Clock  (i_Clock),
    .i_Reset  (i_Reset)
    .i_MemWrite(w_ID_EX_MemWrite),
    .o_MemWrite(w_EX_MEM_MemWrite)
);


logic w_MEM_WB_RegWrite;
stage_memory stage_MEM (
    .i_Clock     (i_Clock),
    .i_Reset     (i_Reset),

    .i_MemWrite  (w_EX_MEM_MemWrite)

    .o_RegWrite  (w_MEM_WB_RegWrite)
);


logic w_RegWrite;
logic w_WritebackValue;
stage_writeback stage_WB (
    .i_RegWrite(w_MEM_WB_RegWrite),
    .o_RegWrite(w_RegWrite),
    .o_WritebackValue (w_WritebackValue)
);



assign o_PC = w_IF_ID_PC;
assign o_InstructionWord = w_IF_ID_InstructionWord;


endmodule
