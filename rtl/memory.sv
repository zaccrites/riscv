
`include "cpudefs.sv"

// Generic split memory module for now
// TODO: Replace with unified memory and a split cache

// Only the lower 16 address bits are considered for now
/* verilator lint_off UNUSED */
`define NUM_WORDS  8096


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


    // To get byte-addressible writes, I think I need to split up the
    // RAM into four byte-memories instead of a single wide word-memory.
    // They will be individually written to and read from.
    logic [7:0] r_RAM [`NUM_WORDS] [4];



    logic [31:0] w_MemoryWord;
    logic [12:0] w_WordAddress;
    assign w_WordAddress = i_Address[14:2];
    // assign w_MemoryWord = r_RAM[w_WordAddress];







    logic [31:0] w_WriteData;
    logic [31:0] w_ReadData;


    assign o_DataOut = w_ReadData;
    assign o_MisalignedAccess = 0;
    assign o_BadInstruction = 0;


    always_comb begin
        w_WriteData = i_DataIn;
        w_ReadData = {r_RAM[w_WordAddress][3], r_RAM[w_WordAddress][2], r_RAM[w_WordAddress][1], r_RAM[w_WordAddress][0]};
    end


    always_ff @ (posedge i_Clock) begin
        // TODO: Only write some bytes if writing a half or byte
        if (i_WriteEnable) begin
            r_RAM[w_WordAddress][3] <= w_WriteData[31:24];
            r_RAM[w_WordAddress][2] <= w_WriteData[23:16];
            r_RAM[w_WordAddress][1] <= w_WriteData[15:8];
            r_RAM[w_WordAddress][0] <= w_WriteData[7:0];
        end

        if (i_ReadEnable) begin
            // TODO
        end
    end



endmodule
