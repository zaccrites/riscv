
// TODO: Split this up?

`ifndef PIPELINE_SIGNALS_SVH
`define PIPELINE_SIGNALS_SVH

// TODO: Use enums instead of `defines for these signals?


// typedef struct packed
// {
//     logic
// } IF_Output_Signals_t;


typedef struct packed
{
    logic Jump;
    logic Branch;
    logic JALR;                       // Is this the only "ID" control signal?
} ID_IF_Control_t;

typedef struct packed
{
    logic [1:0] AluSrc1;
    logic [1:0] AluSrc2;
    logic [2:0] AluOp;
    logic AluOpAlt;
} EX_Control_t;


typedef struct packed
{
    logic [2:0] MemMode;
    logic MemRead;
    logic MemWrite;
} MEM_Control_t;


// typedef struct packed
// {
//     ID_IF_Control_t ID_IF_Control;
//     EX_Control_t EX_Control;
//     MEM_Control_t MEM_Control;
// } ID_Output_Signals;




typedef struct packed
{
    logic WritebackSrc;
    logic RegWrite;
} WB_Control_t;



typedef struct packed
{
    logic [4:0] rs1;
    logic [4:0] rs2;
    logic [4:0] rd;
} RegisterIDs_t;



typedef struct packed
{
    logic RegWrite;
    logic [31:0] Value;
    logic [4:0] rd;
} WritebackSignals_t;



// typedef struct packed
// {
//     logic [31:0] PC;
//     logic [31:0] NextPC;
//     logic [31:0] InstructionWord;
// } IF_Output_Signals_t;


// typedef struct packed
// {
//     logic [31:0] BranchTarget;
// } IF_Feedback_Signals_t;





// typedef struct packed
// {

// } IF_ID_Pipeline_Signals_t;


// typedef struct packed
// {

// } ID_EX_Pipeline_Signals_t;




`endif
