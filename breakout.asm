################ CSC258H1F Fall 2022 Assembly Final Project ##################
# This file contains our implementation of Breakout.
#
# Student 1: Name, 1008421931
# Student 2: Name, Student Number
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       8
# - Unit height in pixels:      8
# - Display width in pixels:   	512
# - Display height in pixels:   512
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

    .data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000

#Strings to print using syscall if game starts or ends
START_STR: .asciiz "GAME STARTED"
QUIT_STR: .asciiz "GAME ENDED"



##############################################################################
# Mutable Data
##############################################################################

##############################################################################
# Code
##############################################################################
	.text
	.globl main

	# Run the Brick Breaker game.
main:
    # Initialize the game
    #Set up timer
    	li $v0, 32
    	li $a0, 1
	syscall
    #Set up start menu and check for start input
    lw $t0 ADDR_KBRD #Set register t0 to kbrd
    lw $a0 0($t0) #Set register a0 to the latest key we pressed
    beq $a0, 1, handle_menu_options
	b main

handle_menu_options:
	lw $a0 4($t0)
	beq $a0, 0x71, quit_game #if q is pressed quit
    beq $a0, 0x20, start_game  #if space is pressed start
    b main
  
 quit_game:
	li $v0, 4 #Set syscall to print string
	la $a0, QUIT_STR
	syscall
	li $v0, 10
	syscall
	
start_game:
	li $v0, 4
	la $a0, START_STR
	syscall
	#Initialize game environment
	
	lw $t4, ADDR_DSPL
	
	#Initialize amount of bricks 256 * 6 rows
	addi $t5, $t4, 3072
	#Add margin top: 2 rows = 256 * 2 = 512
	addi $t4, $t4, 512
	li $t1, 0xff0000
	b draw_bricks
	
draw_bricks:
	jal draw_brick
	addi $t4, $t4, 4
	beq $t4, $t5, draw_paddle
	b draw_bricks
	
	
draw_brick:
	sw $t1, 0($t4)
	jr $ra

draw_paddle:
	#Set colour to blue
	li $t1, 0x0000ff
	#Initialize paddle 12 rows down from the last brick, and center 256/2 = 128, 6144 + 128 = 6272
	addi $t4, $t4, 6272
	sw $t1, -16($t4)
	sw $t1, -12($t4)
	sw $t1, -8($t4)
	sw $t1, -4($t4)
	sw $t1, 0($t4)
	sw $t1, 4($t4)
	sw $t1, 8($t4)
	sw $t1, 12($t4)
	sw $t1, 16($t4)
	b draw_ball
	
draw_ball:
	li $t2, 0x00ff00 #$t2 is green
	#Initialize $t3 as ball location
	addi $t3, $t4, -256
	sw $t2, 0($t3)
	b game_loop
	
game_loop:
	# 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (paddle, ball)
	# 3. Draw the screen
	# 4. Sleep

    #5. Go back to 1
    b game_loop