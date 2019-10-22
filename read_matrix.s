.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 is the pointer to the matrix in memory
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -28
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)

    mv s3, a0                   # s3 holds pointer to filename
    mv s4, a1                   # s4 holds int pointer to numrows
    mv s5, a2                   # s5 holds int pointer to numcols

    addi sp, sp, -4
    sw ra, 0(sp)

    mv a1, s3           # set arguments for fopen
    mv a2, x0           # open file with read permission

    jal fopen
    blt a0, x0, eof_or_error            # if error, jump to eof_or_error

    mv s2, a0           # move fopen result into s2

    lw ra, 0(sp)
    addi sp, sp, 4

#########################
    # get num rows
   
    addi sp, sp, -4
    sw ra, 0(sp)

    mv a1, s2
    mv a2, s4       
    addi a3, x0, 4 

    jal fread
    addi a3, x0, 4
    bne a0, a3, eof_or_error

    lw ra, 0(sp)
    addi sp, sp, 4

#########################
    # get num columns

    addi sp, sp, -4
    sw ra, 0(sp)

    mv a1, s2
    mv a2, s5       
    addi a3, x0, 4 

    jal fread
    addi a3, x0, 4
    bne a0, a3, eof_or_error

    lw ra, 0(sp)
    addi sp, sp, 4

##########################
    # allocate space for matrix
    lw t0, 0(s4)                # load numrows to t0
    lw t1, 0(s5)                # load numcols to t1
    addi s1, x0, 4
    mul s1, s1, t0
    mul s1, s1, t1              # s1 holds number of elts in matrix

    addi sp, sp, -4
    sw ra, 0(sp)

    mv a0, s1                   # prepare args

    jal malloc

    mv s0, a0                   # s0 -> ptr to matrix

    lw ra, 0(sp)
    addi sp, sp, 4
############################
    # read in matrix

    addi sp, sp, -4
    sw ra, 0(sp)

    mv a1, s2
    mv a2, s0       
    mv a3, s1 

    jal fread
    bne a0, s1, eof_or_error

    lw ra, 0(sp)
    addi sp, sp, 4

############################
    # close file
    addi sp, sp, -4
    sw ra, 0(sp)

    mv a1, s2
    jal fclose
    blt a0, x0, eof_or_error

    lw ra, 0(sp)
    addi sp, sp, 4

    mv a0, s0

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28

    ret

eof_or_error:
    li a1 1
    jal exit2
    