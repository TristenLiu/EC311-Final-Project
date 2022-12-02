`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2020 12:29:25 PM
// Design Name: 
// Module Name: top_square
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////
module top_square(
    input wire CLK,             // board clock: 100 MHz on Arty/Basys3/Nexys
    input wire RST_BTN,
    input wire [7:0] random_num,
    input wire [7:0] hit,         
    output wire VGA_HS_O,       // horizontal sync output
    output wire VGA_VS_O,       // vertical sync output
    output wire [3:0] VGA_R,    // 4-bit VGA red output
    output wire [3:0] VGA_G,    // 4-bit VGA green output
    output wire [3:0] VGA_B     // 4-bit VGA blue output
    );

    wire rst = ~RST_BTN;    // reset is active low on Arty & Nexys Video
    

    // generate a 25 MHz pixel strobe
    reg [15:0] cnt;
    reg pix_stb;
    always @(posedge CLK)
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000

    wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;  // current pixel y position:  9-bit value: 0-511

    vga640x480 display (
        .i_clk(CLK),
        .i_pix_stb(pix_stb),
        .i_rst(rst),
        .o_hs(VGA_HS_O), 
        .o_vs(VGA_VS_O), 
        .o_x(x), 
        .o_y(y)
    );

    // Wires to hold regions on FPGA
    wire SQ1,SQ2,SQ3,SQ4,SQ5,SQ6,SQ7,SQ8,SQ9,SQ10,SQ11,SQ12,SQ13,SQ14,SQ15,SQ16,SQ17,SQMid,SQ10hit,SQ11hit,SQ12hit,SQ13hit,SQ14hit,SQ15hit,SQ16hit,SQ17hit;
	
    //Registers for entities
	reg green,grid;
	
	// Creating Regions on the VGA Display represented as wires (640x480)
	
	// SQ1 is a large Square, and SQ2-9, along with SQ Mid are areas within SQ1
    assign SQ1 = ((x > 100) & (y > 60) & (x < 540) & (y < 420)) ? 1 : 0;
    assign SQ2 = ((x > 180) & (y > 60) & (x < 280) & (y < 420)) ? 1 : 0; 
    assign SQ3 = ((x > 360) & (y > 60) & (x < 460) & (y < 420)) ? 1 : 0; 
    assign SQ4 = ((x > 100) & (y > 279) & (x < 181) & (y < 341)) ? 1 : 0; // Red Square
    assign SQ5 = ((x > 100) & (y > 139) & (x < 181) & (y < 201)) ? 1 : 0; // Red Square
    assign SQ6 = ((x > 279) & (y > 279) & (x < 361) & (y < 341)) ? 1 : 0; // Red Square
    assign SQ7 = ((x > 279) & (y > 139) & (x < 361) & (y < 201)) ? 1 : 0; // Red Square
    assign SQ8 = ((x > 459) & (y > 279) & (x < 540) & (y < 341)) ? 1 : 0; // Red Square
    assign SQ9 = ((x > 459) & (y > 139) & (x < 540) & (y < 201)) ? 1 : 0; // Red Square
    assign SQMid = ((x > 279) & (y > 200) & (x < 361) & (y < 280)) ? 1 : 0; // Center Square
    
	// SQ10-17 are also areas within SQ1
    assign SQ10 = ((x > 100) & (y > 60) &  (x < 181) & (y < 140)) ? 1 : 0; // Green Square
    assign SQ11 = ((x > 100) & (y > 200) & (x < 181) & (y < 280)) ? 1 : 0; // Green Square
    assign SQ12 = ((x > 100) & (y > 340) & (x < 181) & (y < 420)) ? 1 : 0; // Green Square
    assign SQ13 = ((x > 279) & (y > 60 ) & (x < 361) & (y < 140)) ? 1 : 0; // Green Square
    assign SQ14 = ((x > 279) & (y > 340) & (x < 361) & (y < 420)) ? 1 : 0; // Green Square
    assign SQ15 = ((x > 459) & (y > 60 ) & (x < 540) & (y < 140)) ? 1 : 0; // Green Square
    assign SQ16 = ((x > 459) & (y > 200) & (x < 540) & (y < 280)) ? 1 : 0; // Green Square
    assign SQ17 = ((x > 459) & (y > 340) & (x < 540) & (y < 420)) ? 1 : 0; // Green Square
    // SQ10hit-17hit are the same areas as SQ10-17
    assign SQ10hit = ((x > 100) & (y > 60) &  (x < 181) & (y < 140)) ? 1 : 0; // Hit Square
    assign SQ11hit = ((x > 100) & (y > 200) & (x < 181) & (y < 280)) ? 1 : 0; // Hit Square
    assign SQ12hit = ((x > 100) & (y > 340) & (x < 181) & (y < 420)) ? 1 : 0; // Hit Square
    assign SQ13hit = ((x > 279) & (y > 60 ) & (x < 361) & (y < 140)) ? 1 : 0; // Hit Square
    assign SQ14hit = ((x > 279) & (y > 340) & (x < 361) & (y < 420)) ? 1 : 0; // Hit Square
    assign SQ15hit = ((x > 459) & (y > 60 ) & (x < 540) & (y < 140)) ? 1 : 0; // Hit Square
    assign SQ16hit = ((x > 459) & (y > 200) & (x < 540) & (y < 280)) ? 1 : 0; // Hit Square
    assign SQ17hit = ((x > 459) & (y > 340) & (x < 540) & (y < 420)) ? 1 : 0; // Hit Square



    
 // Assign the registers to the VGA 3rd output. This will display strong red on the Screen when 
 // grid = 1, and strong green on the screen when green = 1;
 assign VGA_R[3] = grid;
 assign VGA_G[3] = green;
  
  always @ (*)
  begin 
	//At start of every input change reset the screen and grid. Check inputs and update grid accordingly
	
	//Green = 0 means that there will be no values of x/y on the VGA that will display green
    green = 0;
	//This statement makes it so that within SQ1, a 3x3 grid of squares appears, with the middle square blacked out
    grid =  SQ1 - SQ2 - SQ3 - SQ4 - SQ5 - SQ6 - SQ7 - SQ8 - SQ9 - SQMid;
    
    if(random_num[0] == 1)
        begin
			//Add SQ10 to the areas which will display strong green.
			//Note: This displays yellow on the display, as red+green = yellow.
            green = green + SQ10; 
        end
    else if(random_num[0] == 0 && hit[0]==1)
        begin
			//Add SQ10 to the areas which will display strong green, and remove it from the area that displays 
			//strong red.
            green = green + SQ10;
            grid = grid - SQ10hit;
        end   
    if(random_num[1] == 1)
        begin
            green = green + SQ11;
        end
    else if(random_num[1] == 0 && hit[1]==1)
        begin
            green = green + SQ11;
            grid = grid - SQ11hit;
        end        
    if(random_num[2] == 1)
        begin
            green = green + SQ12;
        end
    else if(random_num[2] == 0 && hit[2]==1)
        begin
            green = green + SQ12;
            grid = grid - SQ12hit;
        end 
    if(random_num[3] == 1)
        begin
            green = green + SQ13;
        end
    else if(random_num[3] == 0 && hit[3]==1)
        begin
            green = green + SQ13;
            grid = grid - SQ13hit;
        end 
    if(random_num[4] == 1)
        begin
            green = green + SQ14;
        end
    else if(random_num[4] == 0 && hit[4]==1)
        begin
            green = green + SQ14;
            grid = grid - SQ14hit;
        end 
    if(random_num[5] == 1)
        begin
            green = green + SQ15;
        end
    else if(random_num[5] == 0 && hit[5]==1)
        begin
            green = green + SQ15;
            grid = grid - SQ15hit;
        end 
    if(random_num[6] == 1)
        begin
            green = green + SQ16;
        end
    else if(random_num[6] == 0 && hit[6]==1)
        begin
            green = green + SQ16;
            grid = grid - SQ16hit;
        end 
    if(random_num[7] == 1)
        begin
            green = green + SQ17;
        end
    else if(random_num[7] == 0 && hit[7]==1)
        begin
            green = green + SQ17;
            grid = grid - SQ17hit;
        end 
  end
    
    
endmodule
