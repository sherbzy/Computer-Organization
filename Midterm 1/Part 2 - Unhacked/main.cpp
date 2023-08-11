/*
 * Group: Motyga
 * Names: Lucas King, Lauren Sherburne, Thomas Jensen
 * C++ code for MARS program given.  This code replicates a function that checks to see if a number is even or odd
 * even numbers will receive a 0 and odd numbers receive a 1
 * There is a special case where inputs 0 and 1 both return 0
*/
#include <iostream>
#include <fstream>

using namespace std;

//If the user input is negative then this function is called and
//prompts new user for integer.
void leaf2(int &x){
    cout << "Try Again <<00<< " << endl;
    cout << "Enter an integer: ";
    cin >> x;
}

// Does the innnerloop code from mars.
//Since register t5 is a boolean used for the comparison (t3 < t4)
bool isEven(int user){
    int y = user;
    while (!(y < 2)){
        y = y - 2;
    }
    if (y == 0){
        //returning true will take care of the (beq $t3, $zero, exit2)
        //in the exitRL code
        return true;
    }
    else{
        //will fail the (beq $t3, $zero, exit2) of exitRL
        //so register t0 will increment
        return false;
    }

}

//Covers loop and exitRL of MARS, it calls boolean function that
//replicates the innerloop of MARS
int leaf(int x){
    int v0, t0, t1, a0;
    v0 = 0;
    t0 = 2;
    a0 = x;
    t1 = (x / 2) + 1;
    //Base case at end of leaf on MARS before loop
    if ((x == 0) || (x == 1)){
        return 0;
    }
    //This is the exit2 portion of MARS, where 0 was stored in V0
    //then A0 was assigned the value of V0 then printed
    if (isEven(x) == true){
        return 0;
    }
    //This is the (slt $t2, $t0, $t1) portion of the code in MARS
    //where we have an odd number so in exitRL it never goes to
    //exit2.  So t0 will increment everytime interation of loop to innerloop to exitRL
    while (t0 < t1){
        if (isEven(a0) == false){
            t0 ++;
        }
    }
    //Will only return 1 if t0 >= t1
    //No need to worry about returning 0 because innerloop and exit RL
    //already took care of that
    return 1;

}

int main() {
    //Prints .asciiz PROMPT
    int x;
    cout << "Enter an integer: ";
    cin >> x;

    //The reason this is here is to replicate that all the loop
    //innerloop, exitRL, exit1 and exit2 are run before we check
    //to see if the input is negative.  In MARS they do this by
    //trying to lead us on a goose chase with t8 and shifting
    //our input integer right by 31 bits so the only bit left is
    //The sign bit
    int answer = leaf(x);

    //If integer is negative then promp user for another input until
    //input is greater than 0
    while (x < 0){
        leaf2(x);
        answer = leaf(x);
    }
    //Once input is correct format do the loop and rest of program
    cout << endl << answer << endl;
    return 0;
}
