
`ifndef CSR_DEFS_SV
`define CSR_DEFS_SV

`include "programming_defs.sv"



`define CSR_ACCESS_READONLY  2'b11
// READWRITE: 00, 01, or 10

`define CSR_PRIV_MACHINE     2'b11
`define CSR_PRIV_HYPERVISOR  2'b10
`define CSR_PRIV_SUPERVISOR  2'b01
`define CSR_PRIV_USER        2'b00


// See Table 2.5 of RISC-V Privileged Specification
`define CSR_NUM_MVENDORID      12'hf11
`define CSR_NUM_MARCHID        12'hf12
`define CSR_NUM_MIMPID         12'hf13
`define CSR_NUM_MHARTID        12'hf14
//
`define CSR_NUM_MSTATUS        12'h300
`define CSR_NUM_MISA           12'h301
//
`define CSR_NUM_MIE            12'h304
`define CSR_NUM_MTVEC          12'h305
//
`define CSR_NUM_MSCRATCH       12'h340
`define CSR_NUM_MEPC           12'h341
`define CSR_NUM_MCAUSE         12'h342
`define CSR_NUM_MTVAL          12'h343
`define CSR_NUM_MIP            12'h344



// FUTURE: Update MISA as extensions are added.
`define CSR_CONST_MISA         32'b01_0000_00000000000000000100000000
`define CSR_CONST_MVENDORID    32'b0000000000000000000000000_0000000
`define CSR_CONST_MARCHID      32'b00000000000000000000000000000000
`define CSR_CONST_MIMPID       32'b00000000000000000000000000000000
`define CSR_CONST_MTVEC        {`INTERRUPT_VECTOR_ADDRESS[31:2], 2'b00}

`endif
