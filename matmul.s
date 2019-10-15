.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# 	a0 is the pointer to the start of m0
#	a1 is the # of rows (height) of m0
#	a2 is the # of columns (width) of m0
#	a3 is the pointer to the start of m1
# 	a4 is the # of rows (height) of m1
#	a5 is the # of columns (width) of m1
#	a6 is the pointer to the the start of d
# Returns:
#	None, sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error if mismatched dimensions
    bne a2, a4, mismatched_dimensions

    # Prologue
    addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)

    add t0, x0, x0          # row counter (outer-loop)
    add t1, x0, x0          # column counter (inner-loop)

outer_loop_start:
    beq t0, a1, outer_loop_end

    slli s0, t0, 2          # multiply row counter by 4 (i)
    mul s0, s0, a2          # row offset (bytes)
    add s2, s0, a0          # select row vector m0 (address)

    add t1, x0, x0          # reset column counter (inner-loop)

inner_loop_start:
    beq t1, a5, inner_loop_end

    slli s1, t1, 2          # multiply column counter by 4 (j) / row offset (bytes)
    add s3, s1, a3          # select column vector m1 (address)
    
    # push onto stack

    addi sp, sp, -40
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    sw a6, 24(sp)
    sw t0, 28(sp)
    sw t1, 32(sp)
    sw ra, 36(sp)

    # prepare arguments

    mv a0, s2
    mv a1, s3
                            # a2 is already correct from the arguments in this function
    addi a3, x0, 1
    mv a4, a5               # stride for column vector is column value of m1


    jal dot                 # call dot

    mv t2, a0               # result of calling dot

    # restore from stack

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    lw a6, 24(sp)
    lw t0, 28(sp)
    lw t1, 32(sp)
    lw ra, 36(sp)
    addi sp, sp, 40

    add t3, a6, s0          # increment pointer to d to right place
    add t3, t3, s1

    sw t2, 0(t3)

    addi t1, t1, 1          # increment inner-loop counter
    j inner_loop_start


inner_loop_end:

    addi t0, t0, 1          # increment outer-loop counter

    j outer_loop_start
outer_loop_end:


    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20

    ret


mismatched_dimensions:
    li a1 2
    jal exit2
