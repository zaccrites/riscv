
// Instruction Fetch stage

module stage_IF(
    input i_Clock,
    input i_Reset,

    // Stage inputs
    input i_Branch,
    input [31:0] i_BranchAddress,

    // Stage outputs
    output [31:0] o_NextPC,
    output [31:0] o_InstructionWord
);

    logic [31:0] r_ProgramCounter;

    logic [31:0] w_InstructionWord;
    memory instruction_memory(
        .i_Clock(i_Clock),
        .i_WriteEnable(0),
        .i_Address(r_ProgramCounter),
        .i_DataIn(0),
        .o_DataOut(w_InstructionWord)
    );



    // TODO: Check for address misaligned


    logic [31:0] w_NextPC;
    always_comb begin
        w_NextPC = r_ProgramCounter + 4;
    end

    always_ff @(posedge i_Clock) begin
        r_ProgramCounter <= i_Branch ? i_BranchAddress : w_NextPC;
    end

    assign o_NextPC = w_NextPC;
    assign o_InstructionWord = w_InstructionWord;

endmodule
