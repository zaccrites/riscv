
// Generic split memory module for now
// TODO: Replace with unified memory and a split cache

module memory(
    input i_Clock,
    input i_WriteEnable,
    input [31:0] i_Address,
    input [31:0], i_DataIn,
    output [31:0], o_DataOut);

    // Only the lower 16 bits are considered for now
    logic [31:0] r_RAM [65535:0]

    always_ff @ (posedge i_Clock) begin
        if (i_WriteEnable) begin
            r_RAM[i_Address[15:0]] <= i_DataIn;
            o_DataOut <= i_DataIn;
        end
        else begin
            o_DataOut <= r_RAM[i_Address[15:0]];
        end
    endmodule

endmodule
