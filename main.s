.import read_matrix.s
.import write_matrix.s
.import matmul.s
.import dot.s
.import relu.s
.import argmax.s
.import utils.s

.globl main

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # Exit if incorrect number of command line args
    addi t0, t0, 5
    bne a0, t0, error
    mv s0, a1






	# =====================================
    # LOAD MATRICES
    # =====================================






    # Load pretrained m0
    lw a0, 4(s0)
    addi sp sp -8
    addi a1 sp 0
    addi a2 sp 4
    jal read_matrix
    mv s1, a0 # pointer
    lw s2, 0(sp) # rows
    lw s3, 4(sp) # cols





    # Load pretrained m1
    lw a0, 8(s0)
    addi a1 sp 0
    addi a2 sp 4
    jal read_matrix
    mv s4, a0 # pointer
    lw s5, 0(sp) # rows
    lw s6, 4(sp) # cols





    # Load input matrix
    lw a0, 12(s0)    
    addi a1 sp 0
    addi a2 sp 4
    jal read_matrix
    mv s7, a0
    lw s8, 0(sp)
    lw s9, 4(sp)
    addi sp, sp, 8







    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    mul t1, s2, s9
    mv s10, t1
    slli t1, t1, 2 # Multiply by 4 to get number of bytes
    addi a0, t1, 0
    jal malloc
    mv s11, a0

    mv a6, s11
    mv a0, s1 # pointer m0
    mv a1, s2 # col m0
    mv a2, s3 # row m0
    mv a3, s7 # pointer input
    mv a4, s8 # col input
    mv a5, s9 # row input
    jal matmul

    mv a0, s11
    mv a1, s10
    jal relu

    mv s1, a0

    mul t1, s5, s9
    mv s10, t1
    slli t1, t1, 2 # Multiply by 4 to get number of bytes
    addi a0, t1, 0
    jal malloc
    mv s11, a0

    mv a6, s11
    mv a0, s4
    mv a1, s5
    mv a2, s6
    mv a3, s1
    mv a4, s2
    mv a5, s9
    jal matmul



    
    















    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0 16(s0) # Load pointer to output filename
    mv a1, s11
    mv a2, s5
    mv a3, s9
    jal write_matrix





    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s11
    mv a1, s10
    jal argmax



    # Print classification
    mv a1, a0
    jal print_int



    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

    jal exit

error:
    li a1 3
    jal exit2
