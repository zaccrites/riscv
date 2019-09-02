
`include "alu.svh"


module alu (
    input [2:0] i_AluOp,
    input i_AluOpAlt,
    input [31:0] i_Source1,
    input [31:0] i_Source2,

    output o_Zero,
    output o_LessThan,
    output o_LessThanUnsigned,
    output [31:0] o_Output
);

    logic w_Subtract;
    logic [31:0] w_AdditionSource2;

    logic w_RightShiftDataIn;
    logic [31:0] w_RightShiftStages [4:0];
    logic [31:0] w_LeftShiftStages  [4:0];

    logic [32:0] w_Result;
    logic w_ResultSignedOverflow;
    logic w_ResultUnsignedOverflow;
    logic w_ResultSign;

    // TODO: Verify that the Xilinx synthesis tools generate reasonable
    // output for this. If not, optimize until they do.
    always_comb begin

        // TODO: Is this optimal? Does it use Xilinx carry logic properly?
        // Invert Source2 if subtracting
        w_Subtract = (i_AluOp == `ALUOP_ADD && i_AluOpAlt) || i_AluOp == `ALUOP_SLT || i_AluOp == `ALUOP_SLTU;
        w_AdditionSource2 = w_Subtract ? (( ~ i_Source2) + 1) : i_Source2;

        // Each stage shifts by a power of two bits: 1, 2, 4, 8, 16
        // These can be combined to shift up to 31 bits.
        w_LeftShiftStages[0] = i_Source2[0] ? {i_Source1[30:0], 1'b0} : i_Source1;
        w_LeftShiftStages[1] = i_Source2[1] ? {w_LeftShiftStages[0][29:0], 2'b0} : w_LeftShiftStages[0];
        w_LeftShiftStages[2] = i_Source2[2] ? {w_LeftShiftStages[1][27:0], 4'b0} : w_LeftShiftStages[1];
        w_LeftShiftStages[3] = i_Source2[3] ? {w_LeftShiftStages[2][23:0], 8'b0} : w_LeftShiftStages[2];
        w_LeftShiftStages[4] = i_Source2[4] ? {w_LeftShiftStages[3][15:0], 16'b0} : w_LeftShiftStages[3];

        // Right shifts can shift in zeros (logical)
        // or the original sign bit (arithmetic)
        w_RightShiftDataIn = i_AluOpAlt ? i_Source1[31] : 1'b0;
        w_RightShiftStages[0] = i_Source2[0] ? {{1{w_RightShiftDataIn}}, i_Source1[31:1]} : i_Source1;
        w_RightShiftStages[1] = i_Source2[1] ? {{2{w_RightShiftDataIn}}, w_RightShiftStages[0][31:2]} : w_RightShiftStages[0];
        w_RightShiftStages[2] = i_Source2[2] ? {{4{w_RightShiftDataIn}}, w_RightShiftStages[1][31:4]} : w_RightShiftStages[1];
        w_RightShiftStages[3] = i_Source2[3] ? {{8{w_RightShiftDataIn}}, w_RightShiftStages[2][31:8]} : w_RightShiftStages[2];
        w_RightShiftStages[4] = i_Source2[4] ? {{16{w_RightShiftDataIn}}, w_RightShiftStages[3][31:16]} : w_RightShiftStages[3];

        case (i_AluOp)
            `ALUOP_ADD,
            `ALUOP_SLT,
            `ALUOP_SLTU  : w_Result = i_Source1 + w_AdditionSource2;
            `ALUOP_AND   : w_Result = {1'b0, i_Source1 & i_Source2};
            `ALUOP_OR    : w_Result = {1'b0, i_Source1 | i_Source2};
            `ALUOP_XOR   : w_Result = {1'b0, i_Source1 ^ i_Source2};
            `ALUOP_SLL   : w_Result = {1'b0, w_LeftShiftStages[4]};
            `ALUOP_SRL   : w_Result = {1'b0, w_RightShiftStages[4]};
        endcase

        w_ResultSign = w_Result[31];
        w_ResultUnsignedOverflow = w_Result[32];
        if (w_Subtract) begin
            w_ResultSignedOverflow = (i_Source1[31] != i_Source2[31]) && (i_Source2[31] == w_ResultSign);
        end
        else begin
            w_ResultSignedOverflow = (i_Source1[31] == i_Source2[31]) && (i_Source2[31] != w_ResultSign);
        end
        o_LessThanUnsigned = ~ w_ResultUnsignedOverflow;
        o_LessThan = w_ResultSignedOverflow ^ w_ResultSign;

        case (i_AluOp)
            `ALUOP_SLT  : o_Output = {31'b0, w_LessThan};
            `ALUOP_SLTU : o_Output = {31'b0, w_LessThanUnsigned};
            default     : o_Output = w_Result[31:0];
        endcase
        o_Zero = ~| o_Output;

    end

endmodule
