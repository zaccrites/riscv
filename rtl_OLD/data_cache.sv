
module data_cache (
    input i_Clock,
    input i_Reset,

    input i_WriteEnable,
    input [31:0] i_DataIn,

    // For now only using 32K of program memory.
    // When this uses the full 32 bits for cache tag and set mapping,
    // this warning will go away.
    //
    // verilator lint_off UNUSED
    input [31:0] i_Address,
    // verilator lint_on UNUSED

    // output o_DataValid,
    output [31:0] o_DataOut,

    output o_AddressMisaligned
);

    // Similarly, this is "undriven" from Verilator's point of view.
    // I fill it in via the C++ interface.
    // Once this is a proper cache it will be driven.
    //
    // verilator lint_off UNDRIVEN
    logic [7:0] r_RAM [32 * 1024 / 4] [4];
    // verilator lint_on UNDRIVEN

    logic [12:0] w_WordAddress;
    assign w_WordAddress = [i_Address[14:2]];


    // TODO: Read halfwords and bytes
    always_comb begin
        o_AddressMisaligned = i_Address[1:0] != 2'b00;
    end

    always_ff @ (posedge i_Clock) begin
        if (i_Reset) begin
            o_DataOut <= 32'h00000000;
        end
        else begin
            if (i_WriteEnable) begin
                o_DataOut <= i_DataIn;
                r_RAM[w_WordAddress] <= i_DataIn;
            end
            else begin
                o_DataOut <= r_RAM[w_WordAddress];
            end
        end
    end


endmodule
