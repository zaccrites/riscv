
module cpu (
    input i_Clock,
    input i_Reset,

    // TODO: Remove this
    output [31:0] o_PC,
    output [31:0] o_InstructionWord
);


// verilator lint_off UNUSED


logic [31:0] w_IF_ID_PC;
logic [31:0] w_IF_ID_NextPC;
logic [31:0] w_IF_ID_InstructionWord;
logic w_IF_ID_InstructionAddressMisaligned;
stage_instruction_fetch stage_IF (
    .i_Clock            (i_Clock),
    .i_Reset            (i_Reset),


    .i_BranchTarget     (w_BranchTarget),
    .o_NextPC           (w_IF_ID_NextPC),
    .o_InstructionWord  (w_IF_ID_InstructionWord),
    .o_PC               (w_IF_ID_PC),
    .o_InstructionAddressMisaligned  (w_IF_ID_InstructionAddressMisaligned)
);



logic [31:0] w_BranchTarget;
logic w_ID_EX_MemWrite;
logic [4:0] w_ID_EX_rs1;
logic [4:0] w_ID_EX_rs2;
logic [4:0] w_ID_EX_rd;
logic w_ID_EX_EnvCall;                      // REMOVE ME

logic [31:0] w_ID_EX_rs1Value;
logic [31:0] w_ID_EX_rs2Value;
logic [31:0] w_ID_EX_Immediate;
logic w_ID_EX_MemWrite;
logic w_ID_EX_MemRead;
// logic w_ID_EX_

// TODO: Can I use a SystemVerilog interfaces to reduce the amount of
// pipeline register name prefixing and typing?

stage_instruction_decode stage_ID (

    .o_WritebackSrc      (o_WritebackSrc),
    .o_AluSrc1           (o_AluSrc1),
    .o_AluSrc2           (o_AluSrc2),
    .o_IllegalInstruction(o_IllegalInstruction),
    .o_rs1Value          (w_ID_EX_rs1Value),
    .o_rs2Value          (w_ID_EX_rs2Value),
    .o_Immediate         (w_ID_EX_Immediate),
    .o_MemRead           (o_MemRead),
    .o_RegWrite          (o_RegWrite),
    .o_Function          (o_Function),
    .o_AluOp             (o_AluOp),
    .o_AluOpAlt          (o_AluOpAlt),



    .i_Clock       (i_Clock),
    .i_Reset       (i_Reset),
    .o_MemWrite    (w_ID_EX_MemWrite),

    .o_BranchTarget(w_BranchTarget),

    .i_InstructionWord   (w_IF_ID_InstructionWord),
    .i_NextPC            (w_IF_ID_NextPC),

    // .o_BranchTarget      (o_BranchTarget),

    .o_rs1               (w_ID_EX_rs1),
    .o_rs2               (w_ID_EX_rs2),
    .o_rd                (w_ID_EX_rd),

    .i_RegWrite (w_WB_RegWrite),
    .i_rd                (w_WB_rd),
    .i_WritebackValue    (w_WritebackValue),







    .o_EnvCall           (w_ID_EX_EnvCall)
);



// TODO
logic w_WB_RegWrite = 0;
logic [4:0] w_WB_rd = 5'b0;
logic [31:0] w_WritebackValue = 32'hdeadbeef;




/*
logic w_EX_MEM_MemWrite;
stage_execution stage_EX (
    .i_Clock  (i_Clock),
    .i_Reset  (i_Reset)
    .i_MemWrite(w_ID_EX_MemWrite),
    .o_MemWrite(w_EX_MEM_MemWrite)
);


logic w_MEM_WB_RegWrite;
logic w_MEM_WB_WritebackSrc;
stage_memory stage_MEM (
    .i_Clock     (i_Clock),
    .i_Reset     (i_Reset),

    .i_MemWrite  (w_EX_MEM_MemWrite)

    .o_RegWrite  (w_MEM_WB_RegWrite)
    .o_WritebackSrc (w_MEM_WB_WritebackSrc)
    .i_WritebackSrc(w_EX_MEM_WritebackSrc)
);


logic w_RegWrite;
logic w_WritebackValue;
stage_writeback stage_WB (
    .i_WritebackSource(w_MEM_WB_WritebackSrc),
    .i_RegWrite(w_MEM_WB_RegWrite),
    .o_RegWrite(w_RegWrite),
    .o_WritebackValue (w_WritebackValue),
);
*/


assign o_PC = w_IF_ID_PC;
assign o_InstructionWord = w_IF_ID_InstructionWord;


endmodule
