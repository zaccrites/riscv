
// TODO: Rename this file
// TODO: Split this up
// TODO: Use enums instead of `defines


`ifndef PIPELINE_SIGNALS_SVH
`define PIPELINE_SIGNALS_SVH






typedef struct packed
{
    logic Jump;
    logic Branch;
    logic JALR;                       // Is this the only "ID" control signal?
} IF_Control_t;


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


typedef struct packed
{
    logic WritebackSrc;
    logic RegWrite;
} WB_Control_t;



// TODO: Do more of this.
// Does it hurt parameterization? I suppose the 31 can be `defined
typedef logic [31:0] DataWord_t;
typedef logic [31:0] Address_t;

typedef logic [4:0] RegisterID_t;


typedef struct packed
{
    RegisterID_t rs1;
    RegisterID_t rs2;
    RegisterID_t rd;
} RegisterIDs_t;



typedef struct packed
{
    logic RegWrite;
    logic [31:0] Value;
    RegisterID_t rd;
} WritebackSignals_t;



// TODO: Move to forwarding_unit.svh?
typedef struct packed
{
    logic MEM_RegWrite;
    RegisterID_t MEM_rd;
    logic [31:0] MEM_Value;

    logic WB_RegWrite;
    RegisterID_t WB_rd;
    logic [31:0] WB_Value;
} ForwardingSignals_t;




`endif
