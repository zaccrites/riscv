
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


assign o_PC = w_IF_PC;
assign o_InstructionWord = w_IF_InstructionWord;




logic [31:0] w_IF_PC;
logic [31:0] w_IF_NextPC;
logic [31:0] w_IF_InstructionWord;
logic w_IF_InstructionWordValid;

// TODO: Exceptions
// verilator lint_off UNUSED
logic w_IF_InstructionAddressMisaligned;
// verilator lint_on UNUSED

stage_instruction_fetch stage_IF (
    .i_Clock            (i_Clock),
    .i_Reset            (i_Reset),


    .i_BranchTarget     (w_BranchTarget),
    .o_NextPC           (w_IF_NextPC),
    .o_InstructionWord  (w_IF_InstructionWord),
    .o_InstructionWordValid (w_IF_InstructionWordValid),
    .o_PC               (w_IF_PC),
    .o_InstructionAddressMisaligned  (w_IF_InstructionAddressMisaligned)
);



logic [31:0] w_BranchTarget;


// TODO: Use this for branching
// verilator lint_off UNUSED
ID_IF_Control_t w_ID_IF_Control;     // TODO: could use better name
// verilator lint_on UNUSED

EX_Control_t w_ID_EX_Control;
MEM_Control_t w_ID_MEM_Control;
WB_Control_t w_ID_WB_Control;
RegisterIDs_t w_ID_RegisterIDs;

logic [31:0] w_ID_PC;
logic [31:0] w_ID_rs1Value;
logic [31:0] w_ID_rs2Value;
logic [31:0] w_ID_Immediate;



stage_instruction_decode stage_ID (
    .i_Clock             (i_Clock),
    .i_Reset             (i_Reset),

    .i_PC                (w_IF_PC),
    .i_NextPC            (w_IF_NextPC),
    .i_InstructionWord   (w_IF_InstructionWord),
    .i_InstructionWordValid (w_IF_InstructionWordValid),
    .i_WritebackSignals  (w_WritebackSignals),

    .o_BranchTarget      (w_BranchTarget),

    .o_ID_IF_Control     (w_ID_IF_Control),
    .o_EX_Control        (w_ID_EX_Control),
    .o_MEM_Control       (w_ID_MEM_Control),
    .o_WB_Control        (w_ID_WB_Control),
    .o_RegisterIDs       (w_ID_RegisterIDs),

    .o_PC                (w_ID_PC),
    .o_rs1Value          (w_ID_rs1Value),
    .o_rs2Value          (w_ID_rs2Value),
    .o_Immediate         (w_ID_Immediate),


    // TODO: Remove these
    .o_IllegalInstruction(o_IllegalInstruction),
    .o_EnvCall           (o_EnvCall)

);



MEM_Control_t w_EX_MEM_Control;
WB_Control_t w_EX_WB_Control;
RegisterID_t w_EX_rd;

logic [31:0] w_EX_AluOutput;
logic [31:0] w_EX_rs2Value;


stage_execution stage_EX (
    .i_Clock  (i_Clock),
    .i_Reset  (i_Reset),

    .i_rs1Value   (w_ID_rs1Value),
    .i_rs2Value   (w_ID_rs2Value),
    .i_Immediate  (w_ID_Immediate),

    .i_PC         (w_ID_PC),
    .i_RegisterIDs(w_ID_RegisterIDs),
    .i_EX_Control (w_ID_EX_Control),
    .i_MEM_Control(w_ID_MEM_Control),
    .i_WB_Control (w_ID_WB_Control),


    .i_ForwardingSignals('{
        // These use the values from a stage earlier because they need to
        // be the signals actually used during the stage, rather than
        // the ones output as pipeline registers by that stage.
        //
        // TODO: Rename these pipeline register signals for reasons such as these.
        MEM_rd: w_EX_rd,
        MEM_RegWrite: w_EX_WB_Control.RegWrite,
        MEM_Value: w_EX_AluOutput,

        // WB_rd: w_MEM_RegisterIDs.rd,
        WB_rd: w_MEM_rd,
        WB_RegWrite: w_MEM_WB_Control.RegWrite,
        WB_Value: w_WritebackSignals.Value
    }),


    .o_MEM_Control(w_EX_MEM_Control),
    .o_WB_Control (w_EX_WB_Control),
    .o_rd (w_EX_rd),

    .o_AluOutput  (w_EX_AluOutput),
    .o_rs2Value   (w_EX_rs2Value)
);




// TODO: Exceptions
// verilator lint_off UNUSED
logic w_MEM_DataAddressMisaligned;
// verilator lint_on UNUSED

WB_Control_t w_MEM_WB_Control;

RegisterID_t w_MEM_rd;

logic [31:0] w_MEM_AluOutput;
logic [31:0] w_MEM_MemoryValue;

stage_memory stage_MEM (
    .i_Clock     (i_Clock),
    .i_Reset     (i_Reset),

    .i_AluOutput  (w_EX_AluOutput),
    .o_AluOutput  (w_MEM_AluOutput),

    .o_MemoryValue(w_MEM_MemoryValue),

    .i_MEM_Control(w_EX_MEM_Control),
    .i_WB_Control (w_EX_WB_Control),

    .i_rs2Value   (w_EX_rs2Value),
    .i_rd     (w_EX_rd),
    .o_rd     (w_MEM_rd),

    .o_WB_Control (w_MEM_WB_Control),
    .o_MisalignedAccess(w_MEM_DataAddressMisaligned)
);



WritebackSignals_t w_WritebackSignals;

stage_writeback stage_WB (
    .i_WB_Control      (w_MEM_WB_Control),
    .i_rd              (w_MEM_rd),
    .i_AluOutput       (w_MEM_AluOutput),
    .i_MemoryValue     (w_MEM_MemoryValue),
    .o_WritebackSignals(w_WritebackSignals)
);




endmodule
