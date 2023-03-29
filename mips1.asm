######################## Bitmap Display Configuration ########################
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
##############################################################################
    .data
ADDR_DSPL:
    .word 0x10008000

    .text
	.globl main

main:
    li $t1, 0xff0000        # $t1 = red
    li $t2, 0x00ff00        # $t2 = green
    li $t3, 0x0000ff        # $t3 = blue

    lw $t0, ADDR_DSPL       # $t0 = base address for display

    # loop to draw 3 rows of 4 bricks
    li $t4, 4               # number of bricks in a row
    li $t5, 0               # starting index for top row
    li $t6, 8               # width of each brick
    li $t7, 32              # number of bricks in a column
    li $t8, 8               # height of each brick
    li $t9, 0               # starting index for first column
    li $t10, 0              # current row
row_loop:
    # draw one row of bricks
    move $t11, $t5          # current index in row
    li $t12, 0              # current column
brick_loop:
    # draw one brick
    move $t13, $t0          # current address in display memory
    li $t14, 0              # current pixel in brick row
    li $t15, 0              # current row in brick
    sw $t1, ($t13)          # paint top-left pixel of brick red
    addi $t13, $t13, 4      # move to next pixel in row
    sw $t1, ($t13)
    addi $t13, $t13, 4
    sw $t1, ($t13)
    addi $t13, $t13, 4
    sw $t1, ($t13)
    addi $t13, $t13, 4
    sw $t1, ($t13)
    addi $t13, $t13, 4
    sw $t1, ($t13)
    addi $t13, $t13, 4
    sw $t1, ($t13)
    addi $t13, $t13, 4
    sw $t1, ($t13)          # paint top-right pixel of brick red

    # move to next brick
    addi $t11, $t11, $t6    # move to next brick in row
    addi $t12, $t12, 1      # increment current column

    # check if all bricks in row are drawn
    bne $t12, $t4, brick_loop

    # move to next row
    addi $t5, $t5, $t8      # move to next row
    addi $t10, $t10, 1      # increment current row
    li $t12