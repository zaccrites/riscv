
module stage_execution (
    input i_Clock,
    input i_Reset,

    input [1:0] i_AluSource1,
    input [1:0] i_AluSource2,


    // For forwarding
    input [31:0] i_WritebackValue,
    input i_rs1,
    input i_rs2,
    input i_EX_MEM_rd,
    input i_MEM_WB_rd,


    input i_MemRead,
    input i_MemWrite,

    output o_MemRead,
    output o_MemWrite

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
            // Reset control signals
            o_MemRead <= 0;
            o_MemWrite <= 0;
        end
        else begin
            o_MemRead <= i_MemRead;
            o_MemWrite <= i_MemWrite;
        end
    end


endmodule
