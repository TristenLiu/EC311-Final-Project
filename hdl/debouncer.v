`timescale 1ns / 1ps

// EC-311 Lab-2 Part-1

module debouncer (
  input wire                    clk_i,                   // input clock
  input wire                    resetn_btn_i,            // input pushbutton for active LOW reset (Hint: On Nexys A7 board, the red push button gives 0 output when pressed) 
  input wire                    increment_counter_btn_i, // input push button for counter increment

  output reg                    btn_o
);
    reg output_exists = 0;          //if the output already exists, do not start another count
    integer deb_count = 0;        //count for x amount of clock cycles before incrementing btn_o
    reg start_count = 0;            //choose whether or not to start counting from combinational logic
    
    initial begin
        btn_o = 0;
    end
    
    always @(posedge clk_i or negedge resetn_btn_i) begin
        if(!resetn_btn_i) begin
            deb_count <= 0;
            output_exists <= 0;
            start_count <= 0;
            btn_o <= 0;
        end 
        else begin
            if(increment_counter_btn_i) begin
                if(!output_exists) begin                    //if the output doesnt exist, begin the count
                    if (!start_count) begin
                        start_count <= 1;
                        deb_count <= 0;
                    end else begin
                        deb_count <= deb_count + 1'b1;
                    end
                    if(deb_count == 100) begin
                        start_count <= 0;
                        deb_count <= 0;
                        output_exists <= 1;
                        btn_o <= 1;
                    end
                end else begin
                    btn_o <= 0;                                //if the output exists, reset btn_o so counter only counts it once
                end
            end else begin
                start_count <= 0;
                deb_count <= 0;
                btn_o <= 0;
                output_exists <= 0;
            end
        end
    end //always
        
endmodule