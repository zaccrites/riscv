
module register_file(
    input i_Clock,
    input i_WriteEnable,
    input [4:0] i_RegDest,
    input [4:0] i_RegSource1,
    input [4:0] i_RegSource2,
    input [31:0] i_DataIn,

    output [31:0] o_DataOut1,
    output [31:0] o_DataOut2
);

    logic [31:0] r_Registers [31:1];

    // TODO: Make sure the Xilinx tools infer a RAM with WRITE_FIRST
    always_ff @ (posedge i_Clock) begin
        if (i_WriteEnable && i_RegDest != 5'b0) begin
            r_Registers[i_RegDest] <= i_DataIn;
        end
    end

    assign o_DataOut1 = (i_RegSource1 == 5'b0) ? 32'b0 : r_Registers[i_RegSource1];
    assign o_DataOut2 = (i_RegSource2 == 5'b0) ? 32'b0 : r_Registers[i_RegSource2];

endmodule
