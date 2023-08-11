CSCI 341 M3 Program 3B

We continue to explore coding in MIPS; in this assignment, we will revisit nested procedures - you will end up with main calling a procedure that calls another procedure, and must follow the procedure calling conventions when you do so.

Submit an archive file named CSCI341_P3B_YourName with the file extension denoting what type of archive it is (.zip, .tar, or .7z). For example, if I was using zip, I would submit CSCI341_P3B_AmeliaRead.zip. That archive file must contain just these three files (no other folders or files except the unavoidable .DS_Store and MACOSX on a Mac):

1. cycles.s, containing the program specified in this assignment.

2. cycles_record.txt, containing a MARS Record showing the compilation of your program and the output of it running with the following inputs:

100
200
300
200
100
300
300
300
300
100
-1
3. cycles_debrief.txt, containing the Program Debrief - follow the instructions, include the questions as well as your answers as requested there. In your debrief, add an item 7 which is "7. Discuss how your code follows the procedure calling conventions (ABI)",  and include that discussion.

 

Specification
Develop a MIPS program in a file named cycles.s with the following functionality. It must include the procedures described here; you can also define additional procedures, but the three described here must be present and named as described here.

Your program provides insights into the cycle speed of a MIPS 5-stage pipeline. It reports the longest cycle of the 5 a user inputs, and then the average overhead (unused time) of the 5 stages. It does this by requesting 5 values from the user, storing them in an array (5 contiguous words in memory, allocated in your .data section ahead of time), then invoking procedures (using jal) to determine first the longest cycle and then the average overhead.

It will keep asking for 5 inputs until the first input value is less than zero, at which point it exits.

The three procedures that must be defined must be named

longest

and

overhead

and

tostring

and they must be declared to be

.globl

so that an external test program can invoke them.

main must not be declared .globl.

 

tostring(array) displays the contents of an array of 5 elements.
tostring is handed the address of an array in $a0. It makes syscalls to produce output that, for an array containing the values 1, 2, 3, 4, 5 would look like this:

[1, 2, 3, 4, 5]
tostring does not change the array contents or return any values.

 

longest(array) returns largest value in array
longest is handed the address of an array in $a0. It has no other parameters.

longest returns in $v0 the largest value found in the array in its 5 entries, which is the longest cycle time of those entered.

Note that the original array entries are unchanged by this procedure.

(note, the use of $a0 and $v0 come directly from the procedure calling conventions.)

 

overhead(address) returns the average overhead of the 5 entries
overhead is handed the address of an array in $a0. It has no other parameters.

overhead returns in $v0 the average overhead from the 5 values. It must invoke longest to determine the longest value in the array, and then use that to calculate the overhead in each cycle. Overhead is how much time that stage has to wait to the end of its clock cycle - the unused time.

It returns the average overhead in $v0 - i.e., the average of the 5 overhead values calculated. (Hint: one entry will have an overhead of 0.)

This should be done as an integer calculation; add up the 5 overheads and then divide by five, returning the integer division as your resulting value. It is fine to assume overflow cannot occur.

Note that the original array entries are unchanged by this procedure.

 

Notes on main...
main was described above the two procedures; note that it must contain a loop, and must prompt the user for 5 values.

The array is pre-allocated in your .data section using either a .space or an appropriate directive to ensure 5 words of space are allocated. Give it the name cycles: since the values present represent individual cycle lengths.

Do not use the syscall to allocate space for this; define a fixed-space in your .data section.

You can create other .data items as well, just be sure that cycles: is present, and that you use the address of cycles as the value of $a0 when invoking procedures from main.

Mark tostring and longest and overhead as .globl, i.e. in the .text, before your label for main:, using the directives:

    .globl tostring
    .globl longest
    .globl overhead
You are doing this so we can treat your program like a library and call your functions from a test program.

Do not include the directive .globl main: in your file. This will cause your program to not be usable as a library. You still need a main: label at the start of your program's entry point, you just aren't making it .globl.

main requests 5 values from the user, storing them in an array (5 contiguous words in memory, allocated in your .data section ahead of time), then invoking procedures (using jal) to determine first the longest cycle and then the average overhead and reporting those values to the user.

It will keep asking for 5 inputs until the first input value is less than zero, at which point it exits.

Use the prompts shown in the sample output below:

Enter length of cycle 1: 200
Enter length of cycle 2: 200
Enter length of cycle 3: 200
Enter length of cycle 4: 200
Enter length of cycle 5: 200
[200, 200, 200, 200, 200]
Longest cycle is 200
Average overhead is 0
Enter length of cycle 1: -99
When you prompt for inputs, do this in a loop and re-use your prompt, do not have 5 distinct prompt strings in memory.

Note that we may run your program with different inputs; its behavior must match the procedures described above. And, we may run your procedures directly without your main and with other inputs (different memory locations and values). Your procedures must use MIPS calling conventions so that they can be used as utilities from other programs.

Limitations (or lack of limitations)
It is fine to code other procedures, however they must not be marked as .globl. They must be called either by your main or by your longest or overhead procedures.

Only use macros (if you choose to use them) for small chunks of code such as the setup and invocation of a syscall. 

If overflow were to occur with the values input, your code must not throw exceptions; choose your arithmetic operations to ensure this.

Do not use recursion, floating points, or macros for more than a wrapper for a syscall. It is fine to use pseudo instructions.

Keep all of your code in a single file, do not separate procedures into separate files.

Your code can assume there are always 5 array entries; it must not use syscall to allocate space.

You must not have 5 different prompts for the values; only one string should be used, along with an integer printed out to request input for each cycle as shown in the sample output above.

Use the procedure calling conventions appropriately.

Hints
Remember to write pseudocode first, then MIPS. The pseudocode will help keep you on track.

Break development of your procedures down into several steps, for example:

write main first to read in the 5 values.
write tostring to print out the array contents; this can be useful to use within longest and overhead while you are coding them, as well as being used in main to display the array contents before invoking longest and overhead
write longest to determine the longest value in the array, then invoke it from main and display its result. Unless you write additional procedures used by longest, it will be a leaf procedure, and must apply procedure calling conventions appropriate to that.
write overhead to determine the average overhead; note, since it is not handed the return value from longest, it must also invoke longest to determine that value - this is by design, so that you have a procedure (overhead) that is both a caller and a callee. It must apply procedure calling conventions appropriately.
Note that main and tostring also must apply procedure calling conventions; main is only a caller, not a callee; and tostring will likely be a leaf procedure.

For MIPS integer division, see these instructions on the green card:

div, divu, mfhi, mflo

Remember to follow the procedure calling conventions:

procedures are invoked with jal; no other jumps should use jal; procedures exit with jr $ra; no other jumps should use jr $ra
each procedure should contain only one jr $ra statement
callee is responsible for saving at the start and restoring at the end: $ra, $sp, $s# registers.
caller is responsible for saving $a#, $t#, $v# registers around any procedure calls (jal's) they make if they need the values after the procedure call.
main is the only code that is only a caller.
leaf procedures are the only code that are only callees.
anything in between or that calls itself is both a callee and a caller, and must abide by both sets of requirements.
none of your procedures (including main) can assume that any register starts out as 0; it must initialize any register it uses before adding, subtracting, or otherwise modifying the value in the array.
 

Coding Style
Apply the Code Style Guide - be sure to have a program header comment
Use meaningful names for labels that give the reader a clue as to the purpose of the thing being named (loop/if/else targets, procedure entry points, data labels).
Use comments at the start of each procedure to describe the purpose of the procedure and the purpose of each parameter to the procedure and a description of its return value (if any).
Only allocate the stack space you need; see the Notes on Procedure Calls in MIPS
Use comments at the start of each block of code to explain what that part of the program does.
