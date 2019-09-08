
`include "stage_execution.svh"
`include "pipeline_signals.svh"


// TODO: Remove
// verilator lint_off UNUSED


module stage_execution (
    input i_Clock,
    input i_Reset,


    input EX_Control_t i_EX_Control,
    input MEM_Control_t i_MEM_Control,
    input WB_Control_t i_WB_Control,
    input RegisterIDs_t i_RegisterIDs,

    input [31:0] i_PC,
    input [31:0] i_rs1Value,
    input [31:0] i_rs2Value,
    input [31:0] i_Immediate,

    output MEM_Control_t o_MEM_Control,
    output WB_Control_t o_WB_Control,

    output [31:0] o_AluOutput,
    output [31:0] o_rs2Value



);


    logic w_Zero;
    logic w_LessThan;
    logic w_LessThanUnsigned;
    logic [31:0] w_AluOutput;
    alu alu1 (
        .i_AluOp           (i_EX_Control.AluOp),
        .i_AluOpAlt        (i_EX_Control.AluOpAlt),
        .i_Source1         (w_AluInput1),
        .i_Source2         (w_AluInput2),

        .o_Zero            (w_Zero),
        .o_LessThan        (w_LessThan),
        .o_LessThanUnsigned(w_LessThanUnsigned),
        .o_Output          (w_AluOutput)
    );


    // TODO: Forwarding
    //
    // logic w_ForwardRs1;
    // logic w_ForwardRs2;
    // logic [31:0] w_ForwardedRs1;
    // logic [31:0] w_ForwardedRs2;
    // forwarding_unit forwarding (
    //     .o_ForwardRs1(w_ForwardRs1),
    //     .o_ForwardRs2(w_ForwardRs2),

    //     .o_ForwardedRs1(w_ForwardedRs1),
    //     .o_ForwardedRs2(w_ForwardedRs2)
    // );


    logic [31:0] w_AluInput1;
    logic [31:0] w_AluInput2;
    always_comb begin
        case (i_EX_Control.AluSrc1)
            // `ALUSRC1_RS1     : w_AluInput1 = w_ForwardRs1 ? w_ForwardedRs1 : i_rs1Value;
            `ALUSRC1_RS1     : w_AluInput1 = i_rs1Value;
            `ALUSRC1_PC      : w_AluInput1 = i_PC;
            `ALUSRC1_CONST_0 : w_AluInput1 = 32'h00000000;
            default          : w_AluInput1 = 32'hdeadbeef;
        endcase

        case (i_EX_Control.AluSrc2)
            // `ALUSRC2_RS2 : w_AluInput2 = w_ForwardRs2 ? w_ForwardedRs2 : i_rs2Value;
            `ALUSRC2_RS2 : w_AluInput2 = i_rs2Value;
            `ALUSRC2_IMM : w_AluInput2 = i_Immediate;
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

            o_AluOutput <= w_AluOutput;
            o_rs2Value <= i_rs2Value;
        end
    end


endmodule
