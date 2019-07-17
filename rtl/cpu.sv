
module cpu(
    input i_Clock,
    input i_Reset
);


    logic w_InstructionPointer;
    logic [31:0] w_InstructionWord;

    program_counter pc(
        .i_Clock(i_Clock),
        .i_Reset(i_Reset),
        .o_InstructionPointer(w_InstructionPointer)
    );

    memory instruction_memory(
        .i_Clock(i_Clock),
        .i_WriteEnable(0),
        .i_Address(w_InstructionPointer),
        .i_DataIn(32'b0),
        .o_DataOut(w_InstructionWord)
    );



    logic w_MemWrite;
    logic [31:0] w_MemAddress;
    logic [31:0] w_MemData;

    memory data_memory(
        i_Clock(i_Clock),
        i_WriteEnable(w_MemWrite),
        i_Address(w_MemAddress),
        i_DataIn(w_RegSource1Data),
        o_DataOut(w_MemData)
    );








    instruction_decode decode(

    );




    logic w_RegWrite;
    logic w_RegDest;
    logic w_RegSource1;
    logic w_RegSource2;
    logic [31:0] w_RegSource1Data;
    logic [31:0] w_RegSource2Data;
    logic [31:0] w_RegWriteBackData;

    register_file registers(
        .i_Clock(i_Clock),
        .i_WriteEnable(w_RegWrite),
        .i_RegDest(w_RegDest),
        .i_RegSource1(w_RegSource1),
        .i_RegSource2(w_RegSource2),
        .i_DataIn(w_RegWriteBackData),
        .o_DataOut1(w_RegSource1Data),
        .o_DataOut2(w_RegSource2Data)
    );





    // input i_Clock,
    // input i_WriteEnable,
    // input [4:0] i_RegDest,
    // input [4:0] i_RegSource1,
    // input [4:0] i_RegSource2,

    // input [31:0] i_DataIn,
    // output [31:0] o_DataOut1,
    // output [31:0] o_DataOut2




    logic [4:0] w_AluOp;
    logic [31:0] w_AluSource1;
    logic [31:0] w_AluSource2;
    logic [31:0] w_AluOutput;
    logic w_AluOutputZero;
    logic w_AluUnsignedCompare;
    logic w_AluCompareLessThan;

    alu alu1(
        .i_AluOp(w_AluOp),
        .i_Source1(w_AluSource1),
        .i_Source2(w_AluSource2),
        .i_UnsignedCompare(w_AluUnsignedCompare),
        .o_Output(w_AluOutput)
        .o_Zero(w_AluOutputZero),
        .o_LessThan(w_AluOutputZero)
    );







endmodule
