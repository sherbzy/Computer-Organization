CSCI 341 M3 Program 3A

We will continue to explore coding in MIPS with 3 more coding assignments. In this one, you are asked to learn how to handle strings in MIPS and to write utility functions. This requires an understanding of lb and sb, and the syscall to input strings - you already have the syscall to output strings well in hand, with the prompts you have done in past programs.

What to Submit
Submit an archive file named CSCI341_P3A_YourName with the file extension denoting what type of archive it is (.zip, .tar, or .7z). For example, if I was using 7z, I would submit CSCI341_P3A_AmeliaRead.7z. That archive file must contain just these three files (no other folders or files except the unavoidable .DS_Store and MACOSX on a Mac):

1. string.s, containing the program specified in this assignment.

2. string_record.txt, containing a MARS Record showing the compilation of your program and the output of it run twice.

For the first run, use the inputs:

The quick brown fox jumped over the lazy dog's back!
3
89234
For the second run use the inputs:

*What the =^_^= WANTS, the Human PROVIDES*
32
178A9
3. string_debrief.txt, containing the Program Debrief - follow the instructions, include the questions as well as your answers as requested there. In your debrief, add an item 7 which is "7. Discuss the testing done to ensure the procedures worked correctly",  and include that discussion.

 

Specification
Let's start by developing a library of three String utilities in MIPS (you will use these in P3B).

Develop a MIPS program in a file named string.s with the following procedures and a main that will be described after we describe each utility procedure.

replace(address, old, new), returns number of replacements
1) replace: given a string, a character ("old") to replace, and a character ("new") to replace it with, replace all instances of old with new in the string. Name your procedure replace  and have these be its parameters:

$a0 - address of the string

$a1 - old character in least significant byte

$a2 - new character in least significant byte

the value returned in $v0 should be the number of replacements made.

The replacement is done in place, that is, the string is modified in memory, no new copy of it is created. You can hold characters of the string in registers (registers aren't memory).

Note, you should assume the string is null ('\0') terminated, and that old is never the null character.

rotate(address, howmuch)
2) rotate: given a string and an integer, rotate any alphabetic character (A-Z, a-z) by the amount given. If this moves it past the end of the alphabet, start again at the beginning. Any other characters are left unchanged.

For example, with a Y and a request to rotate it by 4, you would end up with C. A request to rotate by 26 or any multiple of 26 would leave you back on the letter you started with.

Name the procedure rotate. It should take as parameters:

$a0 - address of the string

$a1 - number of characters to rotate by (assume it is >= 0)

The rotation is done in place, that is, the string is modified in memory, no new copy of it is created. You can hold characters of the string in registers (registers aren't memory).

Note, you should assume the string is null ('\0') terminated.

atoi(address) returns integer value or negative index of bad character
3) atoi: given a string, return either a negative number or the positive integer value it represents. That is, if the string is "123", then you would return the value 123. Assume the string is in base 10, i.e. the digits 0-9.

Name your procedure atoi  and have these be its parameters:

$a0 - address of the string

the value returned in $v0 should be the value the string represents, or the negative index of the bad character (first character is at index 1).

If any character in the string is not one of 0,1,2,3,4,5,6,7,8, or 9, return a negative which is the position of the bad character (starting at 1 for the left-most character), times -1. So, for example, atoi("1A2\0") would return -2.

Assume the string is null-terminated, i.e. the last character is '\0'. Do not convert this character or return a negative, just stop processing and return the value computed.

Note, the most straight forward way to do this conversion is to start at the start of the string and accumulate the result by taking the character, changing it to the integer value (look on the ASCII table, see where '0'-'9' are, and then subtract the needed value to turn it into the value needed, i.e., 48). Then, if there is another digit, multiply that value by 10, convert the next value and add them together. Repeat until you run out of digits - you will either find a '\0' which tells you you are done and the value should be returned, or another character, in which case you return the appropriate negative value as described above.

It is fine to assume overflow cannot occur.

Note that the original string value is unchanged by atoi.

 

main...
Great! now that you have those three procedures, you will need to do the following (note, you may want to start this so you can test the procedures as you develop them):

 

Create a .data section with a label named string: that has a .space of 128. This is where you will be putting the strings in main; but your procedures must be handed an address in $a0, they cannot assume space is available (more about this in a bit).

You can create other .data items as well, just be sure that string: .space 128 is present, and that you use the address of string as the target of the requested operations in main.

Mark replace, rotate, and atoi as .globl, i.e. in the .text, before your label for main:, place the directives:

    .globl rotate
    .globl replace
    .globl atoi
You are doing this so we can treat your program like a library and call your functions from a test program.

Do not include the directive .globl main: in your file. This will cause your program to not be usable as a library. You still need a main: label at the start of your entry point, you just aren't making it .globl.

Your main should perform these steps:

prompt the user for a string
when reading the string (use a syscall), store it in the string: location, i.e. use la to load the address of string into the appropriate register, and tell the system call the buffer length is 128.
call replace with $a0 holding the address of string, $a1 holding '\n' and $a2 holding '\0'.
print out the string
print a '\n'
prompt the user for an integer, and read in an integer.
call rotate with $a0 holding the address of string, and $a1 holding the integer
print out the string and a '\n'.
prompt the user for an integer, but read it in as a string, and store the string you read in the string location again.
call replace with $a0 holding the address of string, $a1 holding '\n' and $a2 holding '\0'.
call atoi passing the address of string in $a0
print out the integer that is returned from atoi and a '\n'.
exit the program
Use the prompts shown in the sample output below:

Enter a string: hello, this is my string
hello, this is my string
Enter an integer: 5
mjqqt, ymnx nx rd xywnsl
Enter an integer: 1234
1234
Note that we may run your program with different inputs; its behavior must match the procedures described above. And, we may run your procedures directly without your main and with other inputs (different memory locations and values). The procedures must use MIPS calling conventions so that they can be used as utilities.

Limitations (or lack of limitations)
It is fine to code other procedures, however they must not be marked as .globl. They must be called either by your main or by your replace, rotate, or atoi procedures.

Only use macros (if you choose to use them) for small chunks of code such as the setup and invocation of a syscall. 

Do not use recursion, floating points, or macros for more than a wrapper for a syscall. It is fine to use pseudo instructions.

Keep all of your code in a single file, do not separate procedures into separate files.

When you are manipulating strings, do it a byte at a time; trying to "optimize" by pulling in a word and manipulating it in 4 byte segments will be far more complex than it is worth.

Use the procedure calling conventions appropriately.

Hints
Remember to write pseudocode first, then MIPS. The pseudocode will help keep you on track.

Break development of your procedures down into several steps, for example:

replace: write the replacement code first, and add the counting of replacements once you have replacement working
atoi: write the conversion to an integer first, and add the error-checking/returning once you have it working for good inputs
By keeping characters in the least significant bytes in the registers, they are in the same position that lb and sb put characters in/read characters from registers.

Don't try to optimize by using lw/sw to manipulate characters - the extra complexity isn't worth it, and is likely to cause problems in your code. Always load, manipulate, and store a character (byte) at a time. See the example code provided in the Resources links for examples of counting characters and changing letters to lower case.

You can hard-code values representing characters in your program; in particular, 'A', 'a', '0', and the characters just past 'z' and 'Z' may be useful to you. Use the ascii tableLinks to an external site. to get the decimal or hexadecimal values for them.

You can do a mod operation in MIPS; see these instructions on the green card:

div, divu, mfhi, mflo

Remember to follow the procedure calling conventions:

callee is responsible for saving at the start and restoring at the end: $ra, $sp, $s# registers.
caller is responsible for saving $a#, $t#, $v# registers around any procedure calls (jal's) they make if they need the values after the procedure call.
main is the only code that is only a caller.
leaf procedures are the only code that are only callees.
anything in between or that calls itself is both a callee and a caller, and must abide by both sets of requirements.
Bonus (+1)
In your response to the extra item #7, list the inputs needed to test each procedure fully, and the expected values returned/altered by that test. Avoid listing inputs that would basically be testing the code for the same functionality (in testing, we call these equivalence classes).

If you want to attempt this but are unsure where to start, I recommend

https://softwaretestingfundamentals.com/unit-testing/Links to an external site. 

and

https://softwaretestingfundamentals.com/test-case/Links to an external site. , in particular the section Writing a Good Test Case (your test cases do not need to be as formal as the 16-item test cases described in the article).

Bonus (+2)
Make atoi understand any radix, 2-36. It takes the radix in $a1. If $a1 is an invalid value (<2 or >36) it assumes it is 10. atoi then converts your string assuming it is in the given radix and returns the value that the string represents.

For a discussion of Radix see the Wikipedia entry on Radix.Links to an external site.

Note that for radix's greater than 10, letters A-on are used; your atoi should allow both uppercase and lowercase letters, that is, A=a, and so on.

If the string contains an invalid letter (i.e., not allowed in the given radix), it returns the negative value as described in atoi above.

For example, atoi("12AB",12) is a valid call, since radix 12 would allow A/a, B/b, and C/c. But a D in the string would be an invalid letter. If atoi is handed a radix of 2, only 1's and 0's could appear in the string.

If the conversion results in a number that will not fit in 32 bits, return a value that is the negative of the length plus one (i.e., one more than the largest index possible for a bad digit). Note, your program should not result in an exception on a large result. (Hint: this will require using mfhi and mflo if doing multiplication.)

If you are doing the bonus and wish to use recursion or break the other limitations, contact me so we can discuss your approach; if it's reasonable, I will approve breaking the limitations.

Coding Style
Apply the Code Style Guide - be sure to have a program header comment
Use meaningful names for labels that give the reader a clue as to the purpose of the thing being named (loop/if/else targets, procedure entry points, data labels).
Use comments at the start of each procedure to describe the purpose of the procedure and the purpose of each parameter to the procedure and a description of its return value (if any).
Only allocate the stack space you need; see the Notes on Procedure Calls in MIPS
Use comments at the start of each block of code to explain what that part of the program does.
