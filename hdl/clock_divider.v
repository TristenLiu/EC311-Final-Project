`timescale 1ns / 1ps

module clock_divider(
    input clk,
    
    output reg div_clk
    );
    reg[27:0] counter = 28'd0;
    
    // 1kHz = 1ms period
    parameter kHz = 28'd1000000;       // 100 * 10^6 / 10^3
    
    always @(posedge clk) begin
        counter <= counter + 28'd1;
        
        if (counter >= kHz-1)
            counter <= 28'd0;
        div_clk <= (counter < kHz/2) ? 1'b1 : 1'b0;
    end
    
endmodule