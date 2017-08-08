@filename: test_regfile_mem_ops.S

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

str r0, [r0, #0]
str r1, [r0, #4]
str r2, [r0, #8]
str r3, [r0, #12]
str r4, [r0, #16]
str r5, [r0, #20]
str r6, [r0, #24]
str r7, [r0, #28]
add r7, r6
sub r6, r0
ldr r7, [r0, #28]
ldr r6, [r0, #24]

