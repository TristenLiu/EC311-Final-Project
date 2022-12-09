module timer(clk_i, resetn, start, stop, out_o,bL,bD);

    input clk_i, resetn, start, stop;
    output reg [35:0]out_o;
    reg edit_mode = 1;
    reg [36:0] timeReg = 0;

    initial begin
        out_o = 0;
        button_press = 0;
    end

    clock_divider msClk(clk_i, clk_1ms_out);
    debouncer_dff start_i(clk_i, resetn, start, start_o);
    debouncer_dff stop_i(clk_i, resetn, stop, stop_o);


    always @ (posedge clk_i) begin // check for which button is pressed
        if(start_o)
            button_press <= 1'b1;
        else if(stop_o)
            button_press <= 1'b0;
    end


    always @(posedge clk_i or negedge resetn) begin
        if(!edit_mode) begin
            if(bL && !edit_mode) edit_mode <= 1;
            else if(bD && !edit_mode) begin
                out_o <= 0;
                edit_mode <= 1;
            end
        if(!resetn) begin
            out_o <= 0;
        end else if(clk_1ms_out && button_press == 1'b1) begin
            // The maximum for each 4bit segment is 9 = 1001. If 1001, then increment the next segment
            if (out_o[3:0] == 4'b0000) begin //ms1
                out_o[3:0] <= 4'b0000;
                if (out_o[7:4] == 4'b0000) begin //ms2
                    out_o[7:4] <= 4'b0000;
                    if (out_o[11:8] == 4'b0000) begin //ms3
                        out_o[11:8] <= 4'b0000;
                        if (out_o[15:12] == 4'b0000) begin //s1
                            out_o[15:12] <= 4'b0000;
                            if (out_o[19:16] == 4'b0000) begin //s2
                                out_o[19:16] <= 4'b0000;
                                if (out_o[23:20] == 4'b0000) begin //m1
                                    out_o[23:20] <= 0;
                                    if (out_o[27:24] == 4'b0000) begin //m2
                                        out_o[27:24] <= 0;
                                        if (out_o[31:28] == 4'b0000) begin //h1
                                            out_o[31:28] <= 0;
                                            if(out_o[35:32] == 4'b0000) begin //h2
                                                out_o[35:32] <= 0;
                                            end else
                                                out_o[35:32] <= out_o[35:32] - 1'b1;
                                        end
                                    end else
                                        out_o[27:24] <= out_o[27:24] - 1'b1;
                                end else
                                    out_o[23:20] <= out_o[23:20] - 1'b1;
                            end else
                                out_o[19:16] <= out_o[19:16] - 1'b1;
                        end else
                            out_o[15:12] <= out_o[15:12] - 1'b1;
                    end else
                        out_o[11:8] <= out_o[11:8] - 1'b1;
                end else
                    out_o[7:4] <= out_o[7:4] - 1'b1;
            end else
                out_o[3:0] <= out_o[3:0] - 1'b1;
        end
    end //always


endmodule
