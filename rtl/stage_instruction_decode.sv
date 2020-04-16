
`include "pipeline_signals.svh"


module stage_instruction_decode (
    input i_Clock,
    input i_Reset,

    input [31:0] i_InstructionWord,
    input i_InstructionWordValid,

    input [31:0] i_PC,
    input [31:0] i_NextPC,
    output [31:0] o_BranchTarget,



    // These are sent back from the WB stage.
    input WritebackSignals_t i_WritebackSignals,


    // output [1:0] o_AluSrc1,
    // output [1:0] o_AluSrc2,
    // output o_WritebackSrc,

    output o_IllegalInstruction,

    // output [31:0] o_rs1Value,
    // output [31:0] o_rs2Value,
    // output [31:0] o_Immediate,

    output ID_IF_Control_t o_ID_IF_Control,
    output EX_Control_t o_EX_Control,
    output MEM_Control_t o_MEM_Control,
    output WB_Control_t o_WB_Control,
    output RegisterIDs_t o_RegisterIDs,

    output [31:0] o_PC,
    output [31:0] o_Immediate,
    output [31:0] o_rs1Value,
    output [31:0] o_rs2Value,

    // TODO: Remove this
    output o_EnvCall
);



    EX_Control_t w_EX_Control;
    MEM_Control_t w_MEM_Control;
    WB_Control_t w_WB_Control;

    RegisterIDs_t w_RegisterIDs;


    logic [31:0] w_Immediate;


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

    logic w_IllegalInstruction;
    assign o_IllegalInstruction = w_IllegalInstruction;


    decode_unit decode (
        .i_InstructionWord      (i_InstructionWord),


        .o_IF_Control        (o_IF_Control),
        .o_EX_Control        (w_EX_Control),
        .o_MEM_Control       (w_MEM_Control),
        .o_WB_Control        (w_WB_Control),
        .o_RegisterIDs       (w_RegisterIDs),

        .o_Immediate         (w_Immediate),

        .o_EnvBreak             (w_EnvBreak),
        .o_EnvCall              (w_EnvCall),
        .o_IllegalInstruction   (w_IllegalInstruction)


    );

    register_file registers (
        .i_Clock         (i_Clock),
        .i_DataIn        (i_WritebackSignals.Value),
        .i_WriteEnable   (i_WritebackSignals.RegWrite),
        .i_RegDest       (i_WritebackSignals.rd),
        .i_RegSource1    (w_RegisterIDs.rs1),
        .i_RegSource2    (w_RegisterIDs.rs2),
        .o_DataOut1      (o_rs1Value),
        .o_DataOut2      (o_rs2Value)
    );

    always_comb begin
        // TODO: Implement branching
        o_BranchTarget = i_NextPC;

        // TODO: Implement exception trapping
        // o_EnvBreak = w_EnvBreak;
        // o_IllegalInstruction = w_IllegalInstruction
        o_EnvCall = w_EnvCall;

    end


    // TODO: Implement hazard detection
    logic w_Stall = 0;


    always_ff @ (posedge i_Clock) begin
        // $display("The word is %08x  (valid? = %d)", i_InstructionWord, i_InstructionWordValid);
        if (i_Reset || w_Stall || ! i_InstructionWordValid) begin
            o_MEM_Control.MemRead <= 0;
            o_MEM_Control.MemWrite <= 0;
            o_WB_Control.RegWrite <= 0;
        end
        else begin
            o_MEM_Control <= w_MEM_Control;
            o_EX_Control <= w_EX_Control;
            o_WB_Control <= w_WB_Control;
            o_RegisterIDs <= w_RegisterIDs;

            // NOTE: Register outputs are already updated synchronously
            o_Immediate <= w_Immediate;
            o_PC <= i_PC;
        end
    end

endmodule
