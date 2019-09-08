
`include "pipeline_signals.svh"


module cpu (
    input i_Clock,
    input i_Reset,

    // TODO: Remove these
    output [31:0] o_PC,
    output [31:0] o_InstructionWord,
    //
    output o_IllegalInstruction,
    output o_EnvCall

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


ID_IF_Control_t w_ID_IF_Control;     // TODO: could use better name
EX_Control_t w_ID_EX_Control;
MEM_Control_t w_ID_MEM_Control;
WB_Control_t w_ID_WB_Control;
RegisterIDs_t w_ID_RegisterIDs;

logic [31:0] w_ID_rs1Value;
logic [31:0] w_ID_rs2Value;
logic [31:0] w_ID_Immediate;



// TODO
WritebackSignals_t w_WritebackSignals;
assign w_WritebackSignals.RegWrite = 0;
assign w_WritebackSignals.Value = 0;
assign w_WritebackSignals.rd = 0;



stage_instruction_decode stage_ID (
    .i_Clock             (i_Clock),
    .i_Reset             (i_Reset),

    .i_NextPC            (w_IF_ID_NextPC),
    .i_InstructionWord   (w_IF_ID_InstructionWord),
    .i_WritebackSignals  (w_WritebackSignals),

    .o_BranchTarget      (w_BranchTarget),

    .o_ID_IF_Control     (w_ID_IF_Control),
    .o_EX_Control        (w_ID_EX_Control),
    .o_MEM_Control       (w_ID_MEM_Control),
    .o_WB_Control        (w_ID_WB_Control),
    .o_RegisterIDs       (w_ID_RegisterIDs),

    .o_rs1Value          (w_ID_rs1Value),
    .o_rs2Value          (w_ID_rs2Value),
    .o_Immediate         (w_ID_Immediate),


    // TODO: Remove these
    .o_IllegalInstruction(o_IllegalInstruction),
    .o_EnvCall           (o_EnvCall)

);



// TODO
logic w_WB_RegWrite = 0;
logic [4:0] w_WB_rd = 5'b0;
logic [31:0] w_WritebackValue = 32'hdeadbeef;




MEM_Control_t w_EX_MEM_Control;
WB_Control_t w_EX_WB_Control;




/*
logic w_EX_MEM_MemWrite;
stage_execution stage_EX (
    .i_Clock  (i_Clock),
    .i_Reset  (i_Reset)
    .i_MemWrite(w_ID_EX_MemWrite),
    .o_MemWrite(w_EX_MEM_MemWrite)
);
*/



WB_Control_t w_MEM_WB_Control;

/*
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
