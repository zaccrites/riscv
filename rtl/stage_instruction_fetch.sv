
`include "pipeline_signals.svh"


module stage_instruction_fetch (
    input i_Clock,
    input i_Reset,

    // TODO: Implement branching, including flushing the pipeline
    // on branch misprediction.
    // verilator lint_off UNUSED
    input [31:0] i_BranchTarget,
    // input IF_Feedback_Signals_t i_BranchTarget,
    // verilator lint_on UNUSED

    output [31:0] o_PC,
    output [31:0] o_NextPC,
    output [31:0] o_InstructionWord,
    output o_InstructionWordValid,

    // TODO: Exceptions
    output o_InstructionAddressMisaligned
);

    logic [31:0] w_PC;
    logic [31:0] w_NextPC;
    program_counter pc (
        .i_Clock        (i_Clock),
        .i_Reset        (i_Reset),
        .o_PC           (w_PC),
        .o_NextPC       (w_NextPC)
    );

    logic w_InstructionWordValid;
    instruction_cache icache (
        .i_Clock            (i_Clock),
        .i_Reset            (i_Reset),
        .i_Address          (w_PC),
        .o_DataOut          (o_InstructionWord),
        .o_DataValid        (w_InstructionWordValid),
        .o_AddressMisaligned(o_InstructionAddressMisaligned)
    );

    always_ff @ (posedge i_Clock) begin
        if (i_Reset) begin
            o_InstructionWordValid <= 0;
        end
        else begin
            o_PC <= w_PC;
            o_NextPC <= w_NextPC;
            o_InstructionWordValid <= 1 || w_InstructionWordValid;
        end
    end

endmodule
