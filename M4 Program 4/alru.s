# Author: Lauren Sherburne
# Class: CSCI 341 - Computer Organization
# Date: 12/09/2020
# Assignment Name: Module 4 Program 4 - Approximate LRU
# Program Description: This program takes in an initial value (0-7) from the user and estimates the state of the system.
		       Then, it requests the user to input the value accessed (0-3) and updates the system. If any of the
		       values entered are out of bounds, the program is terminated.


# declare and/or initiate variables within the .data section
    .data
    initialStatePrompt: .asciiz "Initial state: "
    entryAccessedPrompt: .asciiz "Entry accessed: "
    newline: .asciiz "\n"
    space: .asciiz " "
    
    .text

# this is where the magic happens...
main:
	# ask the user for the initial state of the cache
	la $a0, initialStatePrompt
	li $v0, 4
	syscall
	
	# input user's initial state value (between 0 and 7)
	li $v0, 5
	syscall
	
	# if the input is less than 0, exit the program
	slti $t3, $v0, 0
	beq $t3, 1, exitProgram
	
	# if the input is greater than 7, exit the program.
	li $t4, 7
	slt $t3, $t4, $v0
	beq $t3, 1, exitProgram
	
	# determine and print the initial state of the system
	la $a0 ($v0)
	jal initialState
	move $t0, $v0

	# loop until value is outside the range 0-3, then exit program
loopadidooda:
	# newline
	la $a0, newline
	li $v0, 4
	syscall

	# ask the user for the cache entry accessed
	la $a0, entryAccessedPrompt
	li $v0, 4
	syscall
	
	# input user's entry accessed value (between 0 and 3)
	li $v0, 5
	syscall
	
	# if the input is less than 0, exit the program
	slti $t3, $v0, 0
	beq $t3, 1, exitProgram
	
	# if the input is greater than 3, exit the program.
	li $t4, 3
	slt $t3, $t4, $v0
	beq $t3, 1, exitProgram
	
	# place the previous system state bits in $t0-$t2 (b0-b2)
	move $a0, $t0
	sll $t0, $a0, 31
	srl $t0, $t0, 31
	
	la $t1 ($a0)
	srl $t1, $t1, 1
	sll $t1, $t1, 1
	sll $t1, $t1, 30
	srl $t1, $t1, 31
	
	la $t2 ($a0)
	srl $t2, $t2, 2
	sll $t2, $t2, 31
	srl $t2, $t2, 31

	
	# update and print the system---------------------------------------------------------------
	beq $v0, $zero, ZeroIsHero
	beq $v0, 1, OneIsFun
	beq $v0, 2, TwoIsBlue
	beq $v0, 3, ThreeIsFreeee
	
ZeroIsHero:
	bne $t2, $zero, notZero
	li $t2, 1
	bne $t1, $zero, changeToOne
	li $t0, 0
	li $t1, 1
	# finished update
	j completedUpdate
		
		changeToOne:
			li $t0, 1
			li $t1, 1
			# finished update
			j completedUpdate
	
	notZero:
	bne $t1, $zero, completedUpdate
	li $t1, 1
	# finished update
	j completedUpdate
	
OneIsFun:
	bne $t2, $zero, nootZero
	li $t2, 1
	bne $t1, $zero, changToOne
	li $t0, 0
	li $t1, 0
	# finished update
	j completedUpdate
		
		changToOne:
			li $t0, 1
			li $t1, 0
			# finished update
			j completedUpdate
	
	nootZero:
	beq $t1, $zero, completedUpdate
	li $t1, 0
	# finished update
	j completedUpdate
	
TwoIsBlue:
	beq $t2, $zero, isZero
	li $t2, 0
	beq $t1, $zero, changeToZero
	li $t0, 1
	li $t1, 1
	# finished update
	j completedUpdate
	
	
		changeToZero:
			li $t0, 0
			li $t1, 1
			# finished update
			j completedUpdate
	
	isZero:
	bne $t1, $zero, completedUpdate
	li $t1, 1
	# finished update
	j completedUpdate
	
ThreeIsFreeee:
	beq $t2, $zero, issZero
	li $t2, 0
	beq $t1, $zero, changToZero
	li $t0, 1
	li $t1, 0
	# finished update
	j completedUpdate
	
	
		changToZero:
			li $t0, 0
			li $t1, 0
			# finished update
			j completedUpdate
	
	issZero:
	beq $t1, $zero, completedUpdate
	li $t1, 0
	# finished update
	j completedUpdate
	# ------------------------------------------------------------------------------------------
	# system done updating
	
	
completedUpdate:
	# combine the bits to form an integer ($a0)
	# 4 * bit 2
	sll $t2, $t2, 2
	# 2 * bit 1
	sll $t1, $t1, 1
	# bit 0 + bit 1 + bit 2
	add $a0, $t0, $t1
	add $a0, $a0, $t2
	
	jal initialState

	# jump to the beginning of the loop
	j loopadidooda
	
    # exit the program
exitProgram:
	li $v0, 10
    syscall
    
    
    
    
# this procedure takes in an integer ($a0) and prints the initial state of the system
# it returns this initial state as an integer in $v0
initialState:
	# track the initial state in $t7
	la $t7 ($a0)
	
    # determine bit 2 ($t0)
    srl $t0, $t7, 2
    
    # if bit 2 is 0, 2/3 pair is first
    beq $t0, $zero, twoThreeFirst
    
    # otherwise, 0/1 pair is first
    # determine bit 1 ($t1)
	la $t1 ($t7)
	srl $t1, $t1, 1
	sll $t1, $t1, 1
	sll $t1, $t1, 30
	srl $t1, $t1, 31
    
    # if bit 1 is 0, print 1 then 0
    beq $t1, $zero, printOneFirst
    
    # otherwise, print 0...
    li $a0, 0
    li $v0, 1
    syscall
    
    # followed by a space
    la $a0, space
	li $v0, 4
	syscall
    
    # then print 1...
    li $a0, 1
    li $v0, 1
    syscall
    
    # followed by a space and move on to the second set
    la $a0, space
	li $v0, 4
	syscall
    j doneFirstSet
    
printOneFirst:
    # print 1...
    li $a0, 1
    li $v0, 1
    syscall
    
    # followed by a space
    la $a0, space
	li $v0, 4
	syscall
    
    # print 0...
    li $a0, 0
    li $v0, 1
    syscall
    
    # followed by a space and move on to the second set
    la $a0, space
	li $v0, 4
	syscall
    
doneFirstSet:
	# determine bit 0 ($t0)
	sll $t0, $t7, 31
	srl $t0, $t0, 31
    
    # if bit 0 is 0, print 3 then 2
    beq $t0, $zero, printThreeFirst
    
    # otherwise, print 2...
    li $a0, 2
    li $v0, 1
    syscall
    
    # followed by a space
    la $a0, space
	li $v0, 4
	syscall
    
    # then print 3 and return to main
    li $a0, 3
    li $v0, 1
    syscall
    j overAndOut
    
printThreeFirst:
    # print 3...
    li $a0, 3
    li $v0, 1
    syscall
    
    # followed by a space
    la $a0, space
	li $v0, 4
	syscall
    
    # print 2 and return to main
    li $a0, 2
    li $v0, 1
    syscall

	# jump back to main
	j overAndOut

twoThreeFirst:
	# determine bit 1 ($t1)
	la $t1 ($t7)
	srl $t1, $t1, 1
	sll $t1, $t1, 1
	sll $t1, $t1, 30
	srl $t1, $t1, 31
    
    # if bit 1 is 0, print 3 then 2
    beq $t1, $zero, threeFirst
    
    # otherwise, print 2...
    li $a0, 2
    li $v0, 1
    syscall
    
    # followed by a space
    la $a0, space
	li $v0, 4
	syscall
    
    # then print 3...
    li $a0, 3
    li $v0, 1
    syscall
    
    # followed by a space and move on to the second set
    la $a0, space
	li $v0, 4
	syscall
    j doneWithFirst
    
threeFirst:
    # print 3...
    li $a0, 3
    li $v0, 1
    syscall
    
    # followed by a space
    la $a0, space
	li $v0, 4
	syscall
    
    # print 2...
    li $a0, 2
    li $v0, 1
    syscall
    
    # followed by a space and move on to the second set
    la $a0, space
	li $v0, 4
	syscall
    
doneWithFirst:
	# determine bit 0 ($t0)
	sll $t0, $t7, 31
	srl $t0, $t0, 31
    
    # if bit 0 is 0, print 1 then 0
    beq $t0, $zero, oneFirst
    
    # otherwise, print 0...
    li $a0, 0
    li $v0, 1
    syscall
    
    # followed by a space
    la $a0, space
	li $v0, 4
	syscall
    
    # then print 1 and return to main
    li $a0, 1
    li $v0, 1
    syscall
    j overAndOut
    
oneFirst:
    # print 1...
    li $a0, 1
    li $v0, 1
    syscall
    
    # followed by a space
    la $a0, space
	li $v0, 4
	syscall
    
    # print 0 and return to main
    li $a0, 0
    li $v0, 1
    syscall
	
overAndOut:	
    # return to main
    move $v0, $t7
    jr $ra
