
module control_unit (
    input [31:0] i_InstructionWord,

    output o_RegWrite,
    output o_MemWrite
);


    assign o_RegWrite = 1;
    assign o_MemWrite = 0;


endmodule
