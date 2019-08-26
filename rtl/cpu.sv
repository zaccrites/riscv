
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


assign o_PC = w_IF_ID_PC;
assign o_InstructionWord = w_IF_ID_InstructionWord;


endmodule
