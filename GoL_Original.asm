######################################################################################################
#                            	      CONWAY'S GAME OF LIFE SIMULATION					#
#		     	          Final Project for CS 3340.005, Fall 2018				#
######################################################################################################
#                                     	      ~Description~						#
# 	This is a simulation of Conway's Game of Life, a zero-player game. The game follows the 4 	#
# 	rules outlined below. To "play" just type in the number of the pattern you'd like to see!	#				
######################################################################################################
#                                          	 ~RULES~						#
# 1. Any live cell with < 2 live neighbors dies, as if by underpopulation.				#
# 2. Any live cell with 2 or 3 live neighbors lives on to the next generation.			#
# 3. Any live cell with > 3 live neighbors dies, as if by overpopulation.				#
# 4. Any dead cell with exactly 3 live neighbors becomes a live cell, as if by reproduction.		#
######################################################################################################
#                                          	 ~SETUP~						#
# UNIT WIDTH: 8												#
# UNIT HEIGHT: 8											#
# DISPLAY WIDTH: 512											#
# DISPLAY HEIGHT: 512											#
# BASE ADDRESS: 0x10008000 ($gp)									#
######################################################################################################
#                                  ~Registers Used and What They Mean~				#		
# a0 - x-coordinate of pixel (between 0-63). value corresponds to how many spaces to move RIGHT	#
# a1 - y-coordinate of pixel (between 0-63). value corresponds to how many spaces to move DOWN	#
# t1 - x-position of pixel (address)									#
# t2 - y-position of pixel (address)									#
# t3 - starting memory address										#
# t5 - alive cell counter 										#
# t8 - live pixel array											#
# t9 - dead pixel array											#
# s0 - user's menu selection										#
# s1 - live/dead pixel array pointer									#										
######################################################################################################

.data
	start:			.word		0x10008000
	live:			.space		1200
	dead:			.space		1200	
	livePixel:		.word 		0xFFFFFF	# 16777215 (white)
	deadPixel:		.word		0x000000	# 0 (black)
	selection:		.word		0
	mainPrompt:		.asciiz		"Welcome to the Game of Life! Please type one of the following integers to see the resulting configuration: \n"
	stillOps:		.asciiz		"Still Life Options: \n1. Block \n"
	oscOps:			.asciiz		"Oscillator Options:\n2. Blinker \n3. Pentadecathlon \n4. Pulsar \n"
	glideOps:		.asciiz		"Spaceship Options: \n5. Glider \n6. Lightweight Spaceship \n"
	gunOps:			.asciiz		"Gun Options: \n7. Glider Gun \n"
	methOps:			.asciiz		"Methuselah Options (patterns that eventually stabilize): \n8. R-Pentomino \n9. Acorn \n10. Quit \n"
	errorPrompt:		.asciiz		"Invalid menu choice. Please enter an integer between 1 and 10, inclusive: \n"

.text
main:	
	# print welcome message
	li $v0, 4		
	la $a0, mainPrompt
	syscall
	
	j printOps
	
	invalidInt:
		li $v0, 4		
		la $a0, errorPrompt
		syscall
	printOps:
		# print options
		li $v0, 4		
		la $a0, stillOps
		syscall
		li $v0, 4		
		la $a0, oscOps
		syscall
		li $v0, 4		
		la $a0, glideOps
		syscall
		li $v0, 4		
		la $a0, gunOps
		syscall
		li $v0, 4		
		la $a0, methOps
		syscall
	li $v0, 5				# reads integer input from user
	syscall
	sw $v0, selection			# stores user's input in "selection"
	lw $s0, selection			# gets user's selection
	
	blt $s0, 1, invalidInt			# invalid integer input - prompt user again
	bgt $s0, 10, invalidInt 
	beq $s0, 1, sl1
	beq $s0, 2, osc1
	beq $s0, 3, pent
	beq $s0, 4, pulsar
	beq $s0, 5, g1
	beq $s0, 6, lwss
	beq $s0, 7, g2
	beq $s0, 8, rpent
	beq $s0, 9, acorn
	beq $s0, 10, exit
	
	lw $t3, start				# stores starting memory address
	li $a0, 0				# stores how many spaces want to move RIGHT (range: 0 - 63)
	li $a1, 0				# stores how many spaces we want to move DOWN (range: 0 - 63)

sl1:
	subiu $sp, $sp, 4		
	sw $ra, ($sp)				# push $ra to the stack
	
	lw $t3, start			
	li $a0, 32			
	li $a1, 32			
	jal createPixel	
	lw $t3, start			
	li $a0, 31			
	li $a1, 32			
	jal createPixel	
	lw $t3, start			
	li $a0, 31			
	li $a1, 31			
	jal createPixel
	
	lw $ra, ($sp)
	addiu $sp, $sp, 4			# pop $ra from the stack	
	j continue 
	
osc1:
	subiu $sp, $sp, 4		
	sw $ra, ($sp)				# push $ra to the stack	
	
	lw $t3, start				# stores starting memory address
	li $a0, 31				# stores how many spaces want to move RIGHT (range: 0 - 63)
	li $a1, 30				# stores how many spaces we want to move DOWN (range: 0 - 63)
	jal createPixel
	lw $t3, start			
	li $a0, 31			
	li $a1, 31			
	jal createPixel	
	lw $t3, start			
	li $a0, 31			
	li $a1, 32			
	jal createPixel
	
	lw $ra, ($sp)
	addiu $sp, $sp, 4			# pop $ra from the stack	
	j continue 
	
pent:
	subiu $sp, $sp, 4		
	sw $ra, ($sp)				# push $ra to the stack	
	
	lw $t3, start			
	li $a0, 32			
	li $a1, 32			
	jal createPixel	
	lw $t3, start			
	li $a0, 32			
	li $a1, 31			
	jal createPixel	
	lw $t3, start			
	li $a0, 32			
	li $a1, 29			
	jal createPixel	
	lw $t3, start			
	li $a0, 32			
	li $a1, 33		
	jal createPixel	
	lw $t3, start			
	li $a0, 32			
	li $a1, 34		
	jal createPixel	
	lw $t3, start			
	li $a0, 32			
	li $a1, 36		
	jal createPixel	
	lw $t3, start			
	li $a0, 31			
	li $a1, 29		
	jal createPixel	
	lw $t3, start			
	li $a0, 31			
	li $a1, 30		
	jal createPixel	
	lw $t3, start			
	li $a0, 31			
	li $a1, 31		
	jal createPixel	
	lw $t3, start			
	li $a0, 31			
	li $a1, 32		
	jal createPixel	
	lw $t3, start			
	li $a0, 31			
	li $a1, 33		
	jal createPixel	
	lw $t3, start			
	li $a0, 31			
	li $a1, 34		
	jal createPixel	
	lw $t3, start			
	li $a0, 31			
	li $a1, 35		
	jal createPixel	
	lw $t3, start			
	li $a0, 31			
	li $a1, 36		
	jal createPixel	
	lw $t3, start			
	li $a0, 33			
	li $a1, 29		
	jal createPixel	
	lw $t3, start			
	li $a0, 33			
	li $a1, 30		
	jal createPixel	
	lw $t3, start			
	li $a0, 33			
	li $a1, 31		
	jal createPixel	
	lw $t3, start			
	li $a0, 33			
	li $a1, 32		
	jal createPixel
	lw $t3, start			
	li $a0, 33			
	li $a1, 33		
	jal createPixel	
	lw $t3, start			
	li $a0, 33			
	li $a1, 34		
	jal createPixel	
	lw $t3, start			
	li $a0, 33			
	li $a1, 35		
	jal createPixel	
	lw $t3, start			
	li $a0, 33			
	li $a1, 36		
	jal createPixel	
	
	lw $ra, ($sp)
	addiu $sp, $sp, 4			# pop $ra from the stack	
	j continue 
pulsar:
	subiu $sp, $sp, 4		
	sw $ra, ($sp)				# push $ra to the stack	
	
	lw $t3, start			
	li $a0, 26			
	li $a1, 30			
	jal createPixel	
	lw $t3, start			
	li $a0, 26			
	li $a1, 29			
	jal createPixel
	lw $t3, start			
	li $a0, 26			
	li $a1, 28			
	jal createPixel
	lw $t3, start			
	li $a0, 31			
	li $a1, 30			
	jal createPixel	
	lw $t3, start			
	li $a0, 31			
	li $a1, 29			
	jal createPixel
	lw $t3, start			
	li $a0, 31			
	li $a1, 28			
	jal createPixel
	lw $t3, start			
	li $a0, 33			
	li $a1, 30			
	jal createPixel	
	lw $t3, start			
	li $a0, 33			
	li $a1, 29			
	jal createPixel
	lw $t3, start			
	li $a0, 33			
	li $a1, 28			
	jal createPixel
	jal createPixel
	lw $t3, start			
	li $a0, 38			
	li $a1, 30			
	jal createPixel	
	lw $t3, start			
	li $a0, 38			
	li $a1, 29			
	jal createPixel
	lw $t3, start			
	li $a0, 38			
	li $a1, 28			
	jal createPixel
	lw $t3, start			
	li $a0, 26			
	li $a1, 34			
	jal createPixel	
	lw $t3, start			
	li $a0, 26			
	li $a1, 35			
	jal createPixel
	lw $t3, start			
	li $a0, 26			
	li $a1, 36			
	jal createPixel
	jal createPixel
	lw $t3, start			
	li $a0, 31			
	li $a1, 34			
	jal createPixel	
	lw $t3, start			
	li $a0, 31			
	li $a1, 35			
	jal createPixel
	lw $t3, start			
	li $a0, 31			
	li $a1, 36			
	jal createPixel
	jal createPixel
	lw $t3, start			
	li $a0, 33			
	li $a1, 34			
	jal createPixel	
	lw $t3, start			
	li $a0, 33			
	li $a1, 35			
	jal createPixel
	lw $t3, start			
	li $a0, 33			
	li $a1, 36			
	jal createPixel
	jal createPixel
	lw $t3, start			
	li $a0, 38			
	li $a1, 34			
	jal createPixel	
	lw $t3, start			
	li $a0, 38			
	li $a1, 35			
	jal createPixel
	lw $t3, start			
	li $a0, 38			
	li $a1, 36			
	jal createPixel
	lw $t3, start			
	li $a0, 28			
	li $a1, 26			
	jal createPixel
	lw $t3, start			
	li $a0, 29			
	li $a1, 26			
	jal createPixel
	lw $t3, start			
	li $a0, 30			
	li $a1, 26			
	jal createPixel
	lw $t3, start			
	li $a0, 34			
	li $a1, 26			
	jal createPixel
	lw $t3, start			
	li $a0, 35			
	li $a1, 26			
	jal createPixel
	lw $t3, start			
	li $a0, 36			
	li $a1, 26			
	jal createPixel
	lw $t3, start			
	li $a0, 28			
	li $a1, 33			
	jal createPixel
	lw $t3, start			
	li $a0, 29			
	li $a1, 33			
	jal createPixel
	lw $t3, start			
	li $a0, 30			
	li $a1, 33			
	jal createPixel
	lw $t3, start			
	li $a0, 34			
	li $a1, 33			
	jal createPixel
	lw $t3, start			
	li $a0, 35			
	li $a1, 33			
	jal createPixel
	lw $t3, start			
	li $a0, 36			
	li $a1, 33			
	jal createPixel
	lw $t3, start			
	li $a0, 28			
	li $a1, 38			
	jal createPixel
	lw $t3, start			
	li $a0, 29			
	li $a1, 38			
	jal createPixel
	lw $t3, start			
	li $a0, 30			
	li $a1, 38			
	jal createPixel
	lw $t3, start			
	li $a0, 34			
	li $a1, 38			
	jal createPixel
	lw $t3, start			
	li $a0, 35			
	li $a1, 38			
	jal createPixel
	lw $t3, start			
	li $a0, 36			
	li $a1, 38			
	jal createPixel
	lw $t3, start			
	li $a0, 28			
	li $a1, 31			
	jal createPixel
	lw $t3, start			
	li $a0, 29			
	li $a1, 31			
	jal createPixel
	lw $t3, start			
	li $a0, 30			
	li $a1, 31			
	jal createPixel
	lw $t3, start			
	li $a0, 34			
	li $a1, 31			
	jal createPixel
	lw $t3, start			
	li $a0, 35			
	li $a1, 31			
	jal createPixel
	lw $t3, start			
	li $a0, 36			
	li $a1, 31			
	jal createPixel
	
	lw $ra, ($sp)
	addiu $sp, $sp, 4			# pop $ra from the stack	
	j continue 
g1:
	subiu $sp, $sp, 4		
	sw $ra, ($sp)				# push $ra to the stack	
	
	lw $t3, start			
	li $a0, 32			
	li $a1, 33			
	jal createPixel	
	lw $t3, start			
	li $a0, 31			
	li $a1, 33			
	jal createPixel	
	lw $t3, start			
	li $a0, 33			
	li $a1, 33			
	jal createPixel
	lw $t3, start			
	li $a0, 33			
	li $a1, 32			
	jal createPixel
	lw $t3, start			
	li $a0, 32			
	li $a1, 31			
	jal createPixel
	
	lw $ra, ($sp)
	addiu $sp, $sp, 4			# pop $ra from the stack
	j continue 
	
lwss:
	subiu $sp, $sp, 4		
	sw $ra, ($sp)				# push $ra to the stack	
	
	lw $t3, start			
	li $a0, 0			
	li $a1, 32			
	jal createPixel	
	lw $t3, start			
	li $a0, 0			
	li $a1, 34			
	jal createPixel	
	lw $t3, start			
	li $a0, 1			
	li $a1, 31			
	jal createPixel	
	lw $t3, start			
	li $a0, 2			
	li $a1, 31			
	jal createPixel	
	lw $t3, start			
	li $a0, 3			
	li $a1, 31			
	jal createPixel	
	lw $t3, start			
	li $a0, 4			
	li $a1, 31			
	jal createPixel	
	lw $t3, start			
	li $a0, 4			
	li $a1, 32			
	jal createPixel	
	lw $t3, start			
	li $a0, 4			
	li $a1, 33			
	jal createPixel
	lw $t3, start			
	li $a0, 3			
	li $a1, 34			
	jal createPixel		
	
	lw $ra, ($sp)
	addiu $sp, $sp, 4			# pop $ra from the stack
	j continue 
	
g2: 
	subiu $sp, $sp, 4		
	sw $ra, ($sp)				# push $ra to the stack
	
	lw $t3, start			
	li $a0, 15			
	li $a1, 14			
	jal createPixel	
	lw $t3, start			
	li $a0, 15			
	li $a1, 15			
	jal createPixel
	lw $t3, start			
	li $a0, 16			
	li $a1, 14			
	jal createPixel	
	lw $t3, start			
	li $a0, 16			
	li $a1, 15			
	jal createPixel
	lw $t3, start			
	li $a0, 25			
	li $a1, 14			
	jal createPixel
	lw $t3, start			
	li $a0, 25			
	li $a1, 15			
	jal createPixel
	lw $t3, start			
	li $a0, 25			
	li $a1, 16			
	jal createPixel
	lw $t3, start			
	li $a0, 26			
	li $a1, 13		
	jal createPixel
	lw $t3, start			
	li $a0, 26			
	li $a1, 17		
	jal createPixel
	lw $t3, start			
	li $a0, 27			
	li $a1, 12		
	jal createPixel
	lw $t3, start			
	li $a0, 28			
	li $a1, 12		
	jal createPixel
	lw $t3, start			
	li $a0, 27			
	li $a1, 18		
	jal createPixel
	lw $t3, start			
	li $a0, 28			
	li $a1, 18		
	jal createPixel
	lw $t3, start			
	li $a0, 29			
	li $a1, 15		
	jal createPixel
	lw $t3, start			
	li $a0, 30			
	li $a1, 13		
	jal createPixel
	lw $t3, start			
	li $a0, 30			
	li $a1, 17		
	jal createPixel
	lw $t3, start			
	li $a0, 31			
	li $a1, 14		
	jal createPixel
	lw $t3, start			
	li $a0, 31			
	li $a1, 15		
	jal createPixel
	lw $t3, start			
	li $a0, 31			
	li $a1, 16		
	jal createPixel
	lw $t3, start			
	li $a0, 32			
	li $a1, 15		
	jal createPixel
	lw $t3, start			
	li $a0, 35			
	li $a1, 12		
	jal createPixel
	lw $t3, start			
	li $a0, 35			
	li $a1, 13		
	jal createPixel
	lw $t3, start			
	li $a0, 35			
	li $a1, 14		
	jal createPixel
	lw $t3, start			
	li $a0, 36			
	li $a1, 12		
	jal createPixel
	lw $t3, start			
	li $a0, 36			
	li $a1, 13		
	jal createPixel
	lw $t3, start			
	li $a0, 36		
	li $a1, 14		
	jal createPixel
	lw $t3, start			
	li $a0, 37		
	li $a1, 11		
	jal createPixel
	lw $t3, start			
	li $a0, 37		
	li $a1, 15		
	jal createPixel
	lw $t3, start			
	li $a0, 39		
	li $a1, 10		
	jal createPixel
	lw $t3, start			
	li $a0, 39		
	li $a1, 11		
	jal createPixel
	lw $t3, start			
	li $a0, 39		
	li $a1, 15		
	jal createPixel
	lw $t3, start			
	li $a0, 39		
	li $a1, 16		
	jal createPixel
	lw $t3, start			
	li $a0, 49		
	li $a1, 12		
	jal createPixel
	lw $t3, start			
	li $a0, 49		
	li $a1, 13		
	jal createPixel
	lw $t3, start			
	li $a0, 50		
	li $a1, 12		
	jal createPixel
	lw $t3, start			
	li $a0, 50		
	li $a1, 13		
	jal createPixel
	
	lw $ra, ($sp)
	addiu $sp, $sp, 4			# pop $ra from the stack	
	j continue 
	
rpent:
	subiu $sp, $sp, 4		
	sw $ra, ($sp)				# push $ra to the stack
	
	lw $t3, start			
	li $a0, 31		
	li $a1, 32		
	jal createPixel
	lw $t3, start			
	li $a0, 32		
	li $a1, 31		
	jal createPixel
	lw $t3, start			
	li $a0, 32		
	li $a1, 32		
	jal createPixel
	lw $t3, start			
	li $a0, 32		
	li $a1, 33		
	jal createPixel
	lw $t3, start			
	li $a0, 33		
	li $a1, 31		
	jal createPixel
	
	lw $ra, ($sp)
	addiu $sp, $sp, 4			# pop $ra from the stack	
	j continue 
acorn:
	subiu $sp, $sp, 4		
	sw $ra, ($sp)				# push $ra to the stack
	
	lw $t3, start			
	li $a0, 39		
	li $a1, 33		
	jal createPixel
	lw $t3, start			
	li $a0, 40		
	li $a1, 33		
	jal createPixel
	lw $t3, start			
	li $a0, 40		
	li $a1, 31		
	jal createPixel
	lw $t3, start			
	li $a0, 42		
	li $a1, 32		
	jal createPixel
	lw $t3, start			
	li $a0, 43		
	li $a1, 33		
	jal createPixel
	lw $t3, start			
	li $a0, 44		
	li $a1, 33		
	jal createPixel
	lw $t3, start			
	li $a0, 45		
	li $a1, 33		
	jal createPixel
	
	lw $ra, ($sp)
	addiu $sp, $sp, 4			# pop $ra from the stack	
	j continue 
	
continue:
	li $t7, 1			# initialize number of live pixels to 1, to allow for an initial run on the configuration
	loopScreen:
		beqz $t7, exit		# if num of live pixels = 0, exit the program.
		jal updateScreen		# loop through entire screen while there are still live pixels on the screen & not OOB
		j loopScreen
exit:
	la $v0, 10
	syscall  
	
createPixel:
	lw $t3, start			# stores starting memory address
	sll $t1, $a0, 2			# calculates pixel x-position by multiplying x-position by 4, the size of a word.
	sll $t2, $a1, 8			# calculates pixel y-position by multiplying y-position by 256, the size of an entire row in this display.
	add $t1, $t1, $t2  		# add x and y positions together
	add $t3, $t3, $t1		# add the positions to the starting address to find the new location of the pixel
	lw $t0, livePixel 		# loads a ___white____ pixel	
	sw $t0, ($t3)		 	# places pixel in bitmap display
	jr $ra
	
checkColor:
	# Will determine the color of a neighbor 
	lw $t3, start			# stores starting memory address
	sll $t1, $a2, 2			# calculates neighbor's x-position
	sll $t2, $a3, 8			# calculates neighbor's y-position
	add $t1, $t1, $t2  		# add x and y positions together
	add $t3, $t3, $t1		# add the positions to the starting address to find the neighbor's address
	lw $v0, ($t3) 	 		# loads the color of the neighbor into $v0
	jr $ra
	
checkSelfColor:
	# Will determine the color of the current pixel in the display
	lw $t3, start
	sll $t1, $a0, 2
	sll $t2, $a1, 8
	add $t1, $t1, $t2
	add $t3, $t3, $t1
	lw $v1, ($t3)
	jr $ra
	
XYtoAddress:
	# Will convert a pixel with XY coordinates into an address
	lw $t3, start			# stores starting memory address
	sll $t0, $a0, 2			# calculates x-position
	sll $t6, $a1, 8			# calculates y-position
	add $t0, $t0, $t6  		# add x and y positions together
	add $t3, $t3, $t0		# add the positions to the starting address
	move $v1, $t3	 	 	# loads address of pixel into $v1
	jr $ra	
	
updateScreen:
	# This function will loop through every pixel on the display screen and determine if new cells will be born.
	# If there are no cells on the screen, we will exit the program.
	subiu $sp, $sp, 4		
	sw $ra, ($sp)					# push $ra to the stack
	li $t7, 0					# counter for how many live pixels we've encountered in the screen
	li $a0, 0					# initialize starting position on screen
	li $a1, 0
	la $t8, live					# initialize arrays for live and dead pixels
	la $t9, dead
	
	checkPixel:
		jal checkSelfColor
		beqz $v1, black				# if the pixel is black
	colored:						# otherwise, it's colored.
		addi $t7, $t7, 1				# since it's colored, we increment the live pixel counter
		jal countNeighbors	
		blt $t5, 2, markDead 			# cell dies of loneliness if # of neighbors < 2 (0, 1)
		bgt $t5, 3, markDead			# cell dies from overpopulation if # of neighbors > 3 (4+)
		j checkOOB				# cell remains alive if # of neighbors = 2 or 3, so we won't do anything in this case.
		markDead:
			jal XYtoAddress 
			sw $v1, ($t9)			# store current live pixel into dead array
			addi $t9, $t9, 4			# go to next position in array	
			subi $t7, $t7, 1			# one less live cell now
			j checkOOB			# continue looping through screen.
		
	black:	
		jal countNeighbors
		beq $t5, 3, markLive			# if dead cell has exactly three live neighbors, it will become alive!
		j checkOOB				# otherwise, do nothing & continue looping.
		markLive:
			jal XYtoAddress
			sw $v1, ($t8)			# store new live pixel into live array
			addi $t8, $t8, 4			# go to next space in array			
			addi $t7, $t7, 1 		# increment live pixels

	checkOOB:
		addi $a0, $a0, 1
		bgt $a0, 63, resetX			# if x-coordinate is over the right of the screen (bound is 63), reset it and increment y-coordinate
		blt $a0, 64, checkPixel			# if x and y-coordinate are within bounds, continue looping through screen
		resetX:
			li $a0, 0
			addi $a1, $a1, 1
			bgt $a1, 63, endUpdateScreen	# if y-coordinate reaches the bottom right of the screen, end
			j checkPixel
	
	endUpdateScreen:
		jal nextGeneration			# once we've reached the end of the screen, draw all the changes to the display.
		lw $ra, ($sp)
		addiu $sp, $sp, 4			# pop $ra from the stack
		jr $ra
	
nextGeneration:
	subiu $sp, $sp, 4		
	sw $s1, ($sp)					# push $s1 to the stack
	la $t8, live					# reset arrays for live and dead pixels
	la $t9, dead
	kill:
		lw $s1, ($t9)
		beqz $s1, generate			# continue killing pixels until there are no more in the array
		lw $v1, ($t9) 
		lw $t0, deadPixel 			# loads color of dead pixel (black)
		sw $t0, ($v1)				# colors pixel black
		sw $zero, ($t9)
		addi $t9, $t9, 4
		j kill
		
	generate:
		lw $s1, ($t8)
		beqz $s1, endNextGen			# continue generating pixels until there are no more in the array
		lw $v1, ($t8)
		lw $t0, livePixel 			# loads a white pixel	
		sw $t0, ($v1)		 		# places pixel in bitmap display
		sw $zero, ($t8)				# clear the address of the pixel we just created
		addi $t8, $t8, 4				# go to next pixel
		j generate
	
	endNextGen:
		lw $s1, ($sp)
		addiu $sp, $sp, 4			# pop $s1 from the stack
		jr $ra

countNeighbors:
	# Each pixel will have 8 neighbors. We will check if each neighbor is alive or dead (black or colored).
	# We will implement the rules of the game in accordance to how many neighbors are alive.
	# This is how I will refer to each neighbor of pixel with position 'x, y' (with number identifiers for ease of reading):
	#
	# | 1: x-1, y-1 | 2: x, y-1 | 3: x+1, y-1 |
	# `````````````````````````````````````````
	# | 4: x-1, y   |    x, y   | 5: x+1, y   |
	# `````````````````````````````````````````
	# | 6: x-1, y+1 | 7: x, y+1 | 8: x+1, y+1 |
	# `````````````````````````````````````````
	#####################################################################################################
	subiu $sp, $sp, 4		
	sw $ra, ($sp)				# push $ra to the stack
	li $t5, 0				# alive counter
	######################################## check 1: top left ##########################################
	checkOOB1: # OOB means Out of Bounds	
		subi $a2, $a0, 1			# get neighbor's x-position
		blt $a2, 0, checkOOB2		# if x-position is OOB on the left side of display, go to next neighbor		
		subi $a3, $a1, 1			# get neighbor y-position
		blt $a3, 0, checkOOB2		# if y-position is OOB on the top of display, go to next neighbor
		# if not OOB, check if this cell is alive or dead
		jal checkColor
		sne $t6, $v0, 0 			# if the cell != black (0 in hexadecimal), increment alive counter
		add $t5, $t5, $t6
	########################################## check 2: up ##############################################
	checkOOB2: 
		move $a2, $a0			# neighbor's x-position will be the same as the pixel's x-position
		subi $a3, $a1, 1		
		blt $a3, 0, checkOOB3		
		# if not OOB, check if this cell is alive or dead
		jal checkColor
		sne $t6, $v0, 0 			
		add $t5, $t5, $t6
	######################################## check 3: top right #########################################
	checkOOB3:
		addi $a2, $a0, 1			# get neighbor's x-position
		bgt $a2, 63, checkOOB4		# if x-position is OOB on the right side of display, go to next neighbor
		subi $a3, $a1, 1			# get neighbor y-position
		blt $a3, 0, checkOOB4		# if y-position is OOB on the top of display, go to next neighbor
		# if not OOB, check if this cell is alive or dead
		jal checkColor
		sne $t6, $v0, 0 			
		add $t5, $t5, $t6
	########################################## check 4: left ############################################
	checkOOB4:
		subi $a2, $a0, 1
		blt $a2, 0, checkOOB5
		move $a3, $a1			# neighbor's y-position will be the same as pixel's y-position (coordinate system, not address)
		# if not OOB, check if this cell is alive or dead
		jal checkColor
		sne $t6, $v0, 0 			
		add $t5, $t5, $t6
	######################################### check 5: right ############################################
	checkOOB5:
		addi $a2, $a0, 1
		bgt $a2, 63, checkOOB6
		move $a3, $a1
		# if not OOB, check if this cell is alive or dead
		jal checkColor
		sne $t6, $v0, 0 			
		add $t5, $t5, $t6
	###################################### check 6: bottom left #########################################
	checkOOB6:
		subi $a2, $a0, 1
		blt $a2, 0, checkOOB7
		addi $a3, $a1, 1
		bgt $a3, 63, checkOOB7		# if neighbor's y-position is OOB on the bottom of display, go to next neighbor
		# if not OOB, check if this cell is alive or dead
		jal checkColor
		sne $t6, $v0, 0 			
		add $t5, $t5, $t6
	######################################## check 7: down ##############################################
	checkOOB7:
		move $a2, $a0
		addi $a3, $a1, 1
		bgt $a3, 63, checkOOB8
		# if not OOB, check if this cell is alive or dead
		jal checkColor
		sne $t6, $v0, 0 			
		add $t5, $t5, $t6
	##################################### check 8: bottom right #########################################
	checkOOB8:
		addi $a2, $a0, 1
		bgt $a2, 63, endCheck
		addi $a3, $a1, 1
		bgt $a3, 63, endCheck
		# if not OOB, check if this cell is alive or dead
		jal checkColor
		sne $t6, $v0, 0 			
		add $t5, $t5, $t6
	####################################################################################################
	endCheck:
		lw $ra, ($sp)
		addiu $sp, $sp, 4		# pop $ra from the stack 
		jr $ra
