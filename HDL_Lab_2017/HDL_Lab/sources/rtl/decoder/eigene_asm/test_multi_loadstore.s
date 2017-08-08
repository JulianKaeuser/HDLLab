@filename: test_multi_loadstore.S

.text
.align 2
.global _start

_start:
mov r0, #5
mov r1, #10
mov r2, #15
mov r3, #20
mov r4, #25
mov r5, #30
mov r6, #35
mov r7, #40
stmia r0!, {r1-r7}
add r0, r1





/*                push	{r7, lr}
                add	r7, sp, #8
                ldr	r2, [pc, #32]	
                movs	r3, #0
                str	r3, [r2, #0]
                b	loopcheck
_loopstart:     ldr	r3, [pc, #24]	
                ldr	r3, [r3, #0]
                add	r2, r3, #1          // adds	r2, r3, #1
                ldr	r3, [pc, #20]	
                str	r2, [r3, #0]
_loopcheck:     ldr	r3, [pc, #16]
                ldr	r3, [r3, #0]
                cmp	r3, #31
                ble	loopstart 
                movs	r3, #0
                add	r0, r3, #0          // adds	r0, r3, #0
                mov	sp, r7
                sub	sp, #8
                pop	{r7, pc}*/

