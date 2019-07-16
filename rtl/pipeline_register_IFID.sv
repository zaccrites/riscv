

module pipeline_register_IFID(
    input i_Clock,

    input [31:0] i_NextPC,
    input [31:0] i_InstructionWord,

    // TODO: Output specific instruction word bit fields instead?
    output [31:0] o_NextPC,
    output [31:0] o_InstructionWord
);

    logic [31:0] r_NextPC;
    logic [31:0] r_InstructionWord;

    always_ff @ (posedge i_Clock) begin
        r_NextPC <= i_NextPC;
        r_InstructionWord <= i_InstructionWord;
    end

    assign o_NextPC = r_NextPC;
    assign o_InstructionWord = r_InstructionWord;

endmodule
