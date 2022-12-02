`timescale 1ns / 1ps

module top(
    input clk_i,
    input reset_n,
    input hrclk_mode,
    input BTNC,
    input BTNU,
    input BTNL,
    input BTNR,
    input BTND,
    
    output wire [3:0] VGA_R,
    output wire [3:0] VGA_G,
    output wire [3:0] VGA_B,
    output wire VGA_HS,
    output wire VGA_VS
    );
    reg hrEdit, hrLeft, hrRight, hrInc, hrReset;
    reg tEdit, tLeft, tRight, tBTNC, tReset;        //tBTNC = start or increment, depending on toggle mode
    reg swStart, swReset;
    // 0 = hour clock, 1 = timer, 2 = stopwatch
    reg [2:0] mode;
    
    top_square ts(.CLK(clk_i), 
                  .RST_BTN(reset_n), 
                  .random_num(), 
                  .hit(),
                  .VGA_HS_O(VGA_HS), 
                  .VGA_VS_O(VGA_VS), 
                  .VGA_R(VGA_R), 
                  .VGA_G(VGA_G), 
                  .VGA_B(VGA_B));
    
    // start at hour clock mode
    initial begin
        mode = 2'b00;
        hrEdit = BTND;
        hrLeft = BTNL;
        hrRight = BTNR;
        hrInc = BTNC;
        hrReset = reset_n;
    end
    
    // BTNU is used to cycle between the modes, and choose which wires the input buttons will map to
    // Make sure any button presses in mode x does not effect the state of mode y or mode z
    always @(BTNU) begin
        case (mode)
            2'b00: begin
                mode = 2'b01;
                hrEdit = 0; hrLeft = 0; hrRight = 0; hrInc = 0; hrReset = 1;
                tBTNC = BTNC;
                tEdit = BTND;
                tLeft = BTNL;
                tRight = BTNR;
                tReset = reset_n;
            end
            2'b01: begin
                mode = 2'b10;
                tBTNC = 0; tEdit = 0; tLeft = 0; tRight = 0; tReset = 1;
                swStart = BTNC;
                swReset = reset_n;
            end
            2'b10: begin
                mode = 2'b00;
                swStart = 0; swReset = 1;
                hrEdit = BTND;
                hrLeft = BTNL;
                hrRight = BTNR;
                hrInc = BTNC;
                hrReset = reset_n;
            end
            default: //if mode is somehow not in those three options, reset to hour clock
                mode = 2'b00;
        endcase
    end //always
    
    
endmodule
