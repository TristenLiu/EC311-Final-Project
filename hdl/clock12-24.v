module clock12_24(input clk, rst, m_sw, edit_sw, bD, bL, bR, bC, output reg fmt, [1:0]hrL, [3:0]hrR, [2:0]mL, [3:0]mR, [2:0]sL, [3:0]sR, [3:0]milL, [3:0]milM, [3:0]milR);
	reg mode;
	reg [35:0] timeReg = 0;
	reg[1:0] currDigit = 0;
	
	always@(posedge clk) begin
		if(m_sw) fmt <= 1; else fmt <= 0;
		
		if(bD) timeReg <= 0;

		if(edit_sw) begin //Edit mode ( ; _ ;) Only gonna give control down to the minute.
			if(bL) currDigit <= currDigit - 2b'01;
			else if(bR) currDigit <= currDigit + 2b'01;
			else begin 
				case(currDigit) begin
					2b'00:	begin
						if(bU) begin
							if(timeReg[35:32] == 4'b0010) timeReg[35:32] <= 4'b0000;
							else timeReg[35:32] <= timeReg[35:32] + 4'b0001;
						end
						else if(bD) begin
							if(timeReg[35:32] == 4'b0000) timeReg[35:32] <= 4'b0010;
							else timeReg[35:32] <= timeReg[35:32] - 4'b0001;
						end
					end
					2b'01:	begin
						if(bU) begin
							//Digit h2 resets to 0 at 4 if h1 is 2.
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
		else begin //Tick mode
			
		end
	end
endmodule