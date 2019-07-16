
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

    always_ff @ (posedge i_Clock) begin
        if (i_WriteEnable) begin

        end
        else begin

        end
    end

endmodule
