
module stage_instruction_decode (
    input i_Clock,
    input i_Reset,

    input [31:0] i_InstructionWord,

    input [31:0] i_NextPC,
    output [31:0] o_BranchTarget,



    output [4:0] o_rs1,
    output [4:0] o_rs2,
    output [4:0] o_rd,

    // These are sent back from the WB stage.
    input i_RegWrite,
    input [4:0] i_rd,
    input [31:0] i_WritebackValue,


    output [1:0] o_AluSrc1,
    output [1:0] o_AluSrc2,
    output o_WritebackSrc,

    output o_IllegalInstruction,

    output [31:0] o_rs1Value,
    output [31:0] o_rs2Value,
    output [31:0] o_Immediate,

    output o_MemRead,
    output o_MemWrite,
    output o_RegWrite,

    // output o_Jump,
    // output o_Branch,
    // output o_JALR,

    // TODO: Remove this
    output o_EnvCall,

    output [2:0] o_Function,
    output [2:0] o_AluOp,
    output o_AluOpAlt
);

    logic [31:0] w_Immediate;

    logic w_MemWrite;
    logic w_MemRead;
    logic w_RegWrite;

    logic w_Jump;
    logic w_JALR;
    logic w_Branch;
    logic [2:0] w_Function;
    logic [2:0] w_AluOp;
    logic w_AluOpAlt;

    // TODO: Implement exceptions
    //
    // verilator lint_off UNUSED
    //
    logic w_EnvBreak;
    logic w_EnvCall;
    // For now I'll just forward EnvCall so that it is seen by the
    // simulator at the WB stage.
    //
    // verilator lint_on UNUSED

    logic w_WritebackSrc;
    logic [1:0] w_AluSrc1;
    logic [1:0] w_AluSrc2;


    logic [4:0] w_rs1;
    logic [4:0] w_rs2;
    logic [4:0] w_rd;

    logic w_IllegalInstruction;
    assign o_IllegalInstruction = w_IllegalInstruction;

    decode_unit decode (
        .i_InstructionWord      (i_InstructionWord),

        .o_rs1                  (w_rs1),
        .o_rs2                  (w_rs2),
        .o_rd                   (w_rd),

        .o_WritebackSrc      (w_WritebackSrc),
        .o_Immediate         (w_Immediate),

        .o_MemWrite             (w_MemWrite),
        .o_RegWrite             (w_RegWrite),
        .o_Function             (w_Function),
        .o_Jump                 (w_Jump),
        .o_Branch               (w_Branch),
        .o_JALR                 (w_JALR),
        .o_AluSrc1              (w_AluSrc1),
        .o_AluOp                (w_AluOp),
        .o_AluSrc2              (w_AluSrc2),
        .o_EnvBreak             (w_EnvBreak),
        .o_EnvCall              (w_EnvCall),
        .o_MemRead              (w_MemRead),
        .o_IllegalInstruction   (w_IllegalInstruction),
        .o_AluOpAlt             (w_AluOpAlt)
    );

    register_file registers (
        .i_Clock         (i_Clock),
        .i_DataIn        (i_WritebackValue),
        .i_WriteEnable   (i_RegWrite),
        .i_RegDest       (i_rd),
        .i_RegSource1    (w_rs1),
        .i_RegSource2    (w_rs2),
        .o_DataOut1      (o_rs1Value),
        .o_DataOut2      (o_rs2Value)
    );

    always_ff @ (posedge i_Clock) begin
        if (i_Reset) begin
            o_MemRead <= 0;
            o_MemWrite <= 0;
            o_RegWrite <= 0;
        end
        else begin
            o_MemWrite <= w_MemWrite;
            o_MemRead <= w_MemRead;
            o_RegWrite <= w_RegWrite;

            o_AluSrc1 <= w_AluSrc1;
            o_AluSrc2 <= w_AluSrc2;
            o_WritebackSrc <= w_WritebackSrc;

            o_rs1 <= w_rs1;
            o_rs2 <= w_rs2;
            o_rd <= w_rd;

            o_Immediate <= w_Immediate;

            // TODO: Implement branching
            // o_Jump <= w_Jump;
            // o_JALR <= w_JALR;
            // o_Branch <= w_Branch;
            o_BranchTarget <= i_NextPC;


            o_Function <= w_Function;
            o_AluOp <= w_AluOp;
            o_AluOpAlt <= w_AluOpAlt;


            // TODO: Implement exception trapping
            // o_EnvBreak <= w_EnvBreak;
            // o_IllegalInstruction <= w_IllegalInstruction
            o_EnvCall <= w_EnvCall;




        end
    end




endmodule
