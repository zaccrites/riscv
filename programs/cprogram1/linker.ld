

MEMORY
{
    INSTRUCTIONS (x)  : ORIGIN = 0x00000000, LENGTH = 32K
    DATA (rw)         : ORIGIN = 0x00008000, LENGTH = 32K
}


/* Align stack to 16 bytes */
_stack_start = (ORIGIN(DATA) + LENGTH(DATA) - 1) & 0xfffffff0;


SECTIONS
{
    .vector_table :
    {
        . = ALIGN(4);
        KEEP(*(.vector_table))
        . = ALIGN(4);
    } > INSTRUCTIONS

    _sitext = .;
    .text :
    {
        . = ALIGN(4);
        _stext = .;
        *(.text)
        *(.text*)
        _etext = .;
        . = ALIGN(4);
    } > INSTRUCTIONS

    _sidata = .;
    .data :
    {
        . = ALIGN(4);
        _sdata = .;
        *(.data)
        *(.data*)
        *(.rodata)
        *(.rodata*)
        . = ALIGN(4);
        _edata = .;
    } > DATA

    _sibss = .;
    .bss :
    {
        . = ALIGN(4);
        _sbss = .;
        *(.bss)
        *(.bss*)
        _ebss = .;
        . = ALIGN(4);
    } > DATA

}
