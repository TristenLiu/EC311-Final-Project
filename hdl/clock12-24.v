module clock12_24(input clk, rst, m_sw, edit_sw, bD, bL, bR, bC, output reg fmt, [3:0]hrL, [3:0]hrR, [3:0]mL, [3:0]mR, [3:0]sL, [3:0]sR, [3:0]milL, [3:0]milM, [3:0]milR);
	reg frmt_mode = 0;
	reg edit_mode = 0;
	reg [36:0] timeReg = 0;
	reg[1:0] currDigit = 0;
	
	always@(posedge clk) begin
		if(m_sw) fmt <= 1; else fmt <= 0;
		
		if(bD) timeReg <= 0;

		
		if(!edit_mode) begin //Tick mode
			if(timeReg[3:0] == 4b'1011) begin	//Check 3rd millisecond digit
				timeReg[3:0] <= 0;
				if(timeReg[7:4] == 4b'1011) begin	//Check 2nd millisecond digit
					timeReg[7:4] <= 0;
					if(timeReg[11:8] == 4b'1011) begin	//Check 1st millisecond digit
						timeReg[11:8] <= 0;
						if(timeReg[15:12] == 4b'1011) begin		//Check 2nd second digit
							timeReg[15:12] <= 0;
							if(timeReg[19:16] == 4b'0101) begin		//Check 1st second digit
								timeReg[19:16] <= 0;
								if(timeReg[23:20] == 4b'1011) begin		//Check 2nd minute digit
									timeReg[23:20] <= 0;
									if(timeReg[27:24] == 4b'0101)	//Check 1st minute digit
										timeReg[27:24] <= 0;
										case(timeReg[35:28]) begin		//Check hour digits
											8b'00010010: begin timeReg[35:28] <= 0; timeReg[36] <= !timeReg[36]; end	//Change hour counting format???
											8b'00001011: timeReg[35:28] <= 8b'00010000;
											default: timeReg[31:28] <= timeReg[31:28] + 4b'0001;
										endcase
									end
									else timeReg[27:24] <= timeReg[27:24] + 4b'0001;	//Incr 1st minute digit
								end
								else timeReg[23:20] <= timeReg[23:20] + 4b'0001;	//Incr 2nd minute digit
							end
							else timeReg[19:16] <= timeReg[19:16] + 4b'0001;	//Incr 1st second digit
						end
						else timeReg[15:12] <= timeReg[15:12] + 4b'0001;	//Incr 2nd second digit
					end
					else timeReg[11:8] <= timeReg[11:8] + 4b'0001;	//Incr 1st millisecond digit
				end
				else timeReg[7:4] <= timeReg[7:4] + 4b'0001;	//Incr 2nd millisecond digit
			end
			else timeReg[3:0] <= timeReg[3:0] + 4b'0001;	//Incr 3rd millisecond digit
			
			//Do formatting stuff
			
		end
		
		fmt <= frmt_mode;
	end
	
	always@(posedge clk) begin
		if(edit_mode) begin //Edit mode ( ; _ ;) Only gonna give control down to the minute.
			timeReg[19:0] <= 0;
			
			if(bL) currDigit <= currDigit - 2b'01;
			else if(bR) currDigit <= currDigit + 2b'01;
			else begin 
				case(currDigit) begin
					2b'00:	begin
						if(bC) begin
							if(timeReg[35:32] == 4'b0010) timeReg[35:32] <= 4'b0000;
							else timeReg[35:32] <= timeReg[35:32] + 4'b0001;
						end
						else if(bD) begin
							if(timeReg[35:32] == 4'b0000) timeReg[35:32] <= 4'b0010;
							else timeReg[35:32] <= timeReg[35:32] - 4'b0001;
						end
					end
					2b'01:	begin
						if(bC) begin
							if(timeReg[35:28] == 8b'00100100) timeReg[35:]//Digit h2 resets to 0 at 4 if h1 is 2.
						end
						else if(bD) begin
							
						end
					end
					2b'10:	begin
						
					end
					2b'11:	begin
						
					end
				endcase
			end
		end
	end
endmodule