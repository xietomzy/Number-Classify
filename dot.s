.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
#   a3 is the stride of v0
#   a4 is the stride of v1
# Returns:
#   a0 is the dot product of v0 and v1
# =======================================================
dot:
    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)

    add t0, x0, x0          # t0 is a counter
    add a7, x0, x0          # a7 is the sum of inner products = dot product
loop_start:
    beq t0, a2, loop_end
    mv t1, a0               # t1 is pointer to v0
    mv t2, a1               # t2 to pointer to v1
    slli t3, t0, 2          # multiply counter by 4 (word = 4 bytes)
    mul t4, t3, a3          # counter times v0 stride
    mul t5, t3, a4          # counter times v1 stride
    add t1, t1, t4          # increment v0 ptr
    add t2, t2, t5          # increment v1 ptr
    lw t6, 0(t1)            # get v0 value
    lw a5, 0(t2)            # get v1 value
    mul a6, t6, a5          # get inner product
    add a7, a7, a6          # add to dot product
    addi t0, t0, 1          # increment counter
    j loop_start

loop_end:

    mv a0, a7                 # a0 stores final dot product
    # Epilogue
    lw ra, 0(sp)
    addi sp, sp, 4
    ret
