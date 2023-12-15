.macro CODE_BEGIN name
	.section .text.\name, "ax", %progbits
	.global \name
	.type \name, %function
	.align 2
	.cfi_startproc
\name:
.endm

.macro CODE_END
	.cfi_endproc
.endm

/* Size of stack to reserve for the context. Adjust this along with CtxStackSize in inline_impl.cpp */
.set CTX_STACK_SIZE, 0x310

/* For these macros, LR is deliberately not backed up as that's handled by the entry's entrypoint. */
.macro armBackupRegisters
    sub sp, sp, CTX_STACK_SIZE
    stp x0, x1, [sp, #0x00]
    stp x2, x3, [sp, #0x10]
    stp x4, x5, [sp, #0x20]
    stp x6, x7, [sp, #0x30]
    stp x8, x9, [sp, #0x40]
    stp x10, x11, [sp, #0x50]
    stp x12, x13, [sp, #0x60]
    stp x14, x15, [sp, #0x70]
    stp x16, x17, [sp, #0x80]
    stp x18, x19, [sp, #0x90]
    stp x20, x21, [sp, #0xA0]
    stp x22, x23, [sp, #0xB0]
    stp x24, x25, [sp, #0xC0]
    stp x26, x27, [sp, #0xD0]
    stp x28, x29, [sp, #0xE0]
    stp q0, q1, [sp, #0x100]
    stp q2, q3, [sp, #0x120]
    stp q4, q5, [sp, #0x140]
    stp q6, q7, [sp, #0x160]
    stp q8, q9, [sp, #0x180]
    stp q10, q11, [sp, #0x1A0]
    stp q12, q13, [sp, #0x1C0]
    stp q14, q15, [sp, #0x1E0]
    stp q16, q17, [sp, #0x200]
    stp q18, q19, [sp, #0x220]
    stp q20, q21, [sp, #0x240]
    stp q22, q23, [sp, #0x260]
    stp q24, q25, [sp, #0x280]
    stp q26, q27, [sp, #0x2A0]
    stp q28, q29, [sp, #0x2C0]
    stp q30, q31, [sp, #0x2E0]
.endm

.macro armRecoverRegisters
    ldp x0, x1, [sp, #0x00]
    ldp x2, x3, [sp, #0x10]
    ldp x4, x5, [sp, #0x20]
    ldp x6, x7, [sp, #0x30]
    ldp x8, x9, [sp, #0x40]
    ldp x10, x11, [sp, #0x50]
    ldp x12, x13, [sp, #0x60]
    ldp x14, x15, [sp, #0x70]
    ldp x16, x17, [sp, #0x80]
    ldp x18, x19, [sp, #0x90]
    ldp x20, x21, [sp, #0xA0]
    ldp x22, x23, [sp, #0xB0]
    ldp x24, x25, [sp, #0xC0]
    ldp x26, x27, [sp, #0xD0]
    ldp x28, x29, [sp, #0xE0]
    ldp q0, q1, [sp, #0x100]
    ldp q2, q3, [sp, #0x120]
    ldp q4, q5, [sp, #0x140]
    ldp q6, q7, [sp, #0x160]
    ldp q8, q9, [sp, #0x180]
    ldp q10, q11, [sp, #0x1A0]
    ldp q12, q13, [sp, #0x1C0]
    ldp q14, q15, [sp, #0x1E0]
    ldp q16, q17, [sp, #0x200]
    ldp q18, q19, [sp, #0x220]
    ldp q20, q21, [sp, #0x240]
    ldp q22, q23, [sp, #0x260]
    ldp q24, q25, [sp, #0x280]
    ldp q26, q27, [sp, #0x2A0]
    ldp q28, q29, [sp, #0x2C0]
    ldp q30, q31, [sp, #0x2E0]
    add sp, sp, CTX_STACK_SIZE
.endm

CODE_BEGIN exl_inline_hook_impl
    armBackupRegisters

    /* LR contains a pointer to the called entry here. */
    mov x19, lr

    /* Load inline context for the first argument of the callback. */
    mov x0, sp
    /* Load then call callback. */
    ldr x20, [x19, #0x8]
    blr x20

    /* Keep a hold of entry pointer before restoring all the registers. */
    mov lr, x19

    armRecoverRegisters

    /* Return to entry. */
    ret
CODE_END
