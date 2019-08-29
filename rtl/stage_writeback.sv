
`include "control_unit.svh"


module stage_writeback (
    input [31:0] i_MemoryData,
    input [31:0] i_AluOutput,

    input i_WritebackSource,

    output [31:0] o_WritebackValue
);


always_comb begin
    case (i_WritebackSource)
        `WBSRC_ALU : o_WritebackValue = i_AluOutput;
        `WBSRC_MEM : o_WritebackValue = i_MemoryData;
    endcase
end


endmodule
