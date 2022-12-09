module timer(clk, bC, bL, bD, bR, out_o, curr_digit, edit, done);

    input clk, bC, bL, bD, bR;
    output reg [35:0]out_o;
    output reg [2:0]curr_digit;
    output reg edit, done;
    reg edit_mode;
    reg has_input;

    initial begin
        out_o <= 0;
        edit_mode <= 0;
        curr_digit <= 0;
        has_input <= 0;
    end
  
    always @(posedge clk_i) begin
        if(!edit_mode) begin
            if(bL) edit_mode <= 1;
            else if(bD) begin
                out_o <= 0;
                edit_mode <= 1;
            end
            
            else if(out_o == 0  && has_input) done <= 1;
            

            else begin
                // The maximum for each 4bit segment is 9 = 1001. If 1001, then increment the next segment
                if (out_o[3:0] == 4'b0000) begin //ms1
                    out_o[3:0] <= 4'b1001;
                    if (out_o[7:4] == 4'b0000) begin //ms2
                       out_o[7:4] <= 4'b1001;
                       if (out_o[11:8] == 4'b0000) begin //ms3
                           out_o[11:8] <= 4'b1001;
                           if (out_o[15:12] == 4'b0000) begin //s1
                               out_o[15:12] <= 4'b1001;
                               if (out_o[19:16] == 4'b0000) begin //s2
                                   out_o[19:16] <= 4'b0101;
                                    if (out_o[23:20] == 4'b0000) begin //m1
                                        out_o[23:20] <= 4'b1001;
                                        if (out_o[27:24] == 4'b0000) begin //m2
                                            out_o[27:24] <= 4'b0101;
                                            if (out_o[31:28] == 4'b0000) begin //h1
                                                out_o[31:28] <= 4'b1001;
                                                if(out_o[35:32] == 4'b0000) begin //h2
                                                    out_o[35:32] <= 4'b1001;
                                                end
                                                else out_o[35:32] <= out_o[35:32] - 1'b1;   //end h2
                                                end
                                            else out_o[31:28] <= out_o[31:28] - 1'b1;   //end h1
                                            end 
                                        else out_o[27:24] <= out_o[27:24] - 1'b1;   //end m2
                                        end
                                    else out_o[23:20] <= out_o[23:20] - 1'b1;   //end m1
                                    end
                                else out_o[19:16] <= out_o[19:16] - 1'b1;   //end s2
                                end
                            else out_o[15:12] <= out_o[15:12] - 1'b1;   //end s1
                            end
                        else out_o[11:8] <= out_o[11:8] - 1'b1; //end ms3
                        end
                    else out_o[7:4] <= out_o[7:4] - 1'b1;   //end ms2
                    end
                else out_o[3:0] <= out_o[3:0] - 1'b1;   //end ms1
                end //end else
            end //end if
            
        else if(edit_mode) begin //Edit mode ( ; _ ;) Only gonna give control down to the minute (down to the second for the timer!)
			out_o[11:0] <= 0;
			done <= 0;
			
			if(bL) begin 
				if(curr_digit == 0) begin curr_digit <= 0; edit_mode <= 0; end
				else curr_digit <= curr_digit - 3'b001;
			end
			else if(bR) begin
				if(curr_digit == 3'b101) begin curr_digit <= 0; edit_mode <= 0; end
				else curr_digit <= curr_digit + 3'b001;
			end
			else begin 
				case(curr_digit)
					3'b000:	begin   //HrR
						if(bC) begin
							if(out_o[35:32] == 4'b1001) out_o[35:32] <= 0;
							else out_o[35:32] <= out_o[35:32] + 4'b0001;
						end
						else if(bD) begin
							if(out_o[35:32] == 4'b0000) out_o[35:32] <= 4'b1001;
							else out_o[35:32] <= out_o[35:32] - 4'b0001;
						end
					end
					3'b001: begin   //HrR
					   if(bC) begin
					       if(out_o[31:28] == 4'b1001) out_o[31:28] <= 0;
					       else out_o[31:28] <= out_o[31:28] + 4'b0001;
					   end
					   else if(bD) begin
					       if(out_o[31:28] == 4'b1001) out_o[31:28] <= 0;
							else out_o[31:28] <= out_o[31:28] + 4'b0001;
					   end
					end
					3'b010:	begin	//MinL
						if(bC) begin
							if(out_o[27:24] == 4'b0101) out_o[27:24] <= 0;
							else out_o[27:24] <= out_o[27:24] + 4'b0001;
						end
						else if(bD) begin
							if(out_o[27:24] == 0) out_o[27:24] <= 4'b0101;
							else out_o[27:24] <= out_o[27:24] - 4'b0001;
						end
					end
					3'b011:	begin
						if(bC) begin
							if(out_o[23:20] == 4'b1001) out_o[23:20] <= 0;
							else out_o[23:20] <= out_o[23:20] + 4'b0001;
			 			end
	           			else if(bD) begin
						    if(out_o[23:20] == 0) out_o[23:20] <= 4'b1001;
						    else out_o[23:20] <= out_o[23:20] - 4'b0001;
				    	end
				    end
				    3'b100: begin
				        if(bC) begin
							if(out_o[19:16] == 4'b1001) out_o[19:16] <= 0;
							else out_o[19:16] <= out_o[19:16] + 4'b0001;
			 			end
	           			else if(bD) begin
						    if(out_o[19:16] == 0) out_o[19:16] <= 4'b1001;
						    else out_o[19:16] <= out_o[19:16] - 4'b0001;
				    	end
				    end
				    3'b101: begin
				        if(bC) begin
							if(out_o[15:12] == 4'b1001) out_o[15:12] <= 0;
							else out_o[15:12] <= out_o[15:12] + 4'b0001;
			 			end
	           			else if(bD) begin
						    if(out_o[15:12] == 0) out_o[15:12] <= 4'b1001;
						    else out_o[15:12] <= out_o[15:12] - 4'b0001;
				    	end
				    end
				endcase
			end
		end   //end edit block
		
		edit <= edit_mode;
		
        end //end always

endmodule
