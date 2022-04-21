.data
	Z: .word 0
	
.text
main:
	li a0, 15 # A
	li a1, 10 # B
	li a2, 5 # C
	li a3, 2 # D
	li a4, 18 # E
	li a5, -3 # F
	lw a6, Z
	
	sub t1, a0, a1
	mul t2, a2, a3
	add t1, t1, t2
	sub t2, a4, a5
	add t1, t1, t2
	div t2, a0, a2
	sub t1, t1, t2
	
	sw t1, Z, s0

	
	
	ret
	