
`include "pipeline_signals.svh"


module stage_execution (
    input i_Clock,
    input i_Reset,


    input EX_Control_t i_EX_Control,
    input MEM_Control_t i_MEM_Control,
    input WB_Control_t i_WB_Control,

    output MEM_Control_t o_MEM_Control,
    output WB_Control_t o_WB_Control


    // input [1:0] i_AluSource1,
    // input [1:0] i_AluSource2,


    // // For forwarding
    // input [31:0] i_WritebackValue,
    // input i_rs1,
    // input i_rs2,
    // input i_EX_MEM_rd,
    // input i_MEM_WB_rd,


    // input i_MemRead,
    // input i_MemWrite,

    // output o_MemRead,
    // output o_MemWrite

);


    alu alu1 (

    );


    logic w_ForwardRs1;
    logic w_ForwardRs2;
    forwarding_unit fwd (
        .o_ForwardRs1(w_ForwardRs1),
        .o_ForwardRs2(w_ForwardRs2)
    );




    // TODO: Forwarding for these, when using register inputs
    logic [31:0] w_AluInput1;
    logic [31:0] w_AluInput2;
    always_comb
        case (i_AluSource1)
            `ALUSRC1_RS1     : w_AluInput1 = i_rs1Value;
            `ALUSRC1_PC      : w_AluInput1 = i_PC;
            `ALUSRC1_CONST_0 : w_AluInput1 = 32'h00000000;
            default          : w_AluInput1 = 32'hdeadbeef;
        endcase

        case (i_AluSource2)
            `ALUSRC2_RS2 : w_AluInput2 = i_rs2Value;
            `ALUSRC2_IMM : w_AluInput2 = i_ImmediateValue;
            `ALUSRC2_CONST_4 : w_AluInput2 = 32'h00000004;
            default          : w_AluInput2 = 32'hdeadbeef;
        endcase
    end


    always_ff @ (posedge i_Clock) begin
        if (i_Reset) begin
            o_MEM_Control.MemRead <= 0;
            o_MEM_Control.MemWrite <= 0;
            o_WB_Control.RegWrite <= 0;
        end
        else begin
            o_MEM_Control <= i_MEM_Control;
            o_WB_Control <= i_WB_Control;
        end
    end


endmodule
