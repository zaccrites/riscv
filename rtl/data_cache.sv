
`include "data_cache.svh"

module data_cache (
    input i_Clock,
    input i_Reset,

    input i_WriteEnable,
    input [2:0] i_Mode,

    // TODO
    // verilator lint_off UNUSED
    input i_ReadEnable,
    // verilator lint_on UNUSED

    // For now only using 32K of data memory.
    // When this uses the full 32 bits for cache tag and set mapping,
    // this warning will go away.
    //
    // verilator lint_off UNUSED
    input [31:0] i_Address,
    // verilator lint_on UNUSED

    input [31:0] i_DataIn,

    output [31:0] o_DataOut,
    output o_MisalignedAccess
);


// The cache words are split up into individual bytes
// to allow byte and halfword reads and writes.
logic [7:0] r_RAM [32 * 1024 / 4] [3:0];

logic [12:0] w_WordAddress;
assign w_WordAddress = i_Address[14:2];

logic [31:0] w_MemoryWord;
assign w_MemoryWord = {
    r_RAM[w_WordAddress][3],
    r_RAM[w_WordAddress][2],
    r_RAM[w_WordAddress][1],
    r_RAM[w_WordAddress][0]
};


logic [31:0] w_WriteData;
logic [31:0] w_ReadData;
logic [3:0] w_WriteEnable;
logic w_MisalignedAccess;

always_comb begin
    w_WriteData = i_DataIn;
    w_ReadData = w_MemoryWord;

    o_MisalignedAccess = 0;
    w_ReadData = 32'hdeadbeef;
    w_WriteData = 32'hdeadbeef;
    w_WriteEnable = 4'b0000;

    if (i_WriteEnable) begin
        case ({i_Mode, i_Address[1:0]})
            {`STORE_BYTE, 2'b00} : begin
                w_WriteEnable = 4'b0001;
                w_WriteData[7:0] = i_DataIn[7:0];
            end
            {`STORE_BYTE, 2'b01} : begin
                w_WriteEnable = 4'b0010;
                w_WriteData[15:8] = i_DataIn[7:0];
            end
            {`STORE_BYTE, 2'b10} : begin
                w_WriteEnable = 4'b0100;
                w_WriteData[23:16] = i_DataIn[7:0];
            end
            {`STORE_BYTE, 2'b11} : begin
                w_WriteEnable = 4'b1000;
                w_WriteData[31:24] = i_DataIn[7:0];
            end
            {`STORE_HALF, 2'b00} : begin
                w_WriteEnable = 4'b0011;
                w_WriteData[15:0] = i_DataIn[15:0];
            end
            {`STORE_HALF, 2'b10} : begin
                w_WriteEnable = 4'b1100;
                w_WriteData[31:16] = i_DataIn[15:0];
            end
            {`STORE_WORD, 2'b00} : begin
                w_WriteEnable = 4'b1111;
                w_WriteData = i_DataIn;
            end

            {`LOAD_HALF, 2'b01},
            {`LOAD_HALF, 2'b11},
            {`LOAD_WORD, 2'b01},
            {`LOAD_WORD, 2'b10},
            {`LOAD_WORD, 2'b11} : w_MisalignedAccess = 1;

            default: /* invalid mode, should be checked at instruction decode time */ ;
        endcase
    end
    else if (i_ReadEnable) begin
        case ({i_Mode, i_Address[1:0]})
            {`LOAD_BYTE, 2'b00} : w_ReadData = {{24{w_MemoryWord[7]}}, w_MemoryWord[7:0]};
            {`LOAD_BYTE, 2'b01} : w_ReadData = {{24{w_MemoryWord[15]}}, w_MemoryWord[15:8]};
            {`LOAD_BYTE, 2'b10} : w_ReadData = {{24{w_MemoryWord[23]}}, w_MemoryWord[23:16]};
            {`LOAD_BYTE, 2'b11} : w_ReadData = {{24{w_MemoryWord[31]}}, w_MemoryWord[31:24]};
            {`LOAD_BYTE_UNSIGNED, 2'b00} : w_ReadData = {24'b0, w_MemoryWord[7:0]};
            {`LOAD_BYTE_UNSIGNED, 2'b01} : w_ReadData = {24'b0, w_MemoryWord[15:8]};
            {`LOAD_BYTE_UNSIGNED, 2'b10} : w_ReadData = {24'b0, w_MemoryWord[23:16]};
            {`LOAD_BYTE_UNSIGNED, 2'b11} : w_ReadData = {24'b0, w_MemoryWord[31:24]};
            {`LOAD_HALF, 2'b00} : w_ReadData = {{16{w_MemoryWord[15]}}, w_MemoryWord[15:0]};
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
            {`LOAD_WORD, 2'b11} : w_MisalignedAccess = 1;

            default: /* invalid mode, should be checked at instruction decode time */ ;
        endcase
    end

    // TODO: Should this be synchronous?
    o_MisalignedAccess = w_MisalignedAccess && i_ReadEnable;
end


always_ff @ (posedge i_Clock) begin
    if (i_Reset) begin
        // TODO: Invalidate cache entries
        o_DataOut <= 32'h00000000;
    end
    else begin
        if (w_WriteEnable[3]) r_RAM[w_WordAddress][3] <= w_WriteData[31:24];
        if (w_WriteEnable[2]) r_RAM[w_WordAddress][2] <= w_WriteData[23:16];
        if (w_WriteEnable[1]) r_RAM[w_WordAddress][1] <= w_WriteData[15:8];
        if (w_WriteEnable[0]) r_RAM[w_WordAddress][0] <= w_WriteData[7:0];

        // TODO: Only raise exceptions if ReadEnable is asserted
        if (i_ReadEnable) begin
            $display("MEMORY: Reading word %08x from address %08x", w_ReadData, {16'h0000, w_WordAddress, 2'b00});
            o_DataOut <= w_ReadData;
        end
    end
end


endmodule
