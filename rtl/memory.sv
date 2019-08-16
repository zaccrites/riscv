
`include "cpudefs.sv"

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
    input [2:0] i_Mode,
    output [31:0] o_DataOut
);

    logic [31:0] w_WriteData;
    logic [31:0] w_ReadData;
    logic [31:0] w_RAMData;

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
    logic [12:0] w_WordAddress;
    assign w_WordAddress = i_Address[14:2];

    // TODO: Move to a purely synchronous RAM once pipelined.
    // Will need an output-valid bit to stall the pipeline
    // on e.g. a cache miss.

    assign o_DataOut = i_ReadEnable ? w_ReadData : 32'hffffffff;

    // TODO: Raise exception on misaligned memory read/write

    logic w_Misaligned;
    logic w_InvalidMode;

    assign w_RAMData = r_RAM[w_WordAddress];
    always_comb begin

        w_Misaligned = 0;
        w_InvalidMode = 0;
        w_ReadData = 32'hffffffff;
        w_WriteData = 32'hffffffff;

        if (i_ReadEnable) begin
            case ({i_Mode, i_Address[1:0]})
                {`LOAD_BYTE, 2'b00} : w_ReadData = {{24{w_RAMData[31]}}, w_RAMData[7:0]};
                {`LOAD_BYTE, 2'b01} : w_ReadData = {{24{w_RAMData[31]}}, w_RAMData[15:8]};
                {`LOAD_BYTE, 2'b10} : w_ReadData = {{24{w_RAMData[31]}}, w_RAMData[23:16]};
                {`LOAD_BYTE, 2'b11} : w_ReadData = {{24{w_RAMData[31]}}, w_RAMData[31:24]};
                {`LOAD_BYTE_UNSIGNED, 2'b00} : w_ReadData = {24'b0, w_RAMData[7:0]};
                {`LOAD_BYTE_UNSIGNED, 2'b01} : w_ReadData = {24'b0, w_RAMData[15:8]};
                {`LOAD_BYTE_UNSIGNED, 2'b10} : w_ReadData = {24'b0, w_RAMData[23:16]};
                {`LOAD_BYTE_UNSIGNED, 2'b11} : w_ReadData = {24'b0, w_RAMData[31:24]};
                {`LOAD_HALF, 2'b00} : w_ReadData = {{16{w_RAMData[31]}}, w_RAMData[15:0]};
                {`LOAD_HALF, 2'b10} : w_ReadData = {{16{w_RAMData[31]}}, w_RAMData[31:16]};
                {`LOAD_HALF_UNSIGNED, 2'b00} : w_ReadData = {16'b0, w_RAMData[15:0]};
                {`LOAD_HALF_UNSIGNED, 2'b10} : w_ReadData = {16'b0, w_RAMData[31:16]};
                {`LOAD_WORD, 2'b00} : w_ReadData = w_RAMData;

                {`LOAD_HALF, 2'b01},
                {`LOAD_HALF, 2'b11},
                {`LOAD_HALF_UNSIGNED, 2'b01},
                {`LOAD_HALF_UNSIGNED, 2'b11},
                {`LOAD_WORD, 2'b01},
                {`LOAD_WORD, 2'b10},
                {`LOAD_WORD, 2'b11} : w_Misaligned = 1;
                default : w_InvalidMode = 1;
            endcase
        end

        // TODO: How to write a single byte or half? Read the value first,
        // modify, then write back? Xilinx block RAMs have a per-byte write
        // enable which could help (at least for write-back cache writes),
        // but the bytes are 9 bits, so a 36-bit cache word would have to
        // ignore every ninth bit, rather than the last 4 bits of the 36
        // bit word.
        //
        // if (i_WriteEnable) begin
        //     case ({i_Mode, i_Address[1:0]})
        //         // TODO
        //     endcase
        // end

    end


    always_ff @ (posedge i_Clock) begin
        if (i_WriteEnable) begin
            r_RAM[w_WordAddress] <= i_DataIn;
        end

        if (i_ReadEnable) begin
            // TODO
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
