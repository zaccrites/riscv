
`ifndef EXCEPTION_DEFS_SV
`define EXCEPTION_DEFS_SV


// See RISC-V Privileged Architecture Spec Table 3.6
//
`define EXC_CODE_USER_SOFTWARE_INT        4'd0
`define EXC_CODE_SUPERVISOR_SOFTWARE_INT  4'd1
// reserved for future standard use
`define EXC_CODE_MACHINE_SOFTWARE_INT     4'd3
//
`define EXC_CODE_USER_TIMER_INT           4'd4
`define EXC_CODE_SUPERVISOR_TIMER_INT     4'd5
// reserved for future standard use
`define EXC_CODE_MACHINE_TIMER_INT        4'd7
//
`define EXC_CODE_USER_EXTERNAL_INT        4'd8
`define EXC_CODE_SUPERVISOR_EXTERNAL_INT  4'd9
// reserved for future standard use
`define EXC_CODE_MACHINE_EXTERNAL_INT     4'd11
//
// 12-15 reserved for future standard use
// >16 reserved for platform use
//
// ===
//
//
`define EXC_CODE_INSTRUCION_ADDRESS_MISALIGNED  4'd0
`define EXC_CODE_INSTRUCION_ACCESS_FAULT        4'd1
`define EXC_CODE_ILLEGAL_INSTRUCTION            4'd2
`define EXC_CODE_BREAKPOINT                     4'd3
`define EXC_CODE_LOAD_ADDRESS_MISALIGNED        4'd4
`define EXC_CODE_LOAD_ACCESS_FAULT              4'd5
`define EXC_CODE_STORE_AMO_ADDRESS_MISALIGNED   4'd6
`define EXC_CODE_STORE_AMO_ACCESS_FAULT         4'd7
`define EXC_CODE_ECALL_FROM_UMODE               4'd8
`define EXC_CODE_ECALL_FROM_SMODE               4'd9
// reserved for future standard use
`define EXC_CODE_ECALL_FROM_MMODE               4'd11
`define EXC_CODE_INSTRUCTION_PAGE_FAULT         4'd12
`define EXC_CODE_LOAD_PAGE_FAULT                4'd13
// reserved for future standard use
`define EXC_CODE_STORE_AMO_PAGE_FAULT           4'd15
// 16-23 reserved for future standard use
// 24-31 reserved for custom use
// 32-47 reserved for future standard use
// 48-63 reserved for custom use
// >64 reserved for future standard use


`endif
