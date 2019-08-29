
`include "csr_defs.sv"

// verilator lint_off UNUSED


module csr_file (
    input i_Clock,
    input i_Reset,

    input [11:0] i_CsrNumber,
    input [2:0] i_AluOp,
    input [31:0] i_InputData,

    // Input signals used to set CSRs
    input i_ExceptionRaised,
    input i_Interrupt,
    input [3:0] i_ExceptionCause,
    input [31:0] i_ExceptionInstructionPointer,

    // Output CSRs used by other modules
    output [31:0] o_mepc,
    // output [31:0] o_mie,


    input i_ReadEnable,
    input i_WriteEnable,


    output [31:0] o_OutputData
);

    assign o_mepc = r_mepc;


    // logic [31:0] r_mie;  // Machine interrupt enable
    // logic [31:0] r_mip;  // Machine interrupts pending  // TODO
    // logic [31:0] r_status;  // Machine status register  (for e.g. MIE, MPIE, etc.)
    // logic [31:0] r_mscratch;  // Machine scratch register
    logic [31:0] r_mepc;  // Machine exception program counter
    logic [31:0] r_mcause;
    logic [31:0] r_mtval;


    // TODO: mtime, mtimecmp for machine mode timer interrupt



    // Only raise an invalid access exception if read enabled.
    // logic w_CsrReadEnable;
    // logic w_CsrWriteEnable;
    //




    logic [31:0] w_CsrOldValue;
    logic [31:0] w_CsrNewValue;
    assign o_OutputData = w_CsrOldValue;  // ???


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

            // `CSR_NUM_MSCRATCH : w_CsrOldValue = r_mscratch;
            `CSR_NUM_MEPC : w_CsrOldValue = r_mepc;
            `CSR_NUM_MCAUSE : w_CsrOldValue = r_mcause;
            `CSR_NUM_MTVAL : w_CsrOldValue = r_mtval;
            // `CSR_NUM_MIP : w_CsrOldValue = r_mip;

            //
            default : w_CsrOldValue = 0;

        endcase
        w_Output = w_CsrOldValue;





        case (i_AluOp)
            // TODO: Use a proper CSRALUOP instead of just the same FUNCT defines?
            `SYSTEM_FUNCT_CSRRW, `SYSTEM_FUNCT_CSRRWI : w_CsrNewValue = w_CsrOldValue;
            `SYSTEM_FUNCT_CSRRS, `SYSTEM_FUNCT_CSRRSI : w_CsrNewValue = w_CsrOldValue | i_InputData;
            `SYSTEM_FUNCT_CSRRC, `SYSTEM_FUNCT_CSRRCI : w_CsrNewValue = w_CsrOldValue & ~i_InputData;
            default: begin
                // This is checked by the instruction decode unit
                w_CsrNewValue = 32'hxxxxxxxx;
            end
        endcase






    end



    logic [31:0] w_Output;

    always_ff @ (posedge i_Clock) begin
        if (i_Reset) begin
            // r_mie <= 0;  // Machine interrupt enable
            // r_mscratch <= 0;  // Machine scratch register
            r_mepc <= 0;  // Machine exception program counter
            r_mcause <= 0;
            r_mtval <= 0;
        end
        else begin



            if (i_ExceptionRaised) begin
                r_mepc <= i_ExceptionInstructionPointer;
                r_mcause <= {i_Interrupt, 27'b0, i_ExceptionCause};

                // TODO: Set mtval with exception-specific info,
                // such as the target address of a misaligned LOAD/STORE
                r_mtval <= 0;

                $display("CSR: Writing %08x to mepc", i_ExceptionInstructionPointer);
                $display("     mcause is %08x", r_mcause);
            end




            // if (w_CsrWriteEnable) begin

            //     // If access is illegal, then trigger exception

            //     // Or is that setup before the clock, then ON the clock
            //     // control is transferred? We can detect the exception
            //     // combinatorially and trap on the clock.


            //     // TODO: Just focus on reading them for now
            //     case (i_CsrNumber)
            //         // `CSR_NUM_MTVEC    : r_mtvec     <= w_CsrNewValue;
            //         // `CSR_NUM_MIP      : r_mip       <= w_CsrNewValue;
            //         // `CSR_NUM_MSCRATCH : r_mscratch  <= w_CsrNewValue;
            //         // `CSR_NUM_MEPC     : r_mepc      <= w_CsrNewValue;

            //         default: begin
            //             // TODO: It could also be read only. Raise exception if so.
            //             // Some, like misa might technically be writable,
            //             // but this implementation ignores such writes.
            //             $display("WARNING: Tried to write to unimplemented CSR 0x%03x", i_CsrNumber);
            //         end
            //     endcase

            // end

        end

    end




endmodule
