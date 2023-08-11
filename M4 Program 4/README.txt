M4 Program 4

In our final program, you will be implementing the LRU (least recently used) approximation algorithm discussed in class, in MIPS.

What to Submit
Submit an archive file named CSCI341_P4_YourName with the file extension denoting what type of archive it is (.zip, .tar, or .7z). For example, if I was using zip, I would submit CSCI341_P4_AmeliaRead.zip. That archive file must contain just these three files (no other folders or files except the unavoidable .DS_Store and MACOSX on a Mac):

1. alru.s, containing the program specified in this assignment.

2. alru_record.txt, containing a MARS Record showing the compilation of your program and the output of it running with the following inputs:

6
3
0
1
2
1
1
-1
3. alru_debrief.txt, containing the Program Debrief - follow the instructions, include the questions as well as your answers as requested there. In your debrief, add an item 7 which is "7. Discuss how you tested your code or otherwise ensured it was behaving correctly.",  and include that discussion.

Note that any mis-named or mis-located files will not be considered part of your submission or examined for grading (no longer will we be renaming or moving files if they are incorrectly submitted).

Specification
Develop a MIPS program in a file named alru.s with the following functionality. It must include the procedures described here; you can also define additional procedures, but those described here must be present and named as described here.

Your program simulates the alru hardware process by tracking cache accesses and printing the impact of each access on the LRU order of the cache. It uses the Approximate LRU method discussed in class.

The Cache
Your code will not actually have a cache; it will only track the LRU ordering of 4 cache entries using the Approximate LRU method:

1 bit to decide which pair of blocks is LRU.
1 bit for each pair to denote which item of the pair is LRU.
Consider the cache entries as numbered 0-3: first entry is 0, second is 1, third is 2, and fourth is 3. The first pair is entries 0 and 1; the second pair is entries 2 and 3.

For the bit values in the aLRU value: a 0 means the first pair/item is LRU, and a 1 means the second pair/item is LRU, respectively.

We number the bits in the aLRU value left-to-right as b2, b1, and b0; b2 denotes which pair of blocks is LRU; b1 denotes which in the first pair (entries 0 and 1) is LRU; and b0 denotes which in the second pair (entries 2 and 3) is LRU.

The Simulation - Initial State
The simulation starts by asking the user for the initial state of the cache; this will be some value between 0 and 7. If the input value is out of range, your program should exit.

Interpreting that value: the most significant bit (bit position 2) tells you which pair of blocks is LRU; the next bit (position 1) tells you which item of the first pair of blocks (0 and 1) is LRU; and the final bit (position 0) tells you which item of the second pair (2 and 3) is LRU. A 0 means the first pair/item is LRU, and a 1 means the second pair/item is LRU, respectively.

For example, if the initial state is set to 5 (0b101), then the second pair is least recently used; in the first pair, 1 is more recently used than 0; in the second pair, 2 is more recently used than 3. We would report a current approximate recently used order of: 1 0 2 3.

The Simulation - Updates
Once an initial state is established, your program will loop until a value outside the range 0-3 is input (i.e., < 0 or > 3). Once a value outside that range is entered, the program will exit.

If a value in the range 0-3 is input, it identifies that entry in the cache as the most recently used. Update the cache approximate LRU state so that item is identified as the most recently used (set/flip only the necessary bits for that entry and no others). Then report the current approximate recently used order, and repeat the loop.

Output
Your program's output should match this (do not echo user input, it is shown here, underlined, for completeness):

Initial state: 3
2 3 0 1
Entry accessed: 3
3 2 0 1 
Entry accessed: 0
0 1 3 2 
Entry accessed: 1
1 0 3 2 
Entry accessed: 4

-- program is finished running --
Note, initial state is 3, which is 011 in binary: first pair is LRU, so second pair prints first; second item in pair is LRU, so first item in each pair prints first.

Match the prompts and layout style (one space after each number) as shown above. Note, -- program is finished running -- is printed by Mars upon successful conclusion of the program.

Requirements
In addition to main, your code must have at least two procedures:

1 to update the LRU state, taking the current state and most recently used entry as an argument, and returning the new LRU state.

1 to print the approximate recently used order (the numbers 0-3 are printed in order based on the value of the current aLRU state), taking the current state as an argument.

For full credit your LRU state must be held in 3 bits when passed to/from procedures - these 3 bits would be directly in appropriate registers when passed to/returned from procedures. This can be pulled apart/constructed as needed to update or print state.

For full credit, your code should use appropriate bit operations (not arithmetic)

Only use macros (if you choose to use them) for small chunks of code such as the invocation of a syscall. It is fine to use pseudo instructions.

Procedure calling conventions must be followed.

Keep all of your code in a single file, do not separate procedures into separate files.

Follow code conventions, and use clear names for labels and procedures.

Hints
Remember to write pseudocode first, then MIPS. The pseudocode will help keep you on track.

Break development of your procedures down into several steps, for example:

write main first to read in values as specified
read in an initial value, exit if it is < 0 or > 7.
loop to read in cache entry numbers, exiting the loop and the program when the value is < 0 or > 3.
write the recently used order procedure next, taking the initial state and printing the order it specifies.
write the state update procedure and integrate it into the loop in main, to update the state and then print the order (using the printing procedure).
Remember to follow the procedure calling conventions:

procedures are invoked with jal; no other jumps should use jal; procedures exit with jr $ra; no other jumps should use jr $ra
each procedure should contain only one jr $ra statement; procedures should not share any code (if they do, they should be calling a common third procedure, applying proper procedure calling conventions).
callee is responsible for saving at the start and restoring at the end: $ra, $sp, $s# registers.
caller is responsible for saving $a#, $t#, $v# registers around any procedure calls (jal's) they make if they need the values after the procedure call.
main is the only code that is only a caller.
leaf procedures are the only code that are only callees.
anything in between or that calls itself is both a callee and a caller, and must abide by both sets of requirements.
none of your procedures (including main) can assume that any register starts out as 0; it must initialize any register it uses before adding, subtracting, or otherwise modifying the value in the array.
Bonus (+5%)
Write lru.s that implements true LRU tracking for 4 entries. All entries start out as the same age, and as entries are accessed they become the most recently used. (Hint: you may want an array of ages; it's fine to assume over/underflow will not occur.)

Your program should have a loop that has cache entry #s entered, exiting when a value < 0 or > 3 is entered; and when an entry # is entered, state is updated and the current recently used order is printed as it was with the approximate LRU program.

This should use good design, with two procedures similar to those for alru; and follow code conventions and the procedure calling conventions.

Include lru_record.txt that contains a sample run of your program; for the full 5%, all cache entries must have been accessed and the output final order must differ from what alru.s would display after the same order of accesses.

Discuss this effort in alru_debrief.txt alongside your discussion of alru.

Coding Style

Apply the Code Style Guide - be sure to have a program header comment
Use meaningful names for labels that give the reader a clue as to the purpose of the thing being named (loop/if/else targets, procedure entry points, data labels).
Use comments at the start of each procedure to describe the purpose of the procedure and the purpose of each parameter to the procedure and a description of its return value (if any).
Follow the Procedure Calling Conventions. Only allocate the stack space you need; see the Notes on Procedure Calls in MIPS
Use comments at the start of each block of code to explain what that part of the program does.
