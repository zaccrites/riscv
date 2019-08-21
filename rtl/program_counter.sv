
// TODO: Add exception support

`include "branch_defs.sv"

module program_counter(
    input i_Clock,
    input i_Reset,

    input i_Jump,
    input i_Branch,
    input [2:0] i_BranchType,
    input [31:0] i_BranchAddress,
    input i_AluZero,
    input i_AluLessThan,
    input i_AluLessThanUnsigned,

    output [31:0] o_InstructionPointer
);

    logic [31:0] r_InstructionPointer;

    logic w_DoBranch;
    always_comb begin
        w_DoBranch = i_Branch && (
            (i_BranchType == `BRANCH_EQ && i_AluZero) ||
            (i_BranchType == `BRANCH_NE && ! i_AluZero) ||
            (i_BranchType == `BRANCH_LT && i_AluLessThan) ||
            (i_BranchType == `BRANCH_GE && ! i_AluLessThan) ||
            (i_BranchType == `BRANCH_LTU && i_AluLessThanUnsigned) ||
            (i_BranchType == `BRANCH_GEU && ! i_AluLessThanUnsigned)
        );
    end

    always_ff @ (posedge i_Clock) begin
        if (i_Reset) begin
            r_InstructionPointer <= 0;
        end
        else begin
            if (i_Jump || w_DoBranch)
                r_InstructionPointer <= i_BranchAddress;
            else begin
                r_InstructionPointer <= r_InstructionPointer + 4;
            end
        end
    end

    assign o_InstructionPointer = r_InstructionPointer;

endmodule
