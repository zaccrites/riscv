
module stage_memory (
    input i_Clock,
    input i_Reset,

    input i_MemWrite,

    input [31:0] i_AluOutput,
    input [31:0] i_Reg2Value,

    input i_RegWrite,
    output o_RegWrite,

    output [31:0] o_AluOutput,
    output [31:0] o_MemoryData,
    output [31:0] o_Reg2Value
);

    data_cache dcache (
        .i_Clock(i_Clock),
        .i_Reset(i_Reset),
        .i_DataIn(i_Reg2Value),

    );


    always_ff @ (posedge i_Clock) begin
        if (i_Reset) begin
            o_RegWrite <= 0;
        end
        else begin
            o_RegWrite <= i_RegWrite;
        end
    end

endmodule
