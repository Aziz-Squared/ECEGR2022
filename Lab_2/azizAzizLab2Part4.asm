.data
	a: .word 20
	b:
		.word 1
		.word 2
		.word 4
		.word 8
		.word 16
		

.text
main:
	addi    sp, sp, -16
        sw      ra, 12(sp)                      
        sw      s0, 8(sp)                       
        addi    s0, sp, 16
        li      a0, 0
        sw      a0, -12(s0)
        sw      a0, -16(s0)
	j forLoop

forLoop:
	lw a1, -16(s0)
	li a0, 4
	blt a0, a1, breakLoop
	j inLoop

inLoop:
	lw a1, -16(s0)
        lui a0, %hi(b)
        addi a0, a0, %lo(b)
        slli a1, a1, 2
        add a0, a0, a1
        lw a0, 0(a0)
        addi a0, a0, -1
        lui a2, %hi(a)
        addi a2, a2, %lo(a)
        add a1, a1, a2
        sw a0, 0(a1)
	j loopBack
	
loopBack:
	lw a0, -16(s0)
        addi a0, a0, 1
        sw a0, -16(s0)
        j forLoop


breakLoop:
	lw a0, -16(s0)
        addi a0, a0, -1
        sw a0, -16(s0)
        j whileLoop

whileLoop:
	lw a0, -16(s0)
        addi a0, a0, -1
        sw a0, -16(s0)
        blt a0, a1, return
        j inWhileLoop
        
inWhileLoop:
	lw a1, -16(s0)
        lui a0, %hi(a)
        addi a0, a0, %lo(a)
        slli a2, a1, 2
        add a1, a2, a0
        lw a0, 0(a1)
        lui a3, %hi(b)
        addi a3, a3, %lo(b)
        add a2, a2, a3
        lw a2, 0(a2)
        add a0, a0, a2
        slli a0, a0, 1
        sw a0, 0(a1)
        lw a0, -16(s0)
        addi a0, a0, -1
        sw a0, -16(s0)
        j whileLoop
        
return:
	lw  a0, -12(s0)
        lw ra, 12(sp)                      
        lw s0, 8(sp)                       
        addi sp, sp, 16
        ret
