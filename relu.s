.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 is the pointer to the array
#	a1 is the # of elements in the array
# Returns:
#	None
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)

loop_start:
    add t0, x0, x0             # t0 is the counter

loop_continue:
    beq t0, a1, loop_end       # if counter == array size
    mv t1, a0                  # put arr ptr back into t1
    slli t2, t0, 2             # multiply t0 by 4 (word = 4 bytes)
    add t1, t1, t2             # offset arr ptr
    lw t3, 0(t1)               # t3 holds current array value
    slti t4, t3, 0             # t4 is 1 if t3 is negative
    addi t0, t0, 1             # increment counter              
    beq t4, x0, loop_continue  # if value is (+), don't do anything and loop again
    sw x0, 0(t1)               # replace value with 0 if negative
    j loop_continue

loop_end:

    # Epilogue
    lw ra, 0(sp)
    addi sp, sp, 4
	ret
