`timescale 1ns / 1ps

module counter24(
    input clk_i,
    input resetn_i,
    
    output reg [35:0] count_o
    );
    
    initial begin
        count_o = 0;
    end
    
    always @(posedge clk_i or negedge resetn_i) begin
        if(!resetn_i) begin
            count_o <= 0;
        end else begin
        // The maximum for each 4bit segment is 9 = 1001. If 1001, then increment the next segment
            if (count_o[3:0] == 4'b1001) begin //ms1
                count_o[3:0] <= 4'b0000;
                if (count_o[7:4] == 4'b1001) begin //ms2
                    count_o[7:4] <= 4'b0000;
                    if (count_o[11:8] == 4'b1001) begin //ms3
                        count_o[11:8] <= 4'b0000;
                        if (count_o[15:12] == 4'b1001) begin //s1
                            count_o[15:12] <= 4'b0000;
                            if (count_o[19:16] == 4'b0101) begin //s2
                                count_o[19:16] <= 4'b0000;
                                if (count_o[23:20] == 4'b1001) begin //m1
                                    count_o[23:20] <= 0;
                                    if (count_o[27:24] == 4'b0101) begin //m2
                                        count_o[27:24] <= 0;
                                        if (count_o[35:32] == 4'b0010 && count_o[31:28] == 4'b0011) begin // if h2=2 and h1=3
                                            count_o[35:32] <= 0;
                                            count_o[31:28] <= 0;
                                        end
                                        else if (count_o[31:28] == 4'b1001) begin //h1
                                            count_o[35:32] <= count_o[35:32] + 1'b1;
                                            count_o[31:28] <= 0;
                                        end
                                    end else
                                        count_o[27:24] <= count_o[27:24] + 1'b1;
                                end else
                                    count_o[23:20] <= count_o[23:20] + 1'b1;
                            end else
                                count_o[19:16] <= count_o[19:16] + 1'b1;
                        end else
                            count_o[15:12] <= count_o[15:12] + 1'b1;
                    end else
                        count_o[11:8] <= count_o[11:8] + 1'b1;
                end else 
                    count_o[7:4] <= count_o[7:4] + 1'b1;
            end else
                count_o[3:0] <= count_o[3:0] + 1'b1;
        end
    end //always
endmodule