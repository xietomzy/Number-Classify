.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_input.bin"

.text
main:
    # Read matrix into memory
    # allocate space for row int ptr

    addi a0, x0, 4
    jal malloc
    mv s1, a0

    # allocate space for col int ptr

    addi a0, x0, 4
    jal malloc
    mv s2, a0

    la s0, file_path
    mv a0, s0
    mv a1, s1
    mv a2, s2

    jal read_matrix

    # Print out elements of matrix
    lw a1, 0(s1)
    lw a2, 0(s2)
    jal print_int_array

    # Terminate the program
    addi a0, x0, 10
    ecall