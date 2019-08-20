
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


    logic [7:0] r_RAM ['hffff / 4] [3:0];
    logic [3:0] w_WriteEnable;



    logic [13:0] w_WordAddress;
    assign w_WordAddress = i_Address[15:2];

    logic [31:0] w_MemoryWord;
    assign w_MemoryWord = {
        r_RAM[w_WordAddress][3],
        r_RAM[w_WordAddress][2],
        r_RAM[w_WordAddress][1],
        r_RAM[w_WordAddress][0]
    };




    logic [31:0] w_WriteData;
    logic [31:0] w_ReadData;


    logic w_InvalidMode;
    logic w_Misaligned;

    assign o_DataOut = w_ReadData;
    assign o_MisalignedAccess = w_Misaligned;
    assign o_BadInstruction = w_InvalidMode;


    always_comb begin
        w_WriteData = i_DataIn;
        w_ReadData = {
            r_RAM[w_WordAddress][3],
            r_RAM[w_WordAddress][2],
            r_RAM[w_WordAddress][1],
            r_RAM[w_WordAddress][0]
        };


        w_Misaligned = 0;
        w_InvalidMode = 0;
        w_ReadData = {32{1'bx}};
        w_WriteData = {32{1'bx}};
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
                {`LOAD_WORD, 2'b11} : w_Misaligned = 1;
                default: w_InvalidMode = 1;
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
                {`LOAD_WORD, 2'b11} : w_Misaligned = 1;
                default : w_InvalidMode = 1;
            endcase
        end
    end

    always_ff @ (posedge i_Clock) begin
        // TODO: Only write some bytes if writing a half or byte
        if (w_WriteEnable[3]) r_RAM[w_WordAddress][3] <= w_WriteData[31:24];
        if (w_WriteEnable[2]) r_RAM[w_WordAddress][2] <= w_WriteData[23:16];
        if (w_WriteEnable[1]) r_RAM[w_WordAddress][1] <= w_WriteData[15:8];
        if (w_WriteEnable[0]) r_RAM[w_WordAddress][0] <= w_WriteData[7:0];

        if (i_WriteEnable) begin
            $display("MEMORY: Tried to write %08x to address %08x", w_WriteData, i_Address);
        end

        if (i_ReadEnable) begin
            // TODO: Synchronous read
        end
    end

endmodule
