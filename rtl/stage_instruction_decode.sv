
module stage_instruction_decode (
    input i_Clock,
    input i_Reset,

    input [31:0] i_NextPC,


    output [31:0] o_BranchTarget,



    // These are sent back from the WB stage.
    input i_RegWrite,
    input [31:0] i_WritebackValue,




    output o_MemWrite,
    output o_RegWrite,
    // output
);

endmodule
