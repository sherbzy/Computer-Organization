# Author: Lauren Sherburne
# Class: CSCI 341 - Computer Organization
# Date: 11/05/2020
# Assignment Name: Module 3 Program 3B - Cycles
# Program Description: This program asks the user for 5 cycle time values and uses 3 procedures to: print the values, return the
#					   longest value, and return the average overhead. The program continues to loop and ask the user for values
#					   until the user enters a value that is less than one for the first cycle value ends. This results in the 
#					   program terminating.


	.data
	cycles: .space 20	# pre-allocate an array named cycles with 5 words of space
	prompt: .asciiz "Enter length of cycle "
	invalidEntry: .asciiz "I'm sorry, but this input was invalid. Please try again. \n"
	longestCycle: .asciiz "Longest cycle is: "
	averageOverhead: .asciiz "Average overhead is: "
	newLine: .asciiz "\n"
	semicolon: .asciiz ": "
	openBracket: .asciiz "["
	closeBracket: .asciiz "]"
	commaSpace: .asciiz ", "

# declare procedures in .globl, but not main
	.text
	.globl longest
	.globl overhead
	.globl tostring

# main indicates the starting point of the program
main:
	# using a loop, ask user for 5 inputs ensuring that the first input is less than zero
	li $t0, 0	# set a counter to zero
	li $t1, 4	# set a variable to indicate the end of the looping
	
loop:
	# prompt the user to enter an input...
	la $a0, prompt
	li $v0, 4
	syscall
	
	# ...and indicate which number input the user is entering...
	addi $a0, $t0, 1
	li $v0, 1
	syscall
	
	# ...followed by a semicolon
	la $a0, semicolon
	li $v0, 4
	syscall
	
	# read in an input from the user
	li $v0, 5
	syscall
	
	# if the first input and the value is less than zero, end the program
	bne $t0, $zero, continue	# if ($t0 != 0) continue in the loop
	slt $t5, $v0, $zero
	beq $t5, $zero, continue	# if ($v0 < 0) continue in the loop
	j endProgram

continue:
	# otherwise add the user's input to the array
	la $a0, cycles	# put address of array in $a0
	sll $t6, $t0, 2	# multiply index value by 4
	add $a0, $a0, $t6	# add the index to the address
	sw $v0, 0($a0) #store value in array using new address
	
	# once 5 inputs have been reached, move on to call procedures
	beq $t0, $t1, callProcedures
	
	# otherwise increment the counter and loop again
	addi $t0, $t0, 1
	j loop
	
callProcedures:	
	# call tostring procedure
	la $a0, cycles	# put address of array in $a0
	jal tostring
	
	# call longest procedure
	la $a0, cycles	# put address of array in $a0
	jal longest
	
	# print result from longest procedure
	la $a0, longestCycle
	add $t7, $v0, $zero
	li $v0, 4
	syscall
	
	la $a0 ($t7)
	li $v0, 1
	syscall
	
	# print a new line
	la $a0, newLine
	li $v0, 4
	syscall
	
	# call overhead procedure
	la $a0, cycles	# put address of array in $a0
	jal overhead
	
	# print result from overhead procedure
	la $a0, averageOverhead
	move $t7, $v0
	li $v0, 4
	syscall
	
	la $a0 ($t7)
	li $v0, 1
	syscall
	
	# print a new line
	la $a0, newLine
	li $v0, 4
	syscall
	
	# loop to request more inputs from the user and set the counter back to zero
	li $t0, 0
	li $t1, 4
	j loop
	
endProgram:	
	# end the program
	li $v0, 10
	syscall





# procedure that takes in an array (address: $a0) of 5 elements and returns the largest value ($v0)
longest:
	li $t0, 1	# set a counter to two
	li $t1, 4	# set a variable to indicate the end of the looping
	
	# set temporary variable $t4 equal to the first element of the array
	lw $t4, 0($a0)
	
# loop through the array and compare all the elements to determine the largest value
loopDieDooDaa:
	# set the temporary variable $t5 equal to the current element of the array
	la $a1 ($a0)
	add $t6, $t0, $zero
	sll $t6, $t6, 2
	add $a1, $a1, $t6
	lw $t5, 0($a1)
	
	# if ($t5 < $t4) skip
	slt $t3, $t5, $t4
	bne $t3, $zero, skip
	add $t4, $t5, $zero	# $t4 = $t5
	
skip:
	# determine whether or not to loop again
	beq $t0, $t1, overAndOut
	addi $t0, $t0, 1	# increment the counter
	j loopDieDooDaa
	
overAndOut:
	# since return value is $v0, set $v0 = $t4
	add $v0, $t4, $zero
	
	# return to main
	jr $ra




# procedure that takes in an array (address: $a0) of 5 elements and returns the average overhead of the 5 values ($v0)
overhead:
	# determine the longest cycle time using the longest procedure and store it in a temporary variable
	# add space to the stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)	# store the previous $ra value to the stack
	jal longest
	move $t4, $v0	# $t4 holds the longest cycle time
	lw $ra, 0($sp)	# load the previous $ra value
	addi $sp, $sp, 4	# deallocate space on the stack
	
	# prepare values for the loop
	li $t0, 0	# set a counter to zero
	li $t1, 4	# set a variable to indicate the end of the looping
	li $t2, 0	# inititalize a temporary variable to hold the total overhead
	
# loop through the array, adding up the 5 overhead values
weLoveLooping:
	# load the current array element value into a temporary variable
	la $a1 ($a0)
	add $t3, $t0, $zero
	sll $t3, $t3, 2
	add $a1, $a1, $t3
	lw $t3, 0($a1)
	
	# calculate the current overhead (longest value - current value) and add it to the total overhead value
	sub $t5, $t4, $t3
	add $t2, $t2, $t5
	
	# determine whether or not to loop again
	beq $t0, $t1, dropTheMic
	addi $t0, $t0, 1	# increment the counter
	j weLoveLooping
	
dropTheMic:
	# divide the total overhead by 5
	li $t6, 5	# use a temporary to hold the number of cycles
	div $t2, $t6
	mflo $v0	# place the average overhead result in $v0

# return to main
jr $ra




# procedure that takes in an array (address: $a0) of 5 elements and displays the elements
tostring:
	la $a1 ($a0)	# transfer address of array so that $a0 is usable in syscalls
	
	# start by printing an open bracket
	la $a0, openBracket
	li $v0, 4
	syscall
	
	# next set up the array for the loop
	li $t0, 0	# set a counter to one
	li $t1, 4	# set a variable to indicate the end of the looping
	
# loop through array, printing each element
toasterStrudel:
	# find the address and value for the current array element
	la $a2 ($a1)
	add $t3, $t0, $zero
	sll $t3, $t3, 2
	add $a2, $a2, $t3
	
	# print the current array element
	lw $a0 0($a2)
	li $v0, 1
	syscall
	
	# if the counter is not 5, print a comma and space
	beq $t0, $t1, next
	la $a0,  commaSpace
	li $v0, 4
	syscall
	
next:
	# determine whether or not to loop again
	beq $t0, $t1, toInfinityAndBeyond
	addi $t0, $t0, 1 # increment the counter
	j toasterStrudel
	
toInfinityAndBeyond:
	# print a close bracket
	la $a0, closeBracket
	li $v0, 4
	syscall
	
	# print a new line
	la $a0, newLine
	li $v0, 4
	syscall

	# return to main
	jr $ra
