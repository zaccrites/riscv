
module instruction_fetch(
    input i_Clock,



    input [31:0] i_InstructionPointer,
    output [31:0] o_InstructionRegister
    );

    logic [31:0] r_InstructionRegister

    always_ff @ (posedge i_Clock) begin

    end

    assign o_InstructionRegister = r_InstructionRegister;

endmodule
