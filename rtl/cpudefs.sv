
`ifndef CPU_DEFS_SV
`define CPU_DEFS_SV


`define OPCODE_LOAD         5'b00000
`define OPCODE_LOAD_FP      5'b00001
`define OPCODE_CUSTOM_0     5'b00010
`define OPCODE_MISC_MEM     5'b00011
`define OPCODE_OP_IMM       5'b00100
`define OPCODE_AUIPC        5'b00101
`define OPCODE_OP_IMM_32    5'b00110
`define OPCODE_STORE        5'b01000
`define OPCODE_STORE_FP     5'b01001
`define OPCODE_CUSTOM_1     5'b01010
`define OPCODE_AMO          5'b01011
`define OPCODE_OP           5'b01100
`define OPCODE_LUI          5'b01101
`define OPCODE_OP_32        5'b01110
`define OPCODE_MADD         5'b10000
`define OPCODE_MSUB         5'b10001
`define OPCODE_NMSUB        5'b10010
`define OPCODE_NMADD        5'b10011
`define OPCODE_OP_FP        5'b10100
`define OPCODE_RESERVED_0   5'b10101
`define OPCODE_CUSTOM_2     5'b10110
`define OPCODE_BRANCH       5'b11000
`define OPCODE_JALR         5'b11001
`define OPCODE_RESERVED_1   5'b11010
`define OPCODE_JAL          5'b11011
`define OPCODE_SYSTEM       5'b11100
`define OPCODE_RESERVED_2   5`b11101
`define OPCODE_CUSTOM_3     5'b11110

`define ALIGNMENT_BYTE      2'b00
`define ALIGNMENT_HALF_WORD 2'b01
`define ALIGNMENT_WORD      2'b10

`define ALUOP_ADD   4'b0000
`define ALUOP_SUB   4'b0001
`define ALUOP_SLT   4'b0010
`define ALUOP_AND   4'b0011
`define ALUOP_OR    4'b0100
`define ALUOP_XOR   4'b0101
`define ALUOP_SLL   4'b0110
`define ALUOP_SRL   4'b1000
`define ALUOP_SRA   4'b1001




`endif
