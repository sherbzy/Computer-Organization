.data
NL: 	. "\n"
PROMPT:	.asciiz "Enter a integer:"
PROMPT2: .asciiz "Try Again <<00<< " 
	


.text

main:
	# Print Prompt
	la $a0, PROMPT
	li $v0, 4
	syscall
	#Take user input
	li $v0, 5
	syscall
	move $s0, $v0
	
	#load user input into $a0 and jump to leaf
	la $a0, ($s0)
	jal leaf
	
	#once the output is selected come here
	#load s0 (user input) into t9
	addi $sp, $sp -4
	add $t9, $zero, $s0 #load 
	#anything with t8 will do nothing, there were trying to confuse us
	add $t8, $0, $t9
	sll $t8, $t8, 20
sw $t8, 0($sp) 
	#shift user input right by 31 bits to find sign bit
	srl $t9, $t9, 31
	#if sign bit is 1, number is negative and jump to leaf2
	beq $t9, 1, leaf2
	
	#load v0 into a0
	#the v0 comes from the exit1 or exit2
	la $a0, ($v0)
	#Print integer stored in a0
	li $v0, 1
	syscall
	#End program
	li $v0, 10
	syscall

leaf2:
	lw $t8, 0($sp)
	and $t8, $t8, $t9
	addi $sp, $sp, 4
	#print prompt 2 take user input and jump back to main
	la $a0, PROMPT2
	li $v0, 4
	syscall
la $a0, NL
	li $v0, 4
	syscall
	j main

leaf:
	#load 0 into v0 and 2 into t0
	addi $v0, $zero, 0
	addi $t0, $zero, 2
	la $t1, ($a0)

	#divide user input by two and add 1
	#store into t1
	sra $t1, $t1, 1
	addi $t1, $t1, 1
	
	#If user input is 0 or 1 jump to Exit 2
	beqz $a0, exit2
	beq $a0, 1, exit2

loop:
	# if (t0 < t1)
	slt $t2, $t0, $t1
	#if false then jump to exit 1
	beq $t2, $zero, exit1
	
	#set t3 to input and t4 to t0
	addi $t3, $a0, 0 
	addi $t4, $t0, 0 

innerLoop:
	#if (t3 < t4)
	slt $t5, $t3, $t4
	#if above is true go to exitRL
	beq $t5, 1, exitRL
	#else subtract 2 from t3
	sub $t3, $t3, $t4
	#call innerloop until t3< t4
	j innerLoop
exitRL:
	# if t3 ==0 then number is even and jump to exit2
	beq $t3, $zero, exit2
	#else add 1 to t0
	addi $t0, $t0, 1
	#jump back to loop
	j loop
	
exit1:
	#store 1 in v0 and jump back to main
	li $v0, 1
	jr $ra
	
exit2:
	#store 0 in v0 and jump back to main
	li $v0, 0
	jr $ra

