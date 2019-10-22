.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is the pointer to the start of the matrix in memory
#   a2 is the number of rows in the matrix
#   a3 is the number of columns in the matrix
# Returns:
#   None
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)

    mv s0, a0               # filename ptr
    mv s1, a1               # ptr to matrix
    mv s2, a2               # rows
    mv s3, a3               # columns
    ##############################
    # open file
    addi sp, sp, -4
    sw ra, 0(sp)

    mv a1, s0           # set arguments for fopen
    addi a2, x0, 1           # open file with write permission
    
    jal fopen
    blt a0, x0, eof_or_error            # if error, jump to eof_or_error

    mv s4, a0           # move fopen result into s4

    lw ra, 0(sp)
    addi sp, sp, 4

    ###############################
    # write dimensions to file
    #============================
    # allocate space for row int
    addi sp, sp, -4
    sw ra, 0(sp)

    addi a0, x0, 4
    jal malloc
    mv s5, a0              # s5 holds ptr row int 
    sw s2, 0(s5)

    lw ra, 0(sp)
    addi sp, sp, 4
    #============================
    # allocate space for col int ptr
    addi sp, sp, -4
    sw ra, 0(sp)

    addi a0, x0, 4
    jal malloc
    mv s6, a0              # s6 holds ptr col int 
    sw s3, 0(s6)

    lw ra, 0(sp)
    addi sp, sp, 4
    #===============================
    # write row int
    addi sp, sp, -4
    sw ra, 0(sp)

    mv a1, s4
    mv a2, s5
    addi a3, x0, 1
    addi a4, x0, 4

    jal fwrite
    bne a0, a3, eof_or_error

    lw ra, 0(sp)
    addi sp, sp, 4
    #===============================
    # write col int
    addi sp, sp, -4
    sw ra, 0(sp)

    mv a1, s4
    mv a2, s6
    addi a3, x0, 1
    addi a4, x0, 4

    jal fwrite
    bne a0, a3, eof_or_error

    lw ra, 0(sp)
    addi sp, sp, 4
    ###############################
    # write matrix to file

    addi sp, sp, -4
    sw ra, 0(sp)

    mv a1, s4
    mv a2, s1
    mul a3, s2, s3
    addi a4, x0, 4

    jal fwrite
    bne a0, a3, eof_or_error

    lw ra, 0(sp)
    addi sp, sp, 4

    ############################
    # close file
    addi sp, sp, -4
    sw ra, 0(sp)

    mv a1, s4
    jal fclose
    blt a0, x0, eof_or_error

    lw ra, 0(sp)
    addi sp, sp, 4

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    addi sp, sp, 32

    ret

eof_or_error:
    li a1 1
    jal exit2
    