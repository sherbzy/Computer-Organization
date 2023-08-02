CSCI 341 M2 Program 2A

Instructions
Read through the specification below.
Design your program - resist the urge to code, consider how you want to approach the specification. If you feel anything needs clarification, contact me (your instructor) before starting to code, or post your question on Piazza (no code!).
Code (and test, and code, and test...). Call your file pullapart.s
Produce a MARS Record named pullapart_record.txt of assembling your code (once) and then running your code with the following inputs (each input is one run, press Reset MIPS (F12) after each run, paste the windows once all runs are complete):
37
-109234500
169254
-1
Write a Program Debrief named pullapart_debrief.txt
Combine your three files into a zip, tar, or 7z file named CSCI341_P2A_YourName with an appropriate file extension (.zip, .tar, .7z) and YourName replaced by your public name on Canvas. For example, if I made a 7z file, I would submit CSCI341_P2A_AmeliaRead.7z. If there is some other file format you would like to have available, contact me, your instructor, to request it.
Specification
Develop a MIPS program named pullapart.s that reads in an integer value, then prints out the exact values (as integers) of:

1. the sign bit (0 or 1)

2. the individual bytes, left to right (MSB to LSB)

For full credit, the values above must only be determined using the logical operations provided in Section 2.3 in the zyBook (Figure 2.3.1/COD 2.8). "move" can be used if/as needed, along with the setup and execution of system calls.

Clarifications: "System calls" refers to syscall; and by setup, I mean you are permitted to use, as needed, lw, la, and li to set up prior to the syscall so it does what you need it to do. You can have a .data section for the strings you are requested to display. Do not use branches or procedures, we have not yet covered those in class. This does mean your code may feel repetitive.

These are sample runs (your output should match those shown here, with the same input; user input is underlined):

Enter an integer: 42
Sign bit is: 0
Bytes are: 0 0 0 42

Enter an integer: -100
Sign bit is: 1
Bytes are: 255 255 255 156
Note that the requested output runs may not be enough to show your code is completely meeting the specification. Consider the bit patterns of a variety of integers and what the resulting values should be, then test your code with those values to see if you get the output you expect.

 

Bonus Challenges
Not all assignments will have additional challenges; and they are not worth many points. But if you are interested to explore the program further, these are presented as possibilities. If you would like to propose a different challenge, do so by contacting me (your instructor) prior to the due date to ensure you will not lose points for not matching the specification provided.

If you do or attempt a challenge, discuss that work in your debrief also.

+1

Add a third item to the display of pullapart: output the integer negation of the original value. Use any operations you would like to do this. For example, our sample output from above would now produce:

Enter an integer: 42
Sign bit is: 0
Bytes are: 0 0 0 42
Negated it is: -42

Enter an integer: -100
Sign bit is: 1
Bytes are: 255 255 255 156
Negated it is: 100
+2

Write a similar program named pullapartfloat.s to pull a user-input float value apart and display its sign, mantissa, and exponent (as stored in the binary value, not denormalized or further altered). You will have to do some digging through Appendix A's operation list to figure out how to apply logical operations to the float (logical operations can't be applied to the float registers directly). Create and turn in pullapartfloat_record.txt if you perform this challenge, with some suitably chosen floating point values. Describe how you chose them in your debrief.
