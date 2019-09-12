
`include "pipeline_signals.svh"


module forwarding_unit (
    input RegisterID_t i_rs1,
    input RegisterID_t i_rs2,
    input ForwardingSignals_t i_ForwardingSignals,

    output o_ForwardRs1,
    output o_ForwardRs2,

    output [31:0] o_ForwardedRs1Value,
    output [31:0] o_ForwardedRs2Value

);

    // TODO: Optimize this? Could be using a lot of LUTs
    always_comb begin

        if (i_ForwardingSignals.MEM_RegWrite &&
            i_ForwardingSignals.MEM_rd == i_rs1 &&
            i_ForwardingSignals.MEM_rd != 0)
        begin
            o_ForwardedRs1Value = i_ForwardingSignals.MEM_Value;
            o_ForwardRs1 = 1;
        end
        else if (i_ForwardingSignals.WB_RegWrite &&
                 i_ForwardingSignals.WB_rd == i_rs1 &&
                 i_ForwardingSignals.WB_rd != 0)
        begin
            o_ForwardedRs1Value = i_ForwardingSignals.WB_Value;
            o_ForwardRs1 = 1;
        end
        else begin
            o_ForwardedRs1Value = 32'hcafebabe;
            o_ForwardRs1 = 0;
        end

        if (i_ForwardingSignals.MEM_RegWrite &&
            i_ForwardingSignals.MEM_rd == i_rs2 &&
            i_ForwardingSignals.MEM_rd != 0)
        begin
            o_ForwardedRs2Value = i_ForwardingSignals.MEM_Value;
            o_ForwardRs2 = 1;
        end
        else if (i_ForwardingSignals.WB_RegWrite &&
                 i_ForwardingSignals.WB_rd == i_rs2 &&
                 i_ForwardingSignals.WB_rd != 0)
        begin
            o_ForwardedRs2Value = i_ForwardingSignals.WB_Value;
            o_ForwardRs2 = 1;
        end
        else begin
            o_ForwardedRs2Value = 32'hcafebabe;
            o_ForwardRs2 = 0;
        end

    end

endmodule
