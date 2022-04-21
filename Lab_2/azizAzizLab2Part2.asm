.data
	A: .word   15                    
	B: .word   15                              
	C: .word   10                               
	Z: .word   0 
	
.text

main:

	lw a0, Z
	lw a1, A
	lw a2, B
	lw a3, C
	
	bge a1, a2, ifAndCheck
	j checkC
	
	
ifAndCheck:

	blt a1, a2, setZ2
	j secondCheckC
	

checkC:
	li t1, 6
	blt a3, t1, ifAndCheck
	j setZ1
	
	
secondCheckC:
	li t1, 7
	addi t2, a3, 1
	bne t2, t1, setZ2
	j setZ3

	
setZ1:
	li t1, 1
	sw t1, Z, s0
	j case1
	
setZ2:
	li t1, 2
	sw t1, Z, s0
	j case2
	
setZ3:
	li t1, 3
	sw t1, Z, s0
	j case3
	
case1:
	li t1, -1
	sw t1, Z, s0
	ret
case2:
	li t1, -2
	sw t1, Z, s0
	ret
case3:
	li t1, -3
	sw t1, Z, s0
	ret


