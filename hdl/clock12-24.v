module clock12_24(clk, m_sw, bD, bL, bR, bC, fmt, ampm, edit, currDigit, outReg);
    input clk, m_sw, bD, bL, bR, bC;
    output reg fmt, ampm, edit;
	output reg [1:0] currDigit;
    output reg [35:0]outReg;
	reg edit_mode;
	reg [35:0] timeReg;	//For the AM/PM bit, AM = 0, PM = 1!!!
	
	initial begin
	   ampm <= 0;
	   edit_mode <= 0;
	   outReg <= 0;
	   timeReg <= 0;
	   currDigit <= 0;
	end
	
	always@(posedge clk) begin
		//Handle Button inputs (making sure they don't interfere with edit mode)
		if(m_sw) fmt <= 1; else fmt <= 0;	//1 is 12hr, 0 is 24hr
		
	if(!edit_mode) begin
			if(bL) begin edit_mode <= 1; end
			else if(bD) begin
				timeReg <= 0;
				edit_mode <= 1; 
			end
            
			else begin //Tick mode
				if(timeReg[3:0] == 4'b1001) begin	//Check 3rd millisecond digit
					timeReg[3:0] <= 0;
					if(timeReg[7:4] == 4'b1001) begin	//Check 2nd millisecond digit
						timeReg[7:4] <= 0;
						if(timeReg[11:8] == 4'b1001) begin	//Check 1st millisecond digit
							timeReg[11:8] <= 0;
							if(timeReg[15:12] == 4'b1001) begin		//Check 2nd second digit
								timeReg[15:12] <= 0;
								if(timeReg[19:16] == 4'b0101) begin		//Check 1st second digit
									timeReg[19:16] <= 0;
									if(timeReg[23:20] == 4'b1001) begin		//Check 2nd minute digit
										timeReg[23:20] <= 0;
										if(timeReg[27:24] == 4'b0101) begin		//Check 1st minute digit
											timeReg[27:24] <= 0;
											case(timeReg[35:28])	//Check hour digits
												8'b00100011: timeReg[35:28] <= 8'b00000000;	//Send 23 to 0
												8'b00001001: timeReg[35:28] <= 8'b00010000;	//Send 09 to 10
												8'b00011001: timeReg[35:28] <= 8'b00100000; //Send 19 to 20
												default: timeReg[31:28] <= timeReg[31:28] + 4'b0001;
											endcase
										end
										else timeReg[27:24] <= timeReg[27:24] + 4'b0001;	//Incr 1st minute digit
									end
									else timeReg[23:20] <= timeReg[23:20] + 4'b0001;	//Incr 2nd minute digit
								end
								else timeReg[19:16] <= timeReg[19:16] + 4'b0001;	//Incr 1st second digit
							end
							else timeReg[15:12] <= timeReg[15:12] + 4'b0001;	//Incr 2nd second digit
						end
						else timeReg[11:8] <= timeReg[11:8] + 4'b0001;	//Incr 1st millisecond digit
					end
					else timeReg[7:4] <= timeReg[7:4] + 4'b0001;	//Incr 2nd millisecond digit
				end
				else timeReg[3:0] <= timeReg[3:0] + 4'b0001;	//Incr 3rd millisecond digit
			end
		end
	else if(edit_mode) begin //Edit mode ( ; _ ;) Only gonna give control down to the minute (down to the second for the timer!)
			timeReg[19:0] <= 0;
			
			if(bL) begin 
				if(currDigit == 0) begin currDigit <= 0; edit_mode <= 0; end
				else currDigit <= currDigit - 2'b01;
			end
			else if(bR) begin
				if(currDigit == 2'b10) begin currDigit <= 0; edit_mode <= 0; end
				else currDigit <= currDigit + 2'b01;
			end
			else begin 
				case(currDigit)
					2'b00:	begin
						if(bC) begin
							if(timeReg[35:28] == 8'b00100011) timeReg[35:28] <= 0;
							else if(timeReg[35:28] == 8'b00011001) timeReg[35:28] <= 8'b00100000;
							else if(timeReg[35:28] == 8'b00001001) timeReg[35:28] <= 8'b00010000;
							else timeReg[35:28] <= timeReg[35:28] + 8'b00000001;
						end
						else if(bD) begin
							if(timeReg[35:28] == 0) timeReg[35:28] <= 8'b00100011;
							else if(timeReg[35:28] == 8'b00100000) timeReg[35:28] <= 8'b00011001;
							else if(timeReg[35:28] == 8'b00010000) timeReg[35:28] <= 8'b00001001;
							else timeReg[35:28] <= timeReg[35:28] - 8'b00000001;
						end
					end
					2'b01:	begin	//MinL
						if(bC) begin
							if(timeReg[27:24] == 4'b0101) timeReg[27:24] <= 0;
							else timeReg[27:24] <= timeReg[27:24] + 4'b0001;
						end
						else if(bD) begin
							if(timeReg[27:24] == 0) timeReg[27:24] <= 4'b0101;
							else timeReg[27:24] <= timeReg[27:24] - 4'b0001;
						end
					end
					2'b10:	begin
						if(bC) begin
							if(timeReg[23:20] == 4'b1001) timeReg[23:20] <= 0;
							else timeReg[23:20] <= timeReg[23:20] + 4'b0001;
			 			end
	           			else if(bD) begin
						    if(timeReg[23:20] == 0) timeReg[23:20] <= 4'b1001;
						    else timeReg[23:20] <= timeReg[23:20] - 4'b0001;
				    	end
				    end
				endcase
			end
		end
	end
	
	//Formatting logic
	always@(posedge clk) begin
		if(fmt) begin
			case(timeReg[35:28])
				8'b00000000: outReg[35:28] <= 8'b00010010;
				8'b00100000: outReg[35:28] <= 8'b00001000;
				8'b00100001: outReg[35:28] <= 8'b00001001;
				default: begin
					if(timeReg[35:28] > 8'b00010010) outReg[35:28] <= timeReg[35:28] - 8'b00010010;
					else outReg[35:28] <= timeReg[35:28];
				end
			endcase
		end
		else outReg[35:28] <= timeReg[35:28];
		if(timeReg[35:28] > 8'b00010001) ampm <= 1;
		else ampm <= 0;
		
		{edit, outReg[27:0]} <= {edit_mode, timeReg[27:0]};
	end
endmodule