# Conway's Game of Life in MIPS Assembly Language
__John Conway's classic Game of Life* recreated in MIPS assembly language. Utilizes MARS' built-in Bitmap.__

*Check the wiki for more information on the Game of Life and implementation details.

###### Installation
To run this program, you will need to download MARS here: http://courses.missouristate.edu/KenVollmar/MARS/download.htm. 
###### How to Run the Game of Life
Once doing so:

1)
2) Access the Bitmap through Tools -> Bitmap Display
3) Configure the Bitmap like so:
UNIT WIDTH: 8									
UNIT HEIGHT: 8								
DISPLAY WIDTH: 512							
DISPLAY HEIGHT: 512								
BASE ADDRESS: 0x10008000 ($gp)	
4)
Original - this is the original program I had created for the final project for my Computer Architecture class (Fall '18). The final project was open-ended, the requirement being that you needed a minimum of 500 lines of code. The main features of the original program is that the users can see the rules of the Game of Life unfolding in 9 hard-coded initial patterns.
