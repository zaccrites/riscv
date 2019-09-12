
`include "pipeline_signals.svh"
`include "stage_writeback.svh"


module stage_writeback (
    input WB_Control_t i_WB_Control,
    input RegisterID_t i_rd,

    input [31:0] i_AluOutput,
    input [31:0] i_MemoryValue,

    output WritebackSignals_t o_WritebackSignals
);


always_comb begin
    case (i_WB_Control.WritebackSrc)
        `WBSRC_ALU : o_WritebackSignals.Value = i_AluOutput;
        `WBSRC_MEM : o_WritebackSignals.Value = i_MemoryValue;
    endcase

    o_WritebackSignals.RegWrite = i_WB_Control.RegWrite;
    o_WritebackSignals.rd = i_rd;
end


endmodule
