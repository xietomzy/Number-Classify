.import ../write_matrix.s
.import ../utils.s

.data
m0: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 # MAKE CHANGES HERE
file_path: .asciiz "test_output.bin"

.text
main:
    # Write the matrix to a file

    la s0, m0
    la s1, file_path
    li s2, 2 # rows m0
    li s3, 5 # cols m0

    mv a0, s1
    mv a1, s0
    mv a2, s2
    mv a3, s3

    jal write_matrix

    # Exit the program
    addi a0 x0 10
    ecall