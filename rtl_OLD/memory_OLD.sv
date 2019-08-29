
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

    output [31:0] o_DataOut,
    output o_MisalignedAccess,
    output o_BadInstruction
);

    logic [31:0] w_MemoryWord;
    logic [31:0] w_WriteData;
    logic [31:0] w_ReadData;

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
    assign w_MemoryWord = r_RAM[w_WordAddress];

    // TODO: Move to a purely synchronous RAM once pipelined.
    // Will need an output-valid bit to stall the pipeline
    // on e.g. a cache miss.

    assign o_DataOut = w_ReadData;

    // TODO: Raise exception on misaligned memory read/write

    logic w_Misaligned;
    logic w_InvalidMode;
    assign o_MisalignedAccess = w_Misaligned;
    assign o_BadInstruction = w_InvalidMode;

    always_comb begin
        w_Misaligned = 0;
        w_InvalidMode = 0;
        w_ReadData = 32'hffffffff;
        w_WriteData = 32'hffffffff;

        if (i_WriteEnable) begin
            case ({i_Mode, i_Address[1:0]})
                // Replace individual bytes from the existing memory word
                // before writing back.
                {`STORE_BYTE, 2'b00} : w_WriteData = {w_MemoryWord[31:8], i_DataIn[7:0]};
                {`STORE_BYTE, 2'b01} : w_WriteData = {w_MemoryWord[31:16], i_DataIn[15:8], w_MemoryWord[7:0]};
                {`STORE_BYTE, 2'b10} : w_WriteData = {w_MemoryWord[31:24], i_DataIn[23:16], w_MemoryWord[15:0]};
                {`STORE_BYTE, 2'b11} : w_WriteData = {i_DataIn[31:24], w_MemoryWord[23:0]};
                {`STORE_HALF, 2'b00} : w_WriteData = {w_MemoryWord[31:16], i_DataIn[15:0]};
                {`STORE_HALF, 2'b10} : w_WriteData = {i_DataIn[31:16], w_MemoryWord[15:0]};
                {`STORE_WORD, 2'b00} : w_WriteData = i_DataIn;

                {`LOAD_HALF, 2'b01},
                {`LOAD_HALF, 2'b11},
                {`LOAD_WORD, 2'b01},
                {`LOAD_WORD, 2'b10},
                {`LOAD_WORD, 2'b11} : w_Misaligned = 1;
                default: w_InvalidMode = 1;

            endcase

            $display("write_enable: w_WriteData = %08x", w_WriteData);
        end
        else if (i_ReadEnable) begin
            case ({i_Mode, i_Address[1:0]})
                {`LOAD_BYTE, 2'b00} : w_ReadData = {{24{w_MemoryWord[31]}}, w_MemoryWord[7:0]};
                {`LOAD_BYTE, 2'b01} : w_ReadData = {{24{w_MemoryWord[31]}}, w_MemoryWord[15:8]};
                {`LOAD_BYTE, 2'b10} : w_ReadData = {{24{w_MemoryWord[31]}}, w_MemoryWord[23:16]};
                {`LOAD_BYTE, 2'b11} : w_ReadData = {{24{w_MemoryWord[31]}}, w_MemoryWord[31:24]};
                {`LOAD_BYTE_UNSIGNED, 2'b00} : w_ReadData = {24'b0, w_MemoryWord[7:0]};
                {`LOAD_BYTE_UNSIGNED, 2'b01} : w_ReadData = {24'b0, w_MemoryWord[15:8]};
                {`LOAD_BYTE_UNSIGNED, 2'b10} : w_ReadData = {24'b0, w_MemoryWord[23:16]};
                {`LOAD_BYTE_UNSIGNED, 2'b11} : w_ReadData = {24'b0, w_MemoryWord[31:24]};
                {`LOAD_HALF, 2'b00} : w_ReadData = {{16{w_MemoryWord[31]}}, w_MemoryWord[15:0]};
                {`LOAD_HALF, 2'b10} : w_ReadData = {{16{w_MemoryWord[31]}}, w_MemoryWord[31:16]};
                {`LOAD_HALF_UNSIGNED, 2'b00} : w_ReadData = {16'b0, w_MemoryWord[15:0]};
                {`LOAD_HALF_UNSIGNED, 2'b10} : w_ReadData = {16'b0, w_MemoryWord[31:16]};
                {`LOAD_WORD, 2'b00} : w_ReadData = w_MemoryWord;

                {`LOAD_HALF, 2'b01},
                {`LOAD_HALF, 2'b11},
                {`LOAD_HALF_UNSIGNED, 2'b01},
                {`LOAD_HALF_UNSIGNED, 2'b11},
                {`LOAD_WORD, 2'b01},
                {`LOAD_WORD, 2'b10},
                {`LOAD_WORD, 2'b11} : w_Misaligned = 1;
                default : w_InvalidMode = 1;
            endcase

            $display("read_enable: w_ReadData = %08x", w_ReadData);
        end
    end


    always_ff @ (posedge i_Clock) begin
        if (i_WriteEnable) begin
            r_RAM[w_WordAddress] <= w_WriteData;
            $display("MEMORY: Wrote 0x%08x to address 0x%08x", w_WriteData, w_WordAddress);
        end

        if (i_ReadEnable) begin
            $display("MEMORY: Read 0x%08x from address 0x%08x (word=%08x)", w_ReadData, i_Address, w_MemoryWord);
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
