
// TODO: Add branching and exception support

module program_counter(
    input i_Clock,
    input i_Reset,

    output [31:0] o_InstructionPointer
);

    logic [31:0] r_InstructionPointer;

    always_ff @ (posedge i_Clock) begin
        if (i_Reset) begin
            r_InstructionPointer <= 0;
        end
        else begin
            r_InstructionPointer <= r_InstructionPointer + 4;
        end
    end

    assign o_InstructionPointer = r_InstructionPointer;


    // TDD the rest of this module!


endmodule
