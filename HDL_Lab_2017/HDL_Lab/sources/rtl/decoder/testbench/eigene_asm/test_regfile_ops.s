@filename: test_regfile_ops.S

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
add r0, r1
sub r2, r4
mul r0, r7
lsr r3, r3, #2
add r6, #1
