# Name: Lauren Sherburne
# Class: Computer Organization - Section A
# Date Modified: 9/23/20
# Assignment: CSCI 341 M2 Program 2B
#             Cafe Wall
#
#
# Description: The following code uses two variables inputted by the user to determine draw an imitation of a cafe brick wall. The
#              first variable refers to the size of each square "brick" (# of pixels), and the second determines how many pairs of
#              squares will be in each row and how many pairs of offset rows will be drawn.
	
	.data
frame:    .space 0x80000    # first data value should set the frame
			    # 512 width x 256 heigth
squareSizePrompt:    .asciiz "Enter a square size: "
gridSizePrompt:      .asciiz "Enter a grid size: "

	.text
main:
	# prompt the user to enter a square size and store value in $s2
	la $a0, squareSizePrompt    # prompt the user to input a value
	li $v0, 4
	syscall
	
	li $v0, 5    # receive input from the user stored in $v0
	syscall
	move $s2, $v0    # move user input to $s2

	
	# prompt the user to enter the size of the grid and store the value in $s3
	la $a0, gridSizePrompt    # prompt the user to input a value
	li $v0, 4
	syscall
	
	li $v0, 5    # receive input from the user stored in $v0
	syscall
	move $s3, $v0    # move user input to $s3
	
	
	# store the rectangle x and y values in $s0 and $s1
	addi $s0, $zero, 10    # set x-coordinate to 10
	addi $s1, $zero, 10    # set y-coordinate to 10


	# outer for loop: for (int j = 0; j < 5; j++)
	# use a loop to draw 10 rows of offset blue/white squares
	addi $t6, $zero, 0    # initialize j = 0
	

outerForLoop:
	# test to enter outer for loop
	slt $t7, $t6, $s3    # $t7 = bool($t6 < $s3)
	beq $t7, $zero, exitOuterForLoop    # if $t7 == 0, exit loop

	
	# two rows loop: for (int k = 0; k < 2; k++)
	# use a loop to draw 2 offset rows of blue/white squares
	addi $t8, $zero, 0    # initialize k = 0
	
twoRows:
	# test to enter two rows loop
	slti $t7, $t8, 2    # $t7 = bool ($t8 < 2)
	beq $t7, $zero, exitTwoRows    # if $t7 == 0, exit loop
	
		
	# inner for loop: for (int i = 0; i < 5; i++);
	# use a loop to draw a row of 5 pairs of blue/white squares
	addi $t5, $zero, 0    # initialize i = 0
			
innerForLoop:
	# test to enter inner for loop
	slt $t7, $t5, $s3    # $t7 = bool($t5 < $s3)
	beq $t7, $zero, exitInnerForLoop    # if $t7 == 0, exit loop
	
# body of inner for loop
	# draw a blue square
	add $a0, $zero, $s0    # set x-coordinate
	add $a2, $zero, $s1    # set y-coordinate
	add $a1, $zero, $s2    # set width to $s2 value
	add $a3, $zero, $s2    # set height to $s2 value
	addi $t0, $zero, 0x000000FF    # set color to blue
	jal rectangle
	
		
	
	# draw a white square
	add $s0, $s0, $s2    # x-coordinate += square size
	
	add $a0, $zero, $s0    # set x-coordinate
	add $a2, $zero, $s1    # set y-coordinate
	add $a1, $zero, $s2    # set width to $s2 value
	add $a3, $zero, $s2    # set height to $s2 value
	addi $t0, $zero, 0x00FFFFFF    # set color to white
	jal rectangle


# inner for loop: increment and repeat
	addi $t5, $t5, 1    # i++
	add $s0, $s0, $s2    # x-coordinate  += square size
	j innerForLoop     # jump to line: "innerForLoop"

# exit inner for loop
exitInnerForLoop:

# two rows loop: increment and repeat
	addi $t8, $t8, 1    # k++
	addi $s0, $zero, 20    # x-coordinate = 20
	add $s1, $s1, $s2    # y-coordinate += square size
	addi $s1, $s1, 2    # y-coordinate += 2 pixels (for buffer between rows)
	j twoRows    # jump to line: "twoRows"

# exit two rows loop
exitTwoRows:


# outer for loop: increment and repeat
	addi $t6, $t6, 1    # j++
	addi $s0, $zero, 10    # x-coordinate = 10
	j outerForLoop    # jump to line: "outerForLoop"

# exit outer for loop
exitOuterForLoop:

	# terminate program execution
	addi $v0, $zero, 10
	syscall


# draw a rectangle by looping over a given space and changing all color values in
# the space to white
# $a0 is xmin, $a1 is width 
# $a2 is ymin, $a3 is height 
rectangle:

	beq  $a1, $zero, rectangleReturn # zero width: draw nothing
	beq  $a3, $zero, rectangleReturn # zero height: draw nothing

	add $t0, $zero, $t0 # specify color as a parameter
	la   $t1, frame
    add  $a1, $a1, $a0 # simplify loop tests by switching to first too-far value
	add  $a3, $a3, $a2
	sll  $a0, $a0, 2 # scale x values to bytes (4 bytes per pixel)
	sll  $a1, $a1, 2
	sll  $a2, $a2, 11 # scale y values to bytes (512*4 bytes per display row)
	sll  $a3, $a3, 11
	addu $t2, $a2, $t1 # translate y values to display row starting addresses
	addu $a3, $a3, $t1
	addu $a2, $t2, $a0 # translate y values to rectangle row starting addresses
	addu $a3, $a3, $a0
	addu $t2, $t2, $a1 # and compute the ending address for first rectangle row
	addi $t4, $zero, 0x800 # bytes per display row

rectangleYloop:
	move $t3,$a2 # pointer to current pixel for X loop; start at left edge

rectangleXloop:
	sw $t0, 0($t3)
	addiu $t3, $t3, 4
	bne $t3, $t2, rectangleXloop # keep going if not past the right edge of the rectangle

	addu $a2, $a2, $t4 # advance one row for the left edge
	addu $t2, $t2, $t4 # and right edge pointers
	bne $a2, $a3, rectangleYloop # keep going if not off the bottom of the rectangle

rectangleReturn:
    jr $ra
