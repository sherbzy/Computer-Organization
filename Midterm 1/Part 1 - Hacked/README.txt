Midterm 1 Part 1 - Hacked

You will be working in groups of 3, as a team, on this. Your team should spend 2-4 hours on Part 1. It is due at 11:59 pm Mountain Time this evening.

Note, late work is not accepted. Submit early if you are concerned, and re-submit up until the due time (Monday, 11:59 pm). Canvas will add -# markers to the file name, that is fine (-1 on the second submission, -2 on the third, and so on).

This Midterm measures your internalization of MIPS and its hardware interface: computer arithmetic, architected binary interface, instruction set architecture. There is a lot of room in this for creativity and for scaling back; your Part 1 submission needs to run, so if you are running short of time, focus on making your code runnable.

tl;dr
Your group makes 1 submission, so be clear about who is submitting
Part 1 - create confusing MIPS and clear C++; submit C++, MIPS, and debrief here, due Monday at 11:59 pm.
Your Part 2 will be provided to you by noon on Tuesday, in an announcement on your group's Canvas page.
Part 1
Note: Make reasonable assumptions where necessary and clearly state them.

You get to "be the hacker" for this first part of the midterm. Hackers work to develop code that is hard to untangle, so that others cannot determine what it is doing or how to defuse it.

Create a small basic C++ (i.e., no objects) program with 1-3 procedures in it. The functions can do anything (reasonable), examples are: compute body-mass index, convert Kelvin to Fahrenheit, reverse a string. The main program should make one or more calls to the procedure(s), and have additional control flow in it as well (a loop, an if test, whatever you would like). The procedures can be nested, recursive, or all leaf procedures.

There can be input and output in your program (you can interact with the user), and the input values can cause different behaviors.

Your overall program does not have to be as complex as a bubble sort. Please try not to be more complex than a bubble sort.

Comment your C++ code appropriately to explain it (your peers won't see it).

Once you've decided on a target, now you get to "be the compiler" and produce MIPS code for this. Your goal is to 'stump' your peers, as they are going to try to decompile your MIPS into working C++ code. They won't have your C++ code to guide them. Review the notes on MIPS procedure calls to remind yourself how to set up and use your procedure(s).

Don't go overboard building a huge program, but you also don't have to make the MIPS statement-for-statement identical to your C++. It should produce the same general control flow and the same return values and results, but should pose some difficulty for the other team to turn back into C++.

You can use any MIPS instruction covered in the zyBook (i.e. floating point operations are permitted as well as basic integer instructions), and you can use any basic pre-object C++ construct (i.e. arrays, pointers, union/struct [consider that the compiler has to deconstruct those into assembler]). It's fine to compile your C++ to x86 or ARM assembler to get some ideas on how to write your MIPS. Your MIPS code must run in the MARS simulator.

The MIPS code should have no comments, but must be runnable in MARS. It is fine to name targets appropriate to their generic actions (loop, end, skip), but avoid using C keywords like "for" and "else", and name your function "fun" rather than give away its function by naming it something obvious like "factorial" or "average". Our style guide and conventions can be ignored, to further confuse your peers with bad layout/naming and convention "violations".

What to Submit
One team member submits your C++ and MIPS code here, along with a Debrief on this part of the assignment. Be sure to state your assumptions in your debrief, and describe what approach the team took to make the code hard to decompile. Name your MIPS file hack.s. Put the three files in a .zip/.tar/.7z file named CSCI341_Mid1_GroupName where GroupName is the name your team has, and submit that file here.

This cannot be submitted late. Submit early if you are concerned, and resubmit up until the deadline.
