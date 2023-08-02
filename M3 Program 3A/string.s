# Name: Lauren Sherburne
# Class: CSCI 341 - Computer Organization
# Date: October 22, 2020
# Assignment: CSCI 341 M3 Program 3A
#
# Description: string manipulation


# create data objects in the .data section
	.data
	string:    .space 128	# creates a 128 bits string
	promptForString:    .asciiz "Enter a string: "    # create a prompt that asks the user to input a string
	newLine:   .asciiz "\n"    # string that prints a new line
	promptForInteger:	.asciiz "Enter an integer: "    # create a prompt that asks the user to input an integer
	
	.text
	.globl rotate
	.globl replace
	.globl atoi
	
# main indicates the starting point or entrance point of the program
main:
    #prompt the user for a string
    la $a0, promptForString
    li $v0, 4
    syscall
    
    # read input from the user and store it in the string location
    la $a0, string
    li $a1, 128
    li $v0, 8
    move $t0, $a0
    syscall
    
	# call replace with $a0 holding the address of string, $a1 holding '\n' and $a2 holding '\0'.
	la $a0, string
	li $a1, '\n'
	li $a2, '\0'
	jal replace

	#print out the string
	move $a0, $t0
	li $v0, 4
	syscall

	# print a '\n'
    la $a0, newLine
    li $v0, 4
    syscall
     
    # prompt the user for an integer
    la $a0, promptForInteger
    li $v0, 4
    syscall
    
    # read in an integer
    li $v0, 5
    syscall
    
	# call rotate with $a0 holding the address of string, and $a1 holding the integer
	la $a0, string
	move $a1, $v0
	jal rotate

	#print out the string
	la $a0, string
	li $v0, 4
	syscall

	# print a '\n'
    la $a0, newLine
    li $v0, 4
    syscall
    
    # prompt the user for an integer
    la $a0, promptForInteger
    li $v0, 4
    syscall
    
	# read the integer input as a string and store it in the string location
    la $a0, string
    li $a1, 128
    li $v0, 8
    syscall
    
	# call replace with $a0 holding the address of string, $a1 holding '\n' and $a2 holding '\0'.
	la $a0, string
	la $a1, newLine
	la $a2 ($zero)
	jal replace
	
	# call atoi passing the address of string in $a0
	la $a0, string
	jal atoi
	
	# print out the integer that is returned from atoi
	la $a0 ($v1)
	li $v1, 1
	syscall
	
	# print a '\n'
    la $a0, newLine
    li $v0, 4
    syscall
    
    # exit the program
    addi $v0, $zero, 10
    syscall
    




# replace (address [$a0], old [$a1], new [$a2]) returns number of replacements [$v0]
replace:
	# allocate space on the stack
	addi $sp, $sp, -4
	sw $ra, 0($sp) 

	# set up temporary values
	move $t0, $a0
	add $t1, $0, $a1
	add $t2, $zero, $a2
	addi $t7, $0, 0
	addi $t6, $0, 0

# loop through all the characters in the string	
stringLoop:
	add $t3, $t0, $t7
	lb $t4, 0($t3)
	beq $t4, $zero, end
	bne $t4, $t1, dontChange
	sb $t2, ($t3)
	addi $t6, $t6, 1

dontChange:
	addi $t7, $t7, 1 #i++
	j stringLoop

end:
	move $a0, $t3
	move $v0, $t6

	lw $ra, 0($sp)
	addi $sp, $sp, 4

# return to main
	jr $ra





# rotate (address [$a0], howmuch [$a1])
rotate:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	move $t0, $a0
	add $t1, $0, $t0
	addi $t7, $0, 0

# loop through the characters in the string
charLoop:
	add $t2, $t0, $t7
	lb $t3, 0($t2)
	beq $t3, $zero, exit

	slti $t6, $t3, 91
	beq $t6, 1, rotateCapitals

	slti $t6, $t3, 123
	beq $t6, 1, rotateLowers

next:
	sb $t3, ($t2)
	addi $t0, $t0, 1
	j charLoop

# rotate any lower case letters
rotateLowers:
	slti $t6, $t3, 96
	beq $t6, 1, next
	add $t3, $t3, $a1 #constant numbers for letter rotation
	slti $t6, $t3, 123
	beq $t6, 1, next
	subi $t4, $t3, 122
	addi $t3, $t4, 96
	j next

# rotate any capital letters
rotateCapitals:
	slti $t6, $t3, 65
	beq $t6, 1, next
	add $t3, $t3, $a1
	slti $t6, $t3, 91#constant numbers for letter rotation
	beq $t6, 1, next
	subi $t4, $t3, 90
	addi $t3, $t4, 64
	j next

exit:
	move $v0, $t3


	lw $ra, 0($sp)
	addi $sp, $sp, 4

# return to main
	jr $ra






# atoi (address) returns integer value or negative index of bad character [$v1]
atoi:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	move $t2, $a2

	move $t0, $a0
	addi $t1, $0, 92 #\
	addi $t2, $zero, 40 #0
	addi $t7, $0, 0
	addi $t6, $0, 0

# loop through all the characters in the string
stringLooping:
	add $t3, $t0, $t7
	add $t9, $t3, $zero
	lb $t4, 0($t3)
	beq $t4, $t1, printEnd

	sltiu $t8 $t4, 48  # t1 = (x < 48) ? 1 : 0
	bnez  $t8, finished
	sltiu $t8, $t4, 58  # t1 = (x < 58) ? 1 : 0
	beqz  $t8, finished


	bne $t4, $t1, increment

	addi $t6, $t6, 1 #counter

increment:
	# increment the counter and loop
	addi $t7, $t7, 1

	j stringLooping

negativeCount:
	move $a0, $t3
	move $v0, $t6

	# make the count into a negative number by doubling it then subtracting from itself
	move $v1, $t7
	add $t8, $t7, $t7
	sub $v1, $v1, $t8

	move $a0, $v1  # move $v1 -> $a0
	li $v0, 1      # print string command
	syscall        # execute print int

	# deallocate stack space
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	# return to main
	jr $ra

finished:
	# increment the counter and make the count negative
	addi $t7, $t7, 1
	jal negativeCount

printEnd:

	move $v1, $a0

	move $a0, $v1  # move $t0 -> $a0
	li $v0, 4      # print string command
	syscall        # execute print int



	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


