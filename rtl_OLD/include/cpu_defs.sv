
`ifndef CPU_DEFS_SV
`define CPU_DEFS_SV


`define ALUSRC1_RS1      2'b00
`define ALUSRC1_PC       2'b01
`define ALUSRC1_CONST_0  2'b10

`define ALUSRC2_RS2      2'b00
`define ALUSRC2_IMM      2'b01
`define ALUSRC2_CONST_4  2'b10

`define WBSRC_ALU  2'b00
`define WBSRC_MEM  2'b01
`define WBSRC_CSR  2'b10

`define CSRSRC_RS1  0
`define CSRSRC_IMM  1


`endif
