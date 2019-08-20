
# TODO: Merge with runtime.c using inline assembly?


.section .text
.global _write
_write:
    # Write a string to the console, for implementing e.g. printf
    # a0: pointer to null-terminated string
    mv a1, a0
    li a0, 3
    ecall
    ret
