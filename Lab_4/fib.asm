main:                                   
        addi    sp, sp, -32
        sw      ra, 28(sp)                      
        sw      s0, 24(sp)                      
        addi    s0, sp, 32
        li      a0, 3
        call    Fibonacci
        sw      a0, -12(s0)
        li      a0, 10
        call    Fibonacci
        sw      a0, -16(s0)
        li      a0, 20
        call    Fibonacci
        sw      a0, -20(s0)
        li      a0, 0
        lw      ra, 28(sp)                      
        lw      s0, 24(sp)                      
        addi    sp, sp, 32
        ret
Fibonacci:                              
        addi    sp, sp, -32
        sw      ra, 28(sp)                      
        sw      s0, 24(sp)                      
        addi    s0, sp, 32
        sw      a0, -12(s0)
        lw      a1, -12(s0)
        li      a0, 0
        blt     a0, a1, Jump2
        j       Jump1
 # The jumps below
Jump1:
        li      a0, 0
        sw      a0, -16(s0)
        j       Jump6
Jump2:
        lw      a0, -12(s0)
        li      a1, 1
        bne     a0, a1, Jump4
        j       Jump3
Jump3:
        li      a0, 1
        sw      a0, -16(s0)
        j       Jump5
# Recursive call to go back to fibonacci
Jump4:
        lw      a0, -12(s0)
        addi    a0, a0, -1
        call    Fibonacci
        sw      a0, -20(s0)                     
        lw      a0, -12(s0)
        addi    a0, a0, -2
        call    Fibonacci
        mv      a1, a0
        lw      a0, -20(s0)                     
        add     a0, a0, a1
        sw      a0, -16(s0)
        j       Jump5
 # Need this to run?? Removing it breaks the program. Not sure why
Jump5:
        j       Jump6
# Final jump, return back up
Jump6:
        lw      a0, -16(s0)
        lw      ra, 28(sp)                      
        lw      s0, 24(sp)                      
        addi    sp, sp, 32
        ret