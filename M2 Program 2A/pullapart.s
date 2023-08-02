    .data    # Declare and initialize variables
    prompt: .asciiz "Enter an integer: "
    sign: .asciiz "Sign bit is: "
    space: .asciiz "  "
    bytes: .asciiz "\nBytes are: "
    
    .text    # Code starts here
main:        # Label marking the entry point of the program
    # Prompt the user to enter an integer
    li $v0, 4
    la $a0, prompt
    syscall
    
    # Input integer value
    li $v0, 5
    syscall
    
    # Move integer to address $t0
    move $t0, $v0
    
    # Find and print the sign bit by using a logical shift
    li $v0, 4
    la $a0, sign
    syscall
    
    li $v0, 1
    srl $t1, $t0, 31
    la $a0, ($t1)
    syscall
    
    # Find and print the individual bytes
    li $v0, 4
    la $a0, bytes
    syscall
    
    # Print the first byte followed by space
    li $v0, 1
    srl $t2, $t0, 24
    la $a0, ($t2)
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # Print the second byte followed by a space
    li $v0, 1
    sll $t3, $t0, 8
    srl $t3, $t3, 24
    la $a0, ($t3)
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # Print the third byte followed by a space
    li $v0, 1
    sll $t4, $t0, 16
    srl $t4, $t4, 24
    la $a0, ($t4)
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # Print the fourth byte
    li $v0, 1
    sll $t5, $t0, 24
    srl $t5, $t5, 24
    la $a0, ($t5)
    syscall
    
    li $v0, 10    # set the syscall to exit
    syscall       # make the system call
    