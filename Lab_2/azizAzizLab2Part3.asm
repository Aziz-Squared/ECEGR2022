.data
	z: .word 2
	i: .word 0
	
.text

main:
	lw a0, z
	lw a1, i
	j loopStart
	
loopStart:
	li t1, 20
	blt t1, a1, do
	j zPlus

zPlus:
	addi a0, a0, 1
	sw a0, z, s0
	j add2i

add2i:
	addi a1, a1, 2
	sw a1, i, s0
	j loopStart
	
do:
	j secondZPlus

secondZPlus:
	addi a0, a0, 1
	sw a0, z, s0
	j firstWhile
	
firstWhile:
	li t1, 100
	blt a0, t1, secondZPlus
	j secondWhile
	
secondWhile:
	li t2, 0
	bgt a1, t2, subZandI
	j return
	
subZandI:
	li t1, 1
	sub a0, a0, t1
	sub a1, a1, t1
	sw a0, z, s0
	sw a1, i, s0
	j secondWhile
	
return:
	ret
