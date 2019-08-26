
module instruction_cache (
    input i_Clock,
    input i_Reset,


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

    // TODO: Make this an actual cache, reading from main memory on a miss.

    // TODO: Access fault?


    // Similarly, this is "undriven" from Verilator's point of view.
    // I fill it in via the C++ interface.
    // Once this is a proper cache it will be driven.
    //
    // verilator lint_off UNDRIVEN
    logic [31:0] r_RAM [32 * 1024 / 4];
    // verilator lint_on UNDRIVEN


    logic [12:0] w_WordAddress;
    assign w_WordAddress = i_Address[14:2];

    // logic r_DataValid;
    // assign o_DataValid = r_DataValid;

    logic [31:0] r_DataOut;
    assign o_DataOut = r_DataOut;

    logic w_AddressMisaligned;
    assign o_AddressMisaligned = w_AddressMisaligned;


    always_comb begin
        w_AddressMisaligned = i_Address[1:0] != 2'b00;
    end

    always_ff @ (posedge i_Clock) begin
        if (i_Reset) begin
            // r_DataValid <= 0;
            r_DataOut <= 32'h00000000;
        end
        else begin
            // o_DataValid <= ! o_AddressMisaligned;
            r_DataOut <= r_RAM[w_WordAddress];
        end
    end


endmodule
