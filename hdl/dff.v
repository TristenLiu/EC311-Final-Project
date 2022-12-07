`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2022 09:43:56 PM
// Design Name: 
// Module Name: dff
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

//Verilog code for data-type flip-flop with negative edge reset
module dff(d_in, clk_in, resetn_in, q_out);
    input d_in, clk_in, resetn_in;
    output reg q_out;
    
    always @ (posedge clk_in or negedge resetn_in) begin
    if(!resetn_in)
        q_out <= 1'b0;
    else
        q_out <= d_in;
    end // always
endmodule
