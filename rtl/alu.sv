
`include "cpudefs.h"


module alu(
    input [3:0] i_AluOp,
    input [31:0] i_Source1,
    input [31:0] i_Source2,
    input i_UnsignedCompare,

    output [31:0] o_Output
    output o_Zero,
    output o_LessThan,
);

    logic w_RightShiftDataIn;
    logic [31:0] w_RightShiftStages [4:0];
    logic [31:0] w_LeftShiftStages  [4:0];

    logic [32:0] w_Result;
    logic w_ResultOverflow;
    logic w_ResultSign;

    logic w_Zero;
    logic w_LessThan;
    logic [31:0] w_Output;

    // TODO: Verify that the Xilinx synthesis tools generate reasonable
    // output for this. If not, optimize until they do.
    always_comb begin

        // Each stage shifts by a power of two bits: 1, 2, 4, 8, 16
        // These can be combined to shift up to 31 bits.
        w_LeftShiftStages[0] = i_Source2[0] ? {i_Source1[30:0], 1'b0} : i_Source1;
        w_LeftShiftStages[1] = i_Source2[1] ? {w_LeftShiftStages[0][29:0], 2'b0} : w_LeftShiftStages[0];
        w_LeftShiftStages[2] = i_Source2[2] ? {w_LeftShiftStages[1][27:0], 4'b0} : w_LeftShiftStages[1];
        w_LeftShiftStages[3] = i_Source2[3] ? {w_LeftShiftStages[2][23:0], 8'b0} : w_LeftShiftStages[2];
        w_LeftShiftStages[4] = i_Source2[4] ? {w_LeftShiftStages[3][15:0], 16'b0} : w_LeftShiftStages[3];

        // Right shifts can shift in zeros (logical)
        // or the original sign bit (arithmetic)
        w_RightShiftDataIn = (i_AluOp == ALUOP_SRA) ? i_Source1[31] : 1'b0;
        w_RightShiftStages[0] = i_Source2[0] ? {{1{w_RightShiftDataIn}}, i_Source1[30:0]} : i_Source1;
        w_RightShiftStages[1] = i_Source2[1] ? {{2{w_RightShiftDataIn}}, w_RightShiftStages[0][29:0]} : i_Source1;
        w_RightShiftStages[2] = i_Source2[2] ? {{4{w_RightShiftDataIn}}, w_RightShiftStages[1][27:0]} : i_Source1;
        w_RightShiftStages[3] = i_Source2[3] ? {{8{w_RightShiftDataIn}}, w_RightShiftStages[2][23:0]} : i_Source1;
        w_RightShiftStages[4] = i_Source2[4] ? {{16{w_RightShiftDataIn}}, w_RightShiftStages[3][15:0]} : i_Source1;

        case (i_AluOp) begin
            ALUOP_AND : w_Result = {1'b0, i_Source1 & i_Source2};
            ALUOP_OR  : w_Result = {1'b0, i_Source1 | i_Source2};
            ALUOP_XOR : w_Result = {1'b0, i_Source1 ^ i_Source2};
            ALUOP_ADD :            w_Result = i_Source1 + i_Source2;
            ALUOP_SUB, ALUOP_SLT : w_Result = i_Source1 - i_Source2;
            ALUOP_SLL :            w_Result = {1'b0, w_LeftShiftStages[4]};
            ALUOP_SRL, ALUOP_SRA : w_Result = {1'b0, w_RightShiftStages[4]};

            // FUTURE: Output 32'x instead? This should never happen,
            // but I'll output a recognizable pattern for debugging.
            default: w_Result = 33'h1BADF00D;
        endcase

        w_ResultOverflow = w_Result[32];
        w_ResultSign = w_Result[31];
        w_LessThan = i_UnsignedCompare
            ? ( ~ w_ResultOverflow)
            : (w_ResultOverflow ^ w_ResultSign);


        w_Zero = ~| w_Output;
        if (i_AluOp == ALUOP_SLT) begin
            w_Output = {31'b0, w_LessThan};
        end
        else begin
            w_Output = w_Result[31:0];
        end

    end

    assign o_Zero = w_Zero;
    assign o_LessThan = w_LessThan;
    assign o_Output = w_Output;

endmodule
