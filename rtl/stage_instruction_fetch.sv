
module stage_instruction_fetch (
    input i_Clock,
    input i_Reset,

    output [31:0] o_PC,
    output [31:0] o_NextPC,
    output [31:0] o_InstructionWord,

    output o_InstructionAddressMisaligned
);


program_counter pc (
    .i_Clock        (i_Clock),
    .i_Reset        (i_Reset),
    .o_PC           (o_PC),
    .o_NextPC       (o_NextPC)
);


instruction_cache icache (
    .i_Clock            (i_Clock),
    .i_Reset            (i_Reset),
    .i_Address          (o_PC),
    .o_DataOut          (o_InstructionWord),
    .o_AddressMisaligned(o_InstructionAddressMisaligned)
);




endmodule
