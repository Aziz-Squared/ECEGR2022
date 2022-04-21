.data
	a: .word 0
	b: .word 0
	c: .word 0
	
.text
main:
	li t0, 5
	jal addItUp
	sw a0, a, s0
	
	li t0, 10
	jal addItUp
	sw a0, b, s0
	
	lw t1, c
	lw a1, a
	lw a2, b
	add t1, a1, a2
	sw t1, c, s0
	
	li a7, 10
	ecall

addItUp:
	addi sp, sp, -12
	sw ra, 8(sp)
	sw t0, 4(sp)
	sw t1, 0(sp)
	
	li t0, 0
	li t1, 0
	j loopStart
	ret
	
loopStart:
	lw a0, 4(sp)
	bge t0, a0, breakLoop
	addi t0, t0, 1
	j setX
	
setX:
	addi t1, t1, 1
	add t1, t1, t0
	j loopStart
	
breakLoop:
	addi a0, t1, 0
	lw ra, 8(sp)
	addi sp, sp, 12
	ret
	