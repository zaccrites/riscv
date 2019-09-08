
`include "pipeline_signals.svh"


module stage_memory (
    input i_Clock,
    input i_Reset,

    input MEM_Control_t i_MEM_Control,
    input WB_Control_t i_WB_Control,
    input RegisterIDs_t i_RegisterIDs,

    output WB_Control_t o_WB_Control,

    input [31:0] i_AluOutput,
    input [31:0] i_rs2Value,

    output [31:0] o_AluOutput,
    output [31:0] o_MemoryValue,
    output RegisterIDs_t o_RegisterIDs,

    // TODO
    logic o_MisalignedAccess
);

    data_cache dcache (
        .i_Clock(i_Clock),
        .i_Reset(i_Reset),

        .i_ReadEnable      (i_MEM_Control.MemRead),
        .i_WriteEnable     (i_MEM_Control.MemWrite),
        .i_Mode            (i_MEM_Control.MemMode),
        .i_Address         (i_AluOutput),
        .i_DataIn          (i_rs2Value),

        .o_DataOut         (o_MemoryValue),
        .o_MisalignedAccess(o_MisalignedAccess)
    );


    always_ff @ (posedge i_Clock) begin
        if (i_Reset) begin
            o_WB_Control.RegWrite <= 0;
        end
        else begin
            o_WB_Control <= i_WB_Control;
            o_RegisterIDs <= i_RegisterIDs;

            // NOTE: Memory reads are already synchronous
            o_AluOutput <= i_AluOutput;
        end
    end

endmodule
