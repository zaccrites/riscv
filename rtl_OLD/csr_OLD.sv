
`include "csr_defs.sv"


module csr_file (
    input i_Clock,

    input [2:0] i_AluOp,

    // ???
    input [2:0] i_ExceptionSource,


    input [11:0] i_CsrNumber,

    input [4:0] i_rd,

    // input [31:0] i_sourceRegValue,
    // input [4:0] i_uimm,
    input [31:0] i_InputData,



    input i_ReadEnable,
    input i_WriteEnable,




    // TODO: What to do about these registers written by the machine itself?
    input i_mepc_WriteEnable,
    input [31:0] i_mepc,



    output [31:0] o_OutputData
);

    // logic [31:0] r_mip;  // Machine interrupts pending
    logic [31:0] r_mie;  // Machine interrupt enable
    logic [31:0] r_mscratch;  // Machine scratch register
    logic [31:0] r_mepc;  // Machine exception program counter
    logic [31:0] r_mcause;
    logic [31:0] r_mtval;


    // Only raise an invalid access exception if read enabled.
    logic w_CsrReadEnable;
    //


    logic w_CsrWriteEnable;

    logic w_InvalidOp;


    logic [31:0] w_CsrOldValue;
    logic [31:0] w_CsrNewValue;


    logic [1:0] w_CsrReadWriteAccess;
    logic [1:0] w_CsrRequiredPrivilegeLevel;

    always_comb begin

        // TODO: Raise exception if writing a readonly CSR.
        // Same for accessing a privileged register outside the right mode,
        // but for now only M mode is supported anyway.
        w_CsrReadWriteAccess = i_CsrNumber[11:10];
        w_CsrRequiredPrivilegeLevel = i_CsrNumber[9:8];



        case (i_CsrNumber)
            `CSR_NUM_MVENDORID : w_CsrOldValue = `CSR_CONST_MVENDORID;
            `CSR_NUM_MARCHID : w_CsrOldValue = `CSR_CONST_MARCHID;
            `CSR_NUM_MIMPID : w_CsrOldValue = `CSR_CONST_MIMPID;
            `CSR_NUM_MHARTID : w_CsrOldValue = 0;  // TODO: With multiple cores, this will be different.

            `CSR_NUM_MISA : w_CsrOldValue = `CSR_CONST_MISA;

            `CSR_NUM_MSCRATCH : w_CsrOldValue = r_mscratch;
            `CSR_NUM_MEPC : w_CsrOldValue = r_mepc;
            `CSR_NUM_MCAUSE : w_CsrOldValue = r_mcause;
            `CSR_NUM_MTVAL : w_CsrOldValue = r_mtval;
            // `CSR_NUM_MIP : w_CsrOldValue = r_mip;


        endcase
        w_Output = w_CsrOldValue;





        w_InvalidOp = 0;
        case (i_AluOp)
            // TODO: Use a proper CSRALUOP instead of just the same FUNCT defines?
            `SYSTEM_FUNCT_CSRRW, `SYSTEM_FUNCT_CSRRWI : w_CsrNewValue = w_CsrOldValue;
            `SYSTEM_FUNCT_CSRRS, `SYSTEM_FUNCT_CSRRSI : w_CsrNewValue = w_CsrOldValue | i_InputData;
            `SYSTEM_FUNCT_CSRRC, `SYSTEM_FUNCT_CSRRCI : w_CsrNewValue = w_CsrOldValue & ~i_InputData;
            default: begin
                w_CsrNewValue = 32'hxxxxxxxx;
                w_InvalidOp = 1;
            end
        endcase






    end



    logic [31:0] w_Output;

    always_ff @ (posedge i_Clock) begin


        if (w_CsrWriteEnable) begin

            // If access is illegal, then trigger exception

            // Or is that setup before the clock, then ON the clock
            // control is transferred? We can detect the exception
            // combinatorially and trap on the clock.


            case (i_CsrNumber)
                `CSR_NUM_MTVEC    : r_mtvec     <= w_CsrNewValue;
                `CSR_NUM_MIP      : r_mip       <= w_CsrNewValue;
                `CSR_NUM_MIE      : r_mie       <= w_CsrNewValue;
                `CSR_NUM_MSCRATCH : r_mscratch  <= w_CsrNewValue;
                `CSR_NUM_MEPC     : r_mepc      <= w_CsrNewValue;

                default: begin
                    // TODO: It could also be read only. Raise exception if so.
                    // Some, like misa might technically be writable,
                    // but this implementation ignores such writes.
                    $display("WARNING: Tried to write to unimplemented CSR 0x%03x", i_CsrNumber);
                end
            endcase

        end







    end




endmodule
