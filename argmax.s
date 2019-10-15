.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 is the pointer to the start of the vector
#	a1 is the # of elements in the vector
# Returns:
#	a0 is the first index of the largest element
# =================================================================
argmax:

    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)

loop_start:
    add t0, x0, x0             # t0 is the counter
    add t5, x0, x0             # t5 holds max index value
    add t6, x0, x0             # t6 holds max index


loop_continue:
    beq t0, a1, loop_end       # if counter == array size
    mv t1, a0                  # put arr ptr back into t1
    slli t2, t0, 2             # multiply t0 by 4 (word = 4 bytes)
    add t1, t1, t2             # offset arr ptr
    lw t3, 0(t1)               # t3 holds current array value
    slt t4, t3, t5             # if t3 less than curr max, set t4 to 1
    addi t0, t0, 1             # increment counter              
    bne t4, x0, loop_continue
    mv t5, t3                  # replace prev max index value
    mv t6, t0                  # replace prev max index
    addi t6, t6, -1            # undo increment counter to get right index
    j loop_continue

loop_end:
    
    mv a0, t6
    # Epilogue
    lw ra, 0(sp)
    addi sp, sp, 4

    ret
