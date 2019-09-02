
`ifndef DECODE_UNIT_SVH
`define DECODE_UNIT_SVH


`define OPCODE_LOAD         5'b00000
// `define OPCODE_LOAD_FP      5'b00001
// `define OPCODE_CUSTOM_0     5'b00010
// `define OPCODE_MISC_MEM     5'b00011
`define OPCODE_OP_IMM       5'b00100
`define OPCODE_AUIPC        5'b00101
// `define OPCODE_OP_IMM_32    5'b00110
`define OPCODE_STORE        5'b01000
// `define OPCODE_STORE_FP     5'b01001
// `define OPCODE_CUSTOM_1     5'b01010
// `define OPCODE_AMO          5'b01011
`define OPCODE_OP           5'b01100
`define OPCODE_LUI          5'b01101
// `define OPCODE_OP_32        5'b01110
// `define OPCODE_MADD         5'b10000
// `define OPCODE_MSUB         5'b10001
// `define OPCODE_NMSUB        5'b10010
// `define OPCODE_NMADD        5'b10011
// `define OPCODE_OP_FP        5'b10100
// `define OPCODE_RESERVED_0   5'b10101
// `define OPCODE_CUSTOM_2     5'b10110
`define OPCODE_BRANCH       5'b11000
`define OPCODE_JALR         5'b11001
// `define OPCODE_RESERVED_1   5'b11010
`define OPCODE_JAL          5'b11011
`define OPCODE_SYSTEM       5'b11100
// `define OPCODE_RESERVED_2   5`b11101
// `define OPCODE_CUSTOM_3     5'b11110


`define WBSRC_ALU   1'h0
`define WBSRC_MEM   1'h1

`define ALUSRC1_RS1      2'h0
`define ALUSRC1_PC       2'h1
`define ALUSRC1_CONST_0  2'h2

`define ALUSRC2_RS2      2'h0
`define ALUSRC2_IMM      2'h1
`define ALUSRC2_CONST_4  2'h2


`define SYSTEM_FUNCT_ECALL   12'b000000000000
`define SYSTEM_FUNCT_EBREAK  12'b000000000001


`endif
