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
    input wire [35:0] random_num,
    input wire [9:0] hit,         
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
    wire fullscreen;
    wire [8:0] leftdigit_blank;
    wire [7:0] leftdigit_ss;
    wire [12:0] h2, h1, m2, m1, s2, s1, ms3, ms2, ms1;
    wire [1:0] c2, c1;
	
    //Registers for entities
	reg green,grid;
	reg [10:0] sum;
	
	// Creating Regions on the VGA Display represented as wires (640x480)
	
	// SQ1 is a large Square, and SQ2-9, along with SQ Mid are areas within SQ1
    assign fullscreen = ((x > 52 ) & (x < 573) & (y > 179) & (y < 264)) ? 1 : 0;
    assign h2[0] = ((x > 52) & (x < 111) & (y > 179) & (y < 194)) ? 1 : 0;
    assign h2[1] = ((x > 95) & (x < 111) & (y > 179) & (y < 229)) ? 1 : 0;
    assign h2[2] = ((x > 95) & (x < 111) & (y > 214) & (y < 262)) ? 1 : 0;
    assign h2[3] = ((x > 52) & (x < 111) & (y > 249) & (y < 264)) ? 1 : 0;
    assign h2[4] = ((x > 52) & (x < 69) & (y > 214) & (y < 262)) ? 1 : 0;
    assign h2[5] = ((x > 52) & (x < 69) & (y > 179) & (y < 229)) ? 1 : 0;
    assign h2[6] = ((x > 52) & (x < 111) & (y > 214) & (y < 229)) ? 1 : 0;
    
    assign h1[0] = ((x > 69 + 52) & (x < 69 + 111) & (y > 179) & (y < 194)) ? 1 : 0;
    assign h1[1] = ((x > 69 + 95) & (x < 69 + 111) & (y > 179) & (y < 229)) ? 1 : 0;
    assign h1[2] = ((x > 69 + 95) & (x < 69 + 111) & (y > 214) & (y < 262)) ? 1 : 0;
    assign h1[3] = ((x > 69 + 52) & (x < 69 + 111) & (y > 249) & (y < 264)) ? 1 : 0;
    assign h1[4] = ((x > 69 + 52) & (x < 69 + 69) & (y > 214) & (y < 262)) ? 1 : 0;
    assign h1[5] = ((x > 69 + 52) & (x < 69 + 69) & (y > 179) & (y < 229)) ? 1 : 0;
    assign h1[6] = ((x > 69 + 52) & (x < 69 + 111) & (y > 214) & (y < 229)) ? 1 : 0;
    
    assign m2[0] = ((x > 166 + 52) & (x < 166 + 111) & (y > 179) & (y < 194)) ? 1 : 0;
    assign m2[1] = ((x > 166 + 95) & (x < 166 + 111) & (y > 179) & (y < 229)) ? 1 : 0;
    assign m2[2] = ((x > 166 + 95) & (x < 166 + 111) & (y > 214) & (y < 262)) ? 1 : 0;
    assign m2[3] = ((x > 166 + 52) & (x < 166 + 111) & (y > 249) & (y < 264)) ? 1 : 0;
    assign m2[4] = ((x > 166 + 52) & (x < 166 + 69) & (y > 214) & (y < 262)) ? 1 : 0;
    assign m2[5] = ((x > 166 + 52) & (x < 166 + 69) & (y > 179) & (y < 229)) ? 1 : 0;
    assign m2[6] = ((x > 166 + 52) & (x < 166 + 111) & (y > 214) & (y < 229)) ? 1 : 0;
    
    assign m1[0] = ((x > 235 + 52) & (x < 235 + 111) & (y > 179) & (y < 194)) ? 1 : 0;
    assign m1[1] = ((x > 235 + 95) & (x < 235 + 111) & (y > 179) & (y < 229)) ? 1 : 0;
    assign m1[2] = ((x > 235 + 95) & (x < 235 + 111) & (y > 214) & (y < 262)) ? 1 : 0;
    assign m1[3] = ((x > 235 + 52) & (x < 235 + 111) & (y > 249) & (y < 264)) ? 1 : 0;
    assign m1[4] = ((x > 235 + 52) & (x < 235 + 69) & (y > 214) & (y < 262)) ? 1 : 0;
    assign m1[5] = ((x > 235 + 52) & (x < 235 + 69) & (y > 179) & (y < 229)) ? 1 : 0;
    assign m1[6] = ((x > 235 + 52) & (x < 235 + 111) & (y > 214) & (y < 229)) ? 1 : 0;
    
    assign s2[0] = ((x > 332 + 52) & (x < 332 + 111) & (y > 179) & (y < 194)) ? 1 : 0;
    assign s2[1] = ((x > 332 + 95) & (x < 332 + 111) & (y > 179) & (y < 229)) ? 1 : 0;
    assign s2[2] = ((x > 332 + 95) & (x < 332 + 111) & (y > 214) & (y < 262)) ? 1 : 0;
    assign s2[3] = ((x > 332 + 52) & (x < 332 + 111) & (y > 249) & (y < 264)) ? 1 : 0;
    assign s2[4] = ((x > 332 + 52) & (x < 332 + 69) & (y > 214) & (y < 262)) ? 1 : 0;
    assign s2[5] = ((x > 332 + 52) & (x < 332 + 69) & (y > 179) & (y < 229)) ? 1 : 0;
    assign s2[6] = ((x > 332 + 52) & (x < 332 + 111) & (y > 214) & (y < 229)) ? 1 : 0;
    
    assign s1[0] = ((x > 401 + 52) & (x < 401 + 111) & (y > 179) & (y < 194)) ? 1 : 0;
    assign s1[1] = ((x > 401 + 95) & (x < 401 + 111) & (y > 179) & (y < 229)) ? 1 : 0;
    assign s1[2] = ((x > 401 + 95) & (x < 401 + 111) & (y > 214) & (y < 262)) ? 1 : 0;
    assign s1[3] = ((x > 401 + 52) & (x < 401 + 111) & (y > 249) & (y < 264)) ? 1 : 0;
    assign s1[4] = ((x > 401 + 52) & (x < 401 + 69) & (y > 214) & (y < 262)) ? 1 : 0;
    assign s1[5] = ((x > 401 + 52) & (x < 401 + 69) & (y > 179) & (y < 229)) ? 1 : 0;
    assign s1[6] = ((x > 401 + 52) & (x < 401 + 111) & (y > 214) & (y < 229)) ? 1 : 0;
    
    assign c2[0] = ((x > 190) & (x < 207) & (y > 209) & (y < 225)) ? 1 : 0;
    assign c2[1] = ((x > 190) & (x < 207) & (y > 247) & (y < 264)) ? 1 : 0;
    
    assign c1[0] = ((x > 166 + 190) & (x < 166 + 207) & (y > 209) & (y < 225)) ? 1 : 0;
    assign c1[1] = ((x > 166 + 190) & (x < 166 + 207) & (y > 247) & (y < 264)) ? 1 : 0;
    
//    assign leftdigit_blank[0] = ((x > 40 ) & (y > 100) & (x < 60 ) & (y < 120)) ? 1 : 0; 
//    assign leftdigit_blank[1] = ((x > 40 ) & (y > 180) & (x < 60 ) & (y < 200)) ? 1 : 0; 
//    assign leftdigit_blank[2] = ((x > 40 ) & (y > 260) & (x < 60 ) & (y < 280)) ? 1 : 0; // Red Square
//    assign leftdigit_blank[3] = ((x > 60 ) & (y > 120) & (x < 120) & (y < 180)) ? 1 : 0; // Red Square
//    assign leftdigit_blank[4] = ((x > 60 ) & (y > 200) & (x < 120) & (y < 260)) ? 1 : 0; // Red Square
//    assign leftdigit_blank[5] = ((x > 120) & (y > 100) & (x < 140) & (y < 120)) ? 1 : 0; // Red Square
//    assign leftdigit_blank[6] = ((x > 120) & (y > 180) & (x < 140) & (y < 200)) ? 1 : 0; // Red Square
//    assign leftdigit_blank[7] = ((x > 120) & (y > 260) & (x < 140) & (y < 280)) ? 1 : 0; // Red Square
//    assign SQMid = ((x > 140) & (y > 100) & (x < 600) & (y < 280)) ? 1 : 0; // Center Square
    
//	// SQ10-17 are also areas within SQ1
//    assign leftdigit_ss[0] = ((x > 60 ) & (y > 100) & (x < 120) & (y < 120)) ? 1 : 0; // Green Square              
//    assign leftdigit_ss[1] = ((x > 120) & (y > 120) & (x < 140) & (y < 180)) ? 1 : 0; // Green Square
//    assign leftdigit_ss[2] = ((x > 120) & (y > 200) & (x < 140) & (y < 260)) ? 1 : 0; // Green Square
//    assign leftdigit_ss[3] = ((x > 60 ) & (y > 260) & (x < 120) & (y < 280)) ? 1 : 0; // Green Square
//    assign leftdigit_ss[4] = ((x > 40 ) & (y > 200) & (x < 60 ) & (y < 260)) ? 1 : 0; // Green Square
//    assign leftdigit_ss[5] = ((x > 40 ) & (y > 120) & (x < 60 ) & (y < 180)) ? 1 : 0; // Green Square
//    assign leftdigit_ss[6] = ((x > 60 ) & (y > 180) & (x < 120) & (y < 200)) ? 1 : 0; // Green Square
//    assign SQ17 = ((x > 459) & (y > 340) & (x < 540) & (y < 420)) ? 1 : 0; // Green Square
//    // SQ10hit-17hit are the same areas as SQ10-17
// assign SQ10hit = ((x > 60 ) & (y > 100) & (x < 120) & (y < 120)) ? 1 : 0; // Hit Square
// assign SQ11hit = ((x > 120) & (y > 120) & (x < 140) & (y < 180)) ? 1 : 0; // Hit Square
// assign SQ12hit = ((x > 120) & (y > 200) & (x < 140) & (y < 260)) ? 1 : 0; // Hit Square
// assign SQ13hit = ((x > 60 ) & (y > 260) & (x < 120) & (y < 280)) ? 1 : 0; // Hit Square
// assign SQ14hit = ((x > 40 ) & (y > 200) & (x < 60 ) & (y < 260)) ? 1 : 0; // Hit Square
// assign SQ15hit = ((x > 40 ) & (y > 120) & (x < 60 ) & (y < 180)) ? 1 : 0; // Hit Square
// assign SQ16hit = ((x > 60 ) & (y > 180) & (x < 120) & (y < 200)) ? 1 : 0; // Hit Square
// assign SQ17hit = ((x > 459) & (y > 340) & (x < 540) & (y < 420)) ? 1 : 0; // Hit Square



    
 // Assign the registers to the VGA 3rd output. This will display strong red on the Screen when 
 // grid = 1, and strong green on the screen when green = 1;
 assign VGA_R[3] = grid;
 assign VGA_G[3] = green;
  
  always @ (*)
  begin 
	//At start of every input change reset the screen and grid. Check inputs and update grid accordingly
	
	//Green = 0 means that there will be no values of x/y on the VGA that will display green
    green = 0;
    sum = 0;
	//This statement makes it so that within SQ1, a 3x3 grid of squares appears, with the middle square blacked out
    grid = 0;
    //fullscreen - leftdigit_blank[0] - leftdigit_blank[1] - leftdigit_blank[2]
    //             - leftdigit_blank[3] - leftdigit_blank[4] - leftdigit_blank[5] - leftdigit_blank[6] - leftdigit_blank[7] - SQMid;
    case(random_num[3:0])
        4'b0000: sum = sum + s1[0] + s1[1] + s1[2] + s1[3] + s1[4] + s1[5];
        4'b0001: sum = sum + s1[1] + s1[2];
        4'b0010: sum = sum + s1[0] + s1[1] + s1[3] + s1[4] + s1[6];
        4'b0011: sum = sum + s1[0] + s1[1] + s1[2] + s1[3] + s1[6];
        4'b0100: sum = sum + s1[1] + s1[2] + s1[5] + s1[6];
        4'b0101: sum = sum + s1[0] + s1[2] + s1[3] + s1[5] + s1[6];
        4'b0110: sum = sum + s1[0] + s1[2] + s1[3] + s1[4] + s1[5] + s1[6];
        4'b0111: sum = sum + s1[0] + s1[1] + s1[2];
        4'b1000: sum = sum + s1[0] + s1[1] + s1[2] + s1[3] + s1[4] + s1[5] + s1[6];
        4'b1001: sum = sum + s1[0] + s1[1] + s1[2] + s1[5] + s1[6];
    endcase
    case(random_num[7:4])
        4'b0000: sum = sum + s2[0] + s2[1] + s2[2] + s2[3] + s2[4] + s2[5];
        4'b0001: sum = sum + s2[1] + s2[2];
        4'b0010: sum = sum + s2[0] + s2[1] + s2[3] + s2[4] + s2[6];
        4'b0011: sum = sum + s2[0] + s2[1] + s2[2] + s2[3] + s2[6];
        4'b0100: sum = sum + s2[1] + s2[2] + s2[5] + s2[6];
        4'b0101: sum = sum + s2[0] + s2[2] + s2[3] + s2[5] + s2[6];
        4'b0110: sum = sum + s2[0] + s2[2] + s2[3] + s2[4] + s2[5] + s2[6];
    endcase
    case(random_num[11:8])
        4'b0000: sum = sum + m1[0] + m1[1] + m1[2] + m1[3] + m1[4] + m1[5];
        4'b0001: sum = sum + m1[1] + m1[2];
        4'b0010: sum = sum + m1[0] + m1[1] + m1[3] + m1[4] + m1[6];
        4'b0011: sum = sum + m1[0] + m1[1] + m1[2] + m1[3] + m1[6];
        4'b0100: sum = sum + m1[1] + m1[2] + m1[5] + m1[6];
        4'b0101: sum = sum + m1[0] + m1[2] + m1[3] + m1[5] + m1[6];
        4'b0110: sum = sum + m1[0] + m1[2] + m1[3] + m1[4] + m1[5] + m1[6];
        4'b0111: sum = sum + m1[0] + m1[1] + m1[2];
        4'b1000: sum = sum + m1[0] + m1[1] + m1[2] + m1[3] + m1[4] + m1[5] + m1[6];
        4'b1001: sum = sum + m1[0] + m1[1] + m1[2] + m1[5] + m1[6];
    endcase
    case(random_num[15:12])
        4'b0000: sum = sum + m2[0] + m2[1] + m2[2] + m2[3] + m2[4] + m2[5];
        4'b0001: sum = sum + m2[1] + m2[2];
        4'b0010: sum = sum + m2[0] + m2[1] + m2[3] + m2[4] + m2[6];
        4'b0011: sum = sum + m2[0] + m2[1] + m2[2] + m2[3] + m2[6];
        4'b0100: sum = sum + m2[1] + m2[2] + m2[5] + m2[6];
        4'b0101: sum = sum + m2[0] + m2[2] + m2[3] + m2[5] + m2[6];
        4'b0110: sum = sum + m2[0] + m2[2] + m2[3] + m2[4] + m2[5] + m2[6];
    endcase
    case(random_num[19:16])
        4'b0000: sum = sum + h1[0] + h1[1] + h1[2] + h1[3] + h1[4] + h1[5];
        4'b0001: sum = sum + h1[1] + h1[2];
        4'b0010: sum = sum + h1[0] + h1[1] + h1[3] + h1[4] + h1[6];
        4'b0011: sum = sum + h1[0] + h1[1] + h1[2] + h1[3] + h1[6];
        4'b0100: sum = sum + h1[1] + h1[2] + h1[5] + h1[6];
        4'b0101: sum = sum + h1[0] + h1[2] + h1[3] + h1[5] + h1[6];
        4'b0110: sum = sum + h1[0] + h1[2] + h1[3] + h1[4] + h1[5] + h1[6];
        4'b0111: sum = sum + h1[0] + h1[1] + h1[2];
        4'b1000: sum = sum + h1[0] + h1[1] + h1[2] + h1[3] + h1[4] + h1[5] + h1[6];
        4'b1001: sum = sum + h1[0] + h1[1] + h1[2] + h1[5] + h1[6];
    endcase
    case(random_num[23:20])
        4'b0000: sum = sum + h2[0] + h2[1] + h2[2] + h2[3] + h2[4] + h2[5];
        4'b0001: sum = sum + h2[1] + h2[2];
    endcase
    
    // always display the colons
    sum = sum + c2[1] + c2[0] + c1[1] + c1[0];
    
    if (sum > 0) green = 1;
  end
    
    
endmodule