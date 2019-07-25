
// Generic split memory module for now
// TODO: Replace with unified memory and a split cache

// Only the lower 16 address bits are considered for now
/* verilator lint_off UNUSED */


module memory(
    input i_Clock,
    input i_WriteEnable,
    input i_ReadEnable,
    input [31:0] i_Address,
    input [31:0] i_DataIn,

    output [31:0] o_DataOut
);

    // Limiting to 32K total for now.
    // That's 8096 32-bit words, for a byte-address of 15 bits.
    logic [31:0] r_RAM [8095:0];

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
    logic [12:0] w_WordAddress = i_Address[14:2];

    // TODO: Move to a purely synchronous RAM once pipelined.
    // Will need an output-valid bit to stall the pipeline
    // on e.g. a cache miss.
    assign o_DataOut = i_ReadEnable ? r_RAM[w_WordAddress] : 32'hffffffff;

    // TODO: HANDLE MISALIGNED AND NON-WORD READS/WRITES!!!

    always_ff @ (posedge i_Clock) begin
        if (i_WriteEnable) begin
            r_RAM[w_WordAddress] <= i_DataIn;
            $display("MEMORY: Wrote 0x%08x to address 0x%08x (word index %d)", i_DataIn, i_Address, w_WordAddress);
        end

        if (i_ReadEnable) begin
            $display("MEMORY: Read 0x%08x from address 0x%08x (word index %d)", o_DataOut, i_Address, w_WordAddress);
        end
    end

    // Reads or writes have some kind of bug:
    // MEMORY: Wrote 0x00000003 to address 0x0000ffdc (word index 8183)             << Writes 3 to 8183
    // Executed instruction word feb42423 at address 00000020
    // MEMORY: Read 0xfeb42423 from address 0x00000020 (word index    8)
    // MEMORY: Wrote 0x00000000 to address 0x0000ffd8 (word index 8182)
    // Executed instruction word fec42783 at address 00000024
    // MEMORY: Read 0xfec42783 from address 0x00000024 (word index    9)
    // MEMORY: Read 0x00000000 from address 0x0000ffdc (word index 8183)            << Reads 0     why?
    // Executed instruction word 00050f93 at address 00000028
    // MEMORY: Read 0x00050f93 from address 0x00000028 (word index   10)
    // Executed instruction word fec42f03 at address 0000002c
    // MEMORY: Read 0xfec42f03 from address 0x0000002c (word index   11)
    // MEMORY: Read 0x00000000 from address 0x0000ffdc (word index 8183)





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
