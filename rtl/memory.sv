
// Generic split memory module for now
// TODO: Replace with unified memory and a split cache

// Only the lower 16 address bits are considered for now
/* verilator lint_off UNUSED */


module memory(
    input i_Clock,
    input i_WriteEnable,
    input [31:0] i_Address,
    input [31:0] i_DataIn,

    output [31:0] o_DataOut
);

    logic [31:0] r_RAM [65535:0];



    // For now, the addresses are passed in are byte addresses,
    // but they are shifted into word addresses.
    // TODO: Make these memories properly byte addressable, but still
    // return a full word if needed.
    //
    // Maybe the full word is always obtained from and then it is just
    // shifted down into a 32-bit packet depending on the alignment.
    // This is awkward when accessing misaligned words or halfwords,
    // but the manual does say that misaligned accesses are not
    // guaranteed to be atomic and can even be handled in a software trap.
    logic [29:0] w_WordAddress = i_Address[31:2];

    // TODO: Move to a purely synchronous RAM once pipelined.
    // Will need an output-valid bit to stall the pipeline
    // on e.g. a cache miss.
    assign o_DataOut = r_RAM[w_WordAddress[15:0]];

    always_ff @ (posedge i_Clock) begin
        if (i_WriteEnable) begin
            r_RAM[w_WordAddress[15:0]] <= i_DataIn;
        end
    end






    // always_ff @ (posedge i_Clock) begin
    //     if (i_WriteEnable) begin
    //         r_RAM[w_WordAddress[15:0]] <= i_DataIn;
    //         o_DataOut <= i_DataIn;
    //     end
    //     else begin
    //         // TODO: Only trigger a cache miss if a ReadEnable
    //         // input is asserted.
    //         o_DataOut <= r_RAM[w_WordAddress[15:0]];
    //     end
    // end

endmodule
