
module forwarding_unit (
    input i_rs1,
    input i_rs2,
    input i_MEM_rd,
    input i_WB_rd,

    input i_MEM_RegWrite,
    input i_WB_RegWrite,

    // output o_ForwardRs1FromMEM,
    // output o_ForwardRs1FromWB,
    // output o_ForwardRs2FromMEM,
    // output o_ForwardRs2FromWB


    input [31:0] i_MEM_rs1Value,
    input [31:0] i_MEM_rs2Value,
    input [31:0] i_WB_rs1Value,
    input [31:0] i_WB_rs2Value,


    output [31:0] o_ForwardedRs1Value,
    output [31:0] o_ForwardedRs2Value

);


    // TODO: I *may* have to rename some signals, since what I'm
    // calling e.g. "MEM_RegisterIDs" is actually the synchronously
    // set pipeline register output from the MEM stage, rather than
    // the one acctually "used" in the MEM stage.


    always_comb begin

        // The synchronous data memory may complicate forwarding.
        // It may have to techincally come from the WB stage,
        // but still one clock cycle before the register is actually
        // written.

    end


endmodule
