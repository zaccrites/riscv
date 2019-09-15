
# Notes on the SoC

The end goal for this project is to have a working FPGA-based SoC
which can run simple retro-style games and applications.


## Processor

A 32-bit RISC-V processor. The initial focus will be the standard integer
ISA only, with the C, M, and A extensions implemented afterward.
Floating point will likely not be implemented until much later.

The initial processor will be in-order and single issue,
with a possible out-of-order and multiple issue implementation
to follow in the future.

It would be cool to implement multiple cores as well,
possibly even with multiple threads per core in the future.


## Graphics

The MVP of this design will implement a UART of some kind for
communications with a terminal. The progression of graphics
after that will follow something like this:

1. Single fixed text mode (VGA/SVGA)
2. Multiple text modes (VGA/SVGA)
3. Simple sprite graphics (VGA/SVGA)
4. Multi-layer sprite graphics (VGA/SVGA)
5. HDMI graphics
6. Investigate SNES-level 3D graphics


## Audio

The progression of audio will follow something like this:

1. Simple square wave generator (like PC speaker)
2. A few simple voices (GameBoy, NES, or C64 like)
3. FM synthesis (like OPL2 or OPL3)
4. PCM samples
