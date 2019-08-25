
`include "exception_defs.sv"


module exception_unit(

    input i_ExternalInterrupt,
    input i_SoftwareInterrupt,
    input i_TimerInterrupt,

    input i_InstructionAddressMisaligned,
    input i_InstructionAccessFault,
    input i_IllegalInstruction,
    input i_EnvironmentBreak,
    input i_LoadAddressMisaligned,
    input i_LoadAccessFault,
    input i_EnvironmentCall,

    output o_Interrupt,
    output o_ExceptionRaised,
    output [3:0] o_ExceptionCause

);

    always_comb begin
        o_Interrupt = 0;
        o_ExceptionRaised = 1;

        // See section 3.1.9 of privileged arch spec for commentary on
        // the order of serviced interrupts.
        if (i_ExternalInterrupt) begin
            o_Interrupt = 1;
            o_ExceptionCause = `EXC_CODE_MACHINE_EXTERNAL_INT;
            $display("Exception Cause: EXC_CODE_MACHINE_EXTERNAL_INT");
        end
        else if (i_SoftwareInterrupt) begin
            o_Interrupt = 1;
            o_ExceptionCause = `EXC_CODE_MACHINE_SOFTWARE_INT;
            $display("Exception Cause: EXC_CODE_MACHINE_SOFTWARE_INT");
        end
        else if (i_TimerInterrupt) begin
            o_Interrupt = 1;
            o_ExceptionCause = `EXC_CODE_MACHINE_TIMER_INT;
            $display("Exception Cause: EXC_CODE_MACHINE_TIMER_INT");
        end

        // See Table 3.7 for synchronous exception handling order.
        // FUTURE: Instruction address breakpoint (different from EBREAK)
        // FUTURE: Instruction page fault
        else if (i_InstructionAccessFault) begin
            o_ExceptionCause = `EXC_CODE_INSTRUCION_ACCESS_FAULT;
            $display("Exception Cause: EXC_CODE_INSTRUCION_ACCESS_FAULT");
        end
        else if (i_IllegalInstruction) begin
            o_ExceptionCause = `EXC_CODE_ILLEGAL_INSTRUCTION;
            $display("Exception Cause: EXC_CODE_ILLEGAL_INSTRUCTION");
        end
        else if (i_InstructionAddressMisaligned) begin
            o_ExceptionCause = `EXC_CODE_INSTRUCION_ADDRESS_MISALIGNED;
            $display("Exception Cause: EXC_CODE_INSTRUCION_ADDRESS_MISALIGNED");
        end
        else if (i_EnvironmentCall) begin
            o_ExceptionCause = `EXC_CODE_ECALL_FROM_MMODE;
            $display("Exception Cause: EXC_CODE_ECALL_FROM_MMODE");
        end
        else if (i_EnvironmentBreak) begin
            o_ExceptionCause = `EXC_CODE_BREAKPOINT;
            $display("Exception Cause: EXC_CODE_BREAKPOINT");
        end
        // FUTURE: Load/store/AMO address breakpoint
        // FUTURE: Store/AMO address misaligned
        else if (i_LoadAddressMisaligned) begin
            o_ExceptionCause = `EXC_CODE_LOAD_ADDRESS_MISALIGNED;
            $display("Exception Cause: EXC_CODE_LOAD_ADDRESS_MISALIGNED");
        end
        // FUTURE: Store/AMO page fault
        // FUTURE: Load page fault
        // FUTURE: Store/AMO access fault
        else if (i_LoadAccessFault) begin
            o_ExceptionCause = `EXC_CODE_LOAD_ACCESS_FAULT;
            $display("Exception Cause: EXC_CODE_LOAD_ACCESS_FAULT");
        end

        else begin
            // TODO: Support other exceptions as features are added.
            o_ExceptionCause = 4'b0;
            o_ExceptionRaised = 0;
        end

    end

endmodule
