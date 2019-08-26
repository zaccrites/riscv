
`include "programming.svh"


module program_counter (
    input i_Clock,
    input i_Reset,

    // input

    output [31:0] o_PC,
    output [31:0] o_NextPC
);

logic [31:0] r_PC;
assign o_PC = r_PC;


logic [31:0] w_NextPC;
assign w_NextPC = r_PC + 4;
assign o_NextPC = w_NextPC;


always_ff @ (posedge i_Clock) begin
    if (i_Reset) begin
        r_PC <= `RESET_VECTOR_ADDRESS;
    end
    else begin
        r_PC <= w_NextPC;  // TODO: Branches
    end
end



endmodule
