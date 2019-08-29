

.section .text
.global context_switch
context_switch:

    # TODO: program counter, CSRs, etc.

    # a0: uint32_t* from_registers    (state of the suspending process)
    # a1: uint32_t* to_registers      (state of the resuming process)


    # TODO: Can I do the register saving in an interrupt handler?
    # Otherwise how do I save e.g. the argument registers?
    # Calling context_switch inside reschedule() isn't enough.


    # https://github.com/xinu-os/xinu/blob/master/system/arch/mips/ctxsw.S

    sw x1, 0(a0)
    sw x2, 4(a0)
    sw x3, 8(a0)
    sw x4, 12(a0)
    sw x5, 14(a0)
    sw x6, 16(a0)
    sw x7, 20(a0)
    sw x8, 24(a0)
    sw x9, 28(a0)
    sw x10, 32(a0)
    sw x11, 36(a0)
    sw x12, 40(a0)
    sw x13, 44(a0)
    sw x14, 48(a0)
    sw x15, 52(a0)
    sw x16, 56(a0)
    sw x17, 60(a0)
    sw x18, 64(a0)
    sw x19, 68(a0)
    sw x20, 72(a0)
    sw x21, 76(a0)
    sw x22, 80(a0)
    sw x23, 84(a0)
    sw x24, 88(a0)
    sw x25, 92(a0)
    sw x26, 96(a0)
    sw x27, 100(a0)
    sw x28, 104(a0)
    sw x29, 108(a0)
    sw x30, 112(a0)
    sw x31, 116(a0)



    lw x31, 116(a1)
    lw x30, 112(a1)
    lw x29, 108(a1)
    lw x28, 104(a1)
    lw x27, 100(a1)
    lw x26, 96(a1)
    lw x25, 92(a1)
    lw x24, 88(a1)
    lw x23, 84(a1)
    lw x22, 80(a1)
    lw x21, 76(a1)
    lw x20, 72(a1)
    lw x19, 68(a1)
    lw x18, 64(a1)
    lw x17, 60(a1)
    lw x16, 56(a1)
    lw x15, 52(a1)
    lw x14, 48(a1)
    lw x13, 44(a1)
    lw x12, 40(a1)
    # wait to set a1 until after the reset are done
    lw x10, 32(a1)
    lw x9, 28(a1)
    lw x8, 24(a1)
    lw x7, 20(a1)
    lw x6, 16(a1)
    lw x5, 14(a1)
    lw x4, 12(a1)
    lw x3, 8(a1)
    lw x2, 4(a1)
    lw x1, 0(a1)
    lw a1, 36(a1)

    # Return as the resumed process
    ret
