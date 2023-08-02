CSCI 341 M2 Program 2B

At this point, you have binary, hexadecimal, logic instructions, math instructions, branch instructions, and most recently, procedures!! So it's time to write something fun. This is significantly bigger than the first program, as you now have a full set of tools with branching and procedures. However, if you follow the recommendations in the specification, you should find that you can create the solution from the proposed procedures. 

This assignment is going to make use of the MARS Tool Bitmap Display, which will let you draw an image by writing to memory. You will be drawing the Cafe Wall IllusionLinks to an external site.. Note that the basic square drawing can be done by modifying the provided rectangle code; this is permitted, as the code is being provided here.

Instructions
Read through the specification below.
Work through the specification in the order described; the steps build on each other. If you get stuck, submit it with your code developed up to the working step, and include anything beyond that in a separate file as noted below.
Design your program - resist the urge to code, consider how you want to approach the specification. Write ideas first, then C code, then assembly. Reach out to the TAs and me for clarification and support.
Code (and test, and code, and test...). Call your working code cafewall.s. If you did not complete, but have non-working code also, call that (non-working) file cafewallb.s. In that case, cafewall.s is your code for the step of the 6 steps below that you got working. You may end up with other files also, see the specifications below.
Produce a MARS Record named cafewall_record.txt of assembling your working code (once) and then running your code (once) with the inputs 20 (square size) and 5 (number of pairs). Note, your program must work for any valid inputs (positive numbers that do not result in drawing outside of the display).
Create a jpg or png file capturing the MARS Bitmap Display screen (and no other parts of the display) in a file named cafewall.jpg or cafewall.png (the file extension should match your file type). If you do not know how to take a screen shot or crop the image, please use a search engine to find instructions for your platform (Windows/Mac/Linux) or contact me or the TAs for assistance.
Write a Program Debrief named cafewall_debrief.txt. If you were unable to complete the program, be sure to describe what step your cafewall.s got to, and what the problems currently are with your cafewallb.s in your debrief (under what can be improved).
Combine your source(s), report, image, and debrief files into a zip, tar, or 7z file named CSCI341_P2B_YourName with an appropriate file extension (.zip, .tar, .7z) and YourName replaced by your public name on Canvas. For example, if I made a tar file, I would submit CSCI341_P2B_AmeliaRead.tar. If there is some other file format you would like to have available, contact me, your instructor, to request it.
Background
The MARS application has a collection of useful built-in tools. We will use the Bitmap Display tool so that you can draw an image. The tool works by connecting to your program and detecting when you write to the base of your program's data section. It reads each byte as a pixel on its screen, assuming the byte encodes the color in RGB. Each byte represents the color like so, taking the value as 0x00RRGGBB:

RR is the amount of red in the color, 0x00-0xFF (0-255 in decimal)
GG is the amount of green in the color, 0x00-0xFF (0-255 in decimal)
BB is the amount of blue in the color, 0x00-0xFF (0-255 in decimal)
0x00000000 is black, and 0x00FFFFFF is white. You can read more about color codes here: https://htmlcolorcodes.com/Links to an external site. . This style of encoding colors is common in many languages, notice the values are 6-digit hexadecimal - the leading 00 would be implied in a 32-bit value.

The coordinates in the Bitmap Display are that the upper left is (0,0) and the lower right is (512,256), when it has its default configuration (which is what we will use).

In order to use the Bitmap Display, you must open the tool from the Tool menu, and then click its "Connect to MIPS" button prior to running your program. Leave the settings on their defaults, unit width and height in pixels = 1, display width = 512, display height = 256, base address = 0x1001000 (static data).

Specification
Drawing on the Bitmap Display requires that the first item in your .data section be the frame buffer, and that it be the size of the bitmap display. The default/initial size of the display is 512 pixels wide by 256 pixels high, and each pixel is a word of data, so you need a frame of 524288 bytes (which, in hex, is 0x80000). The .space directive can be used to set aside this space in your .data section. It must be the first item in your .data. See rectangle.s Download rectangle.sas an example. Note this code has a lot of useful tips in it - I strongly recommend downloading it and seeing what it does before writing your own code. You can leverage code from this source file for your solution, as well as code we write in class.

Note that the upper left corner is (0,0) and x and y increase as you go across and down the screen, unlike the coordinate system you use in math class, but matching the one used for most display software such as Java's AWT and Swing frameworks.

When you have a given pixel, say, (102, 30), you have to compute its address in the frame buffer correctly. Similar to C arrays, you would compute the location by taking the column (X) and multiplying it by 4 to get the word address; and the row (Y) and multiplying it by the number of bytes in a row. Since our screen is 512 pixels wide, it is 512 * 4 bytes wide in the frame buffer. So you would take:

102 * 4 + 30 * 512 * 4

This shows that the offset of that pixel in the frame buffer is address 61848. You can see this in rectangle.s where it shifts the x coordinate left by 2 and the y coordinate left by 11.

This image has several levels of structure. Blue and white squares are used to form rows and rows are combined to form grids. The final output has the grid illusion.  These instructions have you work through from drawing a square, to drawing a pair, to drawing a row, to producing rows repeatedly, to producing rows with every other row offset.

(1) You should first write a procedure to draw a white square, given a location, size, and color. Draw this square with (10,10) as the upper left corner of the image, and make it 20 pixels wide and high. White is 0x00FFFFFF.

Drawing a square will require you develop loops, as you must set every pixel in the square to white. The parameters given to this procedure should specify the upper left corner and the size of the square, i.e. do not hard-code the location or size. There should only be a single size parameter.

The image drawn should look like this:

white square on black background (see image file m2p2bimage1.png)

(2) Next write a procedure to draw a blue square and a white square, side by side (a pair of squares). Modify your square-drawing procedure to take a fourth parameter for the color of the square, and use it first to draw the blue square and then to draw the white square positioned to the right of the blue square (the first column of the white square should be 1 pixel left of the last column of the blue square). White is 0x00FFFFFF, and blue is 0x000000FF.

The parameters given to this new procedure should specify the upper left corner and the size of the square. Both squares are the same size, and should not overlap or be separated. They have the same y coordinate as their upper coordinate, but the second one has an upper left corner of x + size as its coordinate.

The image drawn should look like this:

blue square and white square on black background (see image file m2p2bimage2.png)

(3) Next, expand your program to draw a row of squares; write a procedure that will draw a row of 5 pairs of squares, using your pair-drawing procedure, starting with an upper-left corner of (10,10) and with each square being 20 pixels wide and 20 pixels high. 

Your new procedure procedure that will draw a row of squares using the pair-drawing procedure written in the previous step. It takes as arguments the location of the upper left corner of the squares, the size of each square, and the number of  pairs of squares. Do not hard-code the number of pairs of squares, location, or square size. Each square is the same size.

Notice that we specify each row in terms of how many pairs of blue/white squares it has. Your procedure doesn’t have to be able to produce a row that has a different number of blue versus white squares. The squares are specified using a single size parameter because each should be a square. You should develop a single procedure that allows varying the position, the number of blue/white pairs, and the square size.

Note that each pair is just to the right of the previous pair, with no space between pairs and no overlapping of pairs.

The image drawn should look like this:

line of blue and white squares on black background (see image file m2p2bimage3.png)

(4) Fourth, expand your program so that it draws 10 rows. The rows should be the same as were described in (2), with the first row starting in (10,10) and each succeeding row's top being directly below the previous row's bottom.

This will be a new procedure that uses the previous one, repeatedly, to draw each row at the appropriate starting position. Note, this procedure will be modified to be a grid-drawing one in the next step.

This procedure should take as arguments: the upper-left coordinates to begin the rows, the number of pairs (both pairs of squares and pairs of rows, i.e. one value for both), and the size of a square in pixels.

Your output should look like this:

grid with stripes of blue and white lines (see image file m2p2bimage4.png)

(5) Fifth, modify the procedure developed in (4) so that each row is separated from the previous row by 2 pixels; that is, the lower edge of the previous row is separated from the upper edge of the next row by 2 pixels.

This reveals the black background underneath. This is referred to as the “mortar” that would appear between layers of brick if you were to build a wall with this pattern. The mortar is essential to the illusion. Your program should use 2 pixels of separation for the mortar. This will be hard-coded, i.e. do not make it a parameter/argument to your procedure.

Your output may look like this (see note after image):

blue/white squares in rows with black between rows (see image file m2p2bimage5.png)

The appearance of some black lines being thicker than others is an artifact of the Java 14 AWT engine; if you are on a Mac or using a different version of Java, your black lines may not match this exactly. You should, however, see black between each row.

(6) Sixth, draw the illusion: the illusion consists of pairs of rows; in each pair, the second row is offset a certain distance in the x direction relative to the first. If the offset is 0, the rows line up completely; if the offset is the same as the square size, this draws a checkerboard; if the offset is half the square size, the illusion is created: the rows appear to not be straight, even though they are. Note that each row, even within the pairs, should have the mortar of 2 between it.

Modify your grid-drawing procedure to draw the illusion; it should take as arguments: the upper-left coordinates, the number of pairs (both pairs of squares and pairs of rows, i.e. one value for both), and the size of a square in pixels. The mortar should appear between each row as it did in (4).

Use the fixed value of half the size of the square as the offset for every other row.

Your display should look like this:

cafe wall illusion (see image file m2p2bimage6.png)

Each row is exactly the same height along its entire length, despite the illusion that they grow and shrink across the image!

(7) Finally, rather than continue to use fixed sizes, your final program will request the size of the square in pixels from the user and the size of the grid (number of pairs of squares/rows) from the user, in that order, and produce the cafe wall image given those inputs. It will always start the display at (10,10). Choice to display prompts or not is up to you, but make sure you get the size of a square first and the size of the grid second.

Here is my output with the inputs 30 and 2:

input 30 and 2 displays larger, fewer squares (see image file m2p2bimage7.png)

Limitations
Do not use macros for more than a wrapper for a syscall, recursion, or floating points in your program. It is fine to use pseudo instructions.

Keep all of your code in a single file, do not separate procedures into separate files.

If you choose to, you can skip step 2 and just have the line-drawing procedure call the square-drawing procedure twice; there is no deduction for that.

Coding conventions must be followed - if a procedure uses $s0-$s7, it must save them; and if it needs to use $a0-$a3 after it calls a procedure, it must have saved them and then recover them. Only leaf procedures do not need to save $ra. Do not optimize away the saving of registers beyond looking at the registers the current procedure uses; make no assumptions as to what registers the caller or callee uses.

rectangle.s is being provided as an example to show how to convert pixels to addresses, and you can use a similar model in your own code; but note that your procedure must draw a square, not a rectangle - that is, it takes only one size parameter, not length and width. It is fine to use rectangle.s as a starting point in your code.

It's fine to assume the inputs will always work, that is, do not both testing if the drawing would go outside the display space. (Note, however, if it does, then you will be corrupting the address space of your program and things could get very weird; you may need to restart MARS if that happens.)

Hints
You will need to develop procedures to organize your code. I expect you will end up with procedures that help at each step:

draw a square
draw a pair of squares
draw a line of squares
draw a grid (refined 3 times; first, a straight grid; second, with a mortar; third, with an offset between rows)
prompt the user for an integer and return the integer
You can define additional procedures, to further organize your code (such as a procedure to draw a pair of lines); and you may decide not to have a procedure to draw a pair of squares.

Be careful to avoid having more than 4 arguments to any procedure - the passing of parameters gets very complex with more than four. With careful design, and following the specifications, you can avoid that.

Bonus +1
Expand cafewall.s to allow the user to specify the colors to use; this will require bumping up the parameters beyond 4, so you will have to handle that in your code. Have them simply type in the decimal value of the hexadecimal color (since there is no read hex in MIPS). i.e. 0x000000FF is 255, while 0x0000FF00 is 66280.

Bonus +2 (+1 for reading hex in, +1 for color display)
Develop a separate program called art.s that produces a gradient on the display given a starting color value and an ending color value. Gradients vary the color from one shade to another by making minor changes. Have the user input the colors in hex using the same RGB encoding.

Note, there is no read hex, so you will need to either accept decimal equivalents, or read in strings and convert them to their hexadecimal values (i.e. read in "00FF00FF" and convert it to 0x00FF00FF). It's fine to assume they will type in a fixed number of characters for each input hex value (8 or 6, as you prefer). 

Hint: consider how far apart the start and end colors are in their red, green, and blue values, and how you can move from the starting color to the ending color by stepping each of the three components toward their target values. Every pixel on the display should be set to a color by your code. It's up to you if the change is vertical, horizontal, corner to corner, or in some other manner - but document this in comments clearly in your code.

Submit art.s and discuss art.s in your cafewall debrief also, and include art.jpg/art.png showing the resulting image with a run from 0x00FF00FF to 0X0000FF00.

Coding Style
Apply the Code Style Guide - be sure to have a program header comment
Use meaningful names for labels that give the reader a clue as to the purpose of the thing being named (loop/if/else targets, procedure entry points, data labels).
Use comments at the start of each procedure to describe the purpose of the procedure and the purpose of each parameter to the procedure and a description of its return value (if any).
Only allocate the stack space you need; see the Notes on Procedure Calls in MIPS
Use comments at the start of each block of code to explain what that part of the program does.
