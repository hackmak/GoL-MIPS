# Conway's Game of Life in MIPS Assembly Language
__John Conway's classic Game of Life* recreated in MIPS assembly language. Utilizes MARS' built-in Bitmap.__


## Installation
To run this program, you will need to download MARS [here](http://courses.missouristate.edu/KenVollmar/MARS/download.htm). 
## How to Run the Game of Life
Once doing so:

1) __File -> New__ then copy/paste the code
2) Access the Bitmap through __Tools -> Bitmap Display__
3) Configure the Bitmap like so:

     __UNIT WIDTH:__ 8									

     __UNIT HEIGHT:__ 8								

     __DISPLAY WIDTH:__ 512							

     __DISPLAY HEIGHT:__ 512								

     __BASE ADDRESS:__ 0x10008000 ($gp)	

4) Click the __Connect to MIPS__ button on the bottom left of the Bitmap Display.
5) Press __F3__ to assemble then __F5__ to start running the program!

## How to Stop the Game of Life
If you are watching a pattern and get bored, simply hit the stop button (or __F11__). Don't forget to click the __reset__ button on the Bitmap Display!
## GoL_Original vs. GoL_Update
###### Original
This is the original program I had created as a final project for my Computer Architecture class (Fall '18). The final project was open-ended, the main requirement being a minimum of 500 lines of code. The main features of this program is that the user choose from 9 hard-coded initial patterns of various types (e.g. methuselahs, gliders, oscillators).
###### Update
This version includes the same 9 patterns as the original code but with added functionalities:

- allows the user to create his/her own patterns by entering pixel coordinates
- input validation for menu choices and pixel coordinates. Will not let user input duplicate coordinates.

What I'm working on currently (as of 12/24):
- letting the user choose what color pixel they'd like the game to proceed in
- creating the illusion of an infinite grid by letting patterns go past the borders of the grid, instead of sticking to the edge

__*Check the wiki for more information on the Game of Life and implementation details.__
