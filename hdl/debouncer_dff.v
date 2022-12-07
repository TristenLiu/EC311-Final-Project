`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2022 10:32:23 PM
// Design Name: 
// Module Name: debouncer_dff
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
//////////////////////////////////////////////////////////////////////////////////


module debouncer_dff(clk_in, resetn_in, button_in, button_out);
    input clk_in, resetn_in, button_in;
    output button_out;
    wire out_1, out_2, out_2_bar;
    
    dff dff0(button_in, clk_in, resetn_in, out_1);
    dff dff1(out_1, clk_in, resetn_in, out_2);
    assign out_2_bar = ~out_2;
    assign button_out = out_1 && out_2_bar;
 
endmodule
