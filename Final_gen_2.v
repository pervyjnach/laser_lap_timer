 //==============Interface \/==================================================================
  
 module Final_gen_2 

( 
input master_clk,
input laser_detector,
//input key_1, // pin 135
//input key_2, // pin 141

output reg [6:0] segments,
output reg [5:0] cathode
); 

reg vcc;
reg [6:0] one;
reg [6:0] two;
reg [6:0] tre;


wire enable;
wire lap_rs;
wire five_seconds_rs;
wire [6:0] milliseconds;
wire [6:0] seconds;
wire [6:0] minutes;


assign vcc = 1;
wire w_reset;

// input clk, in, rs, output out


d_trig start_trigger (.clk(laser_detector),
					  .in(vcc),
					  .out(enable));
					  

					
timer lap_timer(.en(enable),
				.clock(master_clk),
				.rs(w_reset),
				.five_seconds(five_seconds_rs),
				.milliseconds(milliseconds),
				.seconds(seconds),
				.minutes(minutes));
				

five_sec_trig fst (.clk(master_clk),
				   .rs(w_reset),
				   .laser(laser_detector),
				   .reset(w_reset),
				   .seconds(seconds),
				   .minutes(minutes));
				
				
LED time_led   (.digit_1(minutes),
				.digit_2(seconds),
				.digit_3(milliseconds),
				.led_clk_in(master_clk),
				.led_segments(segments),
				.led_cathode(cathode));

/*LED result_led (.digit_1()
				.digit_2(),
				.digit_3(),
				.led_clk_in(),
				.led_segments(),
				.led_led_cathode());		*/		



endmodule 

//====================TIMER=======================


module timer 
#(parameter CLK_CNT_SIZE = 500000,
  parameter CLK_CNT_BIT = 25,
  parameter CLK_MIL = 99)

   (
 input en,
 input rs,
 input clock,
 input key_1,
 input key_2,
 output five_seconds,
 output reg [6:0] milliseconds,
 output reg [6:0] seconds,
 output reg [6:0] minutes
   );
   
wire w_millseconds;
wire w_seconds;
wire w_minutes;

wire clk;

assign clk = clock & en;


time_counter #(.VALUE_SIZE(CLK_CNT_SIZE),
			   .VALUE_BIT(CLK_CNT_BIT))
			   
			   clk_counter(.clk(clk),
						  .rs(rs),
						  .out_clk(w_milliseconds));
  
time_counter # (.VALUE_SIZE(CLK_MIL)) 
			milliseconds_counter (.clk(w_milliseconds),
								   .rs(rs),
								   .value(milliseconds),
								   .out_clk(w_seconds));
								   
time_counter seconds_counter (.clk(w_seconds),
							  .rs(rs),
							  .value(seconds),
							  .out_clk(w_minutes));
						
time_counter minutes_counter (.clk(w_minutes),
							  .rs(rs),
							  .value(minutes));		
							  
					  					  

endmodule 


 
   
module time_counter
# (parameter VALUE_SIZE = 59,
   parameter VALUE_BIT = 6)

(
input clk, rs,
output reg [VALUE_BIT:0] value,
output reg out_clk
);

always@ (posedge clk or posedge rs)
	begin
	
		if (rs)
			value = 0;
			
		else
			if (value == VALUE_SIZE)
				begin	
					value = 0;
					out_clk = 1;
				end
			
			else
				begin
					value = value + 1;
					out_clk = 0;
			end
	end
	
	

   
endmodule







//===============COMMON MODULES==========================

module five_sec_trig (
input clk,
input rs,
input laser,
input [6:0] minutes,
input [6:0] seconds,
output reg reset
);

initial begin
	reset <= 0;
end


always@ (posedge clk)
	begin
		if ((laser == 0 && seconds > 4 && minutes == 0 && rs == 0)
		  | (laser == 0 && minutes != 0 && rs == 0))	
			reset <= 1;
		else if (rs)
			reset <= 0;
			
	end

	
endmodule 




module fl_fl 
   (
   input [3:0] data,
   input clk,
   output reg [3:0] out
   );
   
   always@ (posedge clk)
   
   out <= data;
   
   endmodule                






module counter 
#( parameter N)
(input clk,
output reg [N:0] counter_out);

reg rs;

always@ (posedge clk)
	if (rs == 1)
		counter_out = 0;
	else 
		counter_out = counter_out + 1;
endmodule




module up_down_counter
   (
   input clk,
   input rev,
   input res,
   output reg [6:0] count);
   
   
   always@ (posedge clk or posedge res)
      if (res)
         count <= 0;
      else 
         if(rev)
            count <= count - 1;
         else  
            count <= count + 1;  
 endmodule  




module keys
#(parameter CLK_KEY_INSIDE )
(input key_in, clk,
output key_out);
wire clock;
reg key_out_0;
delitel #(.DEL(CLK_KEY_INSIDE)) del_key (.clk(clk), .del_clk(clk));
d_trig d_trig_key (.clk(clk), .in(key_in), .out(key_out_0));

assign key_out = ~key_out_0;
endmodule




module delitel
#(parameter DEL)
(
input clk,
output del_clk
);
reg [24:0] d_c;
assign del_clk = d_c[DEL];

always @(posedge clk)
begin
d_c <= d_c + 1;
end

endmodule




module d_trig
(input clk, in, rs,
output out
);

initial begin
	out <= 0;
end

always@ (negedge clk or posedge rs)
	begin
		if (rs == 1'b1)
			out <= 0;
		else
			out <= in;
			
	end 
endmodule





                //===============COMMON MODULES========================== 

//=======Led_7_Seg_Display============
 
module LED
#(parameter DEL_LED = 5)
( 
input wire [6:0] digit_1,
input wire [6:0] digit_2,
input wire [6:0] digit_3,
input wire led_clk_in,
output reg [6:0] led_segments,
output reg [5:0] led_cathode
);  


wire [3:0] bidec_1 [1:0];
wire [3:0] bidec_2 [1:0];
wire [3:0] bidec_3 [1:0];

wire [3:0] bidec_1_1 = bidec_1[1];
wire [3:0] bidec_1_2 = bidec_1[0];
wire [3:0] bidec_2_1 = bidec_2[1];
wire [3:0] bidec_2_2 = bidec_2[0];
wire [3:0] bidec_3_1 = bidec_3[1];
wire [3:0] bidec_3_2 = bidec_3[0];



wire [6:0] digit_1_wire;
wire [6:0] digit_2_wire;
wire [6:0] digit_3_wire;
wire [6:0] digit_4_wire;
wire [6:0] digit_5_wire;
wire [6:0] digit_6_wire;
wire [2:0] cnt_out;
wire [6:0] d_1;
wire [6:0] d_2;
wire [6:0] d_3;


delitel #(.DEL(DEL_LED)) delitel_led (.clk(led_clk_in), .del_clk(led_clk)); 


bidec my_bidec_1 ( .vhod(digit_1), .bidec_clk(led_clk), .vyhod_1(bidec_1) );
bidec my_bidec_2 ( .vhod(digit_2), .bidec_clk(led_clk), .vyhod_1(bidec_2) );
bidec my_bidec_3 ( .vhod(digit_3), .bidec_clk(led_clk), .vyhod_1(bidec_3) );

bidec_to_7 bd7_1_1 ( .bi_in(bidec_1_1), .segments(digit_1_wire));
bidec_to_7 bd7_1_2 ( .bi_in(bidec_1_2), .segments(digit_2_wire));
bidec_to_7 bd7_2_1 ( .bi_in(bidec_2_1), .segments(digit_3_wire));
bidec_to_7 bd7_2_2 ( .bi_in(bidec_2_2), .segments(digit_4_wire));
bidec_to_7 bd7_3_1 ( .bi_in(bidec_3_1), .segments(digit_5_wire));
bidec_to_7 bd7_3_2 ( .bi_in(bidec_3_2), .segments(digit_6_wire));

counter_6 counter ( .cnt_clk(led_clk), .count(cnt_out));



segm_out segm_out_1 ( .segm_digit_1(digit_1_wire), .segm_digit_2(digit_2_wire),  
                      .segm_digit_3(digit_3_wire), .segm_digit_4(digit_4_wire),
                      .segm_digit_5(digit_5_wire), .segm_digit_6(digit_6_wire),
                      .segm_clk(cnt_out),  
                      .segm_out(led_segments), .cathode(led_cathode)                   
                      );


endmodule

module segm_out 
(

input wire [2:0] segm_clk,
input wire [6:0] segm_digit_1,
input wire [6:0] segm_digit_2,
input wire [6:0] segm_digit_3,
input wire [6:0] segm_digit_4,
input wire [6:0] segm_digit_5,
input wire [6:0] segm_digit_6,

output reg [6:0] segm_out,
output reg [5:0] cathode
); 

always @*
begin

case (segm_clk)

3'd000: segm_out = segm_digit_1;
3'd001: segm_out = segm_digit_2;
3'd010: segm_out = segm_digit_3;
3'd011: segm_out = segm_digit_4;
3'd100: segm_out = segm_digit_5;
3'd101: segm_out = segm_digit_6;
endcase 

case (segm_clk)
3'd000: cathode = 6'b111110;
3'd001: cathode = 6'b111101;
3'd010: cathode = 6'b111011;
3'd011: cathode = 6'b110111;
3'd100: cathode = 6'b101111;
3'd101: cathode = 6'b011111;


endcase


end
endmodule

module counter_6 
(
input wire cnt_clk,
output reg [2:0] count
 );
 

always @(posedge cnt_clk)

if (count <= 4) begin count = count+1; end
else begin count = 0; end
  

endmodule

module bidec //  binary to bi-dec code

(input wire [6:0] vhod,
input bidec_clk,
output reg [3:0] vyhod_1 [1:0]
);

 always @(posedge bidec_clk)
 
begin

if  (vhod>=0 && vhod<=9) 
       begin 
          vyhod_1[1] = 0;      vyhod_1[0] <= vhod[3:0];
end
     
else if  (vhod>=10 && vhod<=19)
   begin 
     vyhod_1[1] <= 1;     vyhod_1[0] <= vhod[3:0] - 10;
end 

else if  (vhod>=20 && vhod<=29)
   begin 
     vyhod_1[1] <= 2;     vyhod_1[0] <= vhod[3:0] - 20;
end 

else if  (vhod>=30 && vhod<=39)
   begin 
     vyhod_1[1] <= 3;     vyhod_1[0] <= vhod[3:0] - 30;
end 


else if  (vhod>=40 && vhod<=49)
   begin 
     vyhod_1[1] <= 4;     vyhod_1[0] <= vhod[3:0] - 40;
end 


else if  (vhod>=50 && vhod<=59)
   begin 
     vyhod_1[1] <= 5;     vyhod_1[0] <= vhod[3:0] - 50;
end 


else if  (vhod>=60 && vhod<=69)
   begin 
     vyhod_1[1] <= 6;     vyhod_1[0] <= vhod[3:0] - 60;
end 


else if  (vhod>=70 && vhod<=79)
   begin 
     vyhod_1[1] <= 7;     vyhod_1[0] <= vhod[3:0] - 70;
end 


else if  (vhod>=80 && vhod<=89)
   begin 
     vyhod_1[1] <= 8;     vyhod_1[0] <= vhod[3:0] - 80;
end 


else if  (vhod>=90 && vhod<=99)
   begin 
     vyhod_1[1] <= 9;     vyhod_1[0] <= vhod[3:0] - 90;
end 

end
endmodule 

module bidec_to_7
(   // bi-dec code to 7 segments
 input wire [3:0] bi_in,
 output reg [6:0] segments);

always @*
    begin 
      
 case (bi_in)

   4'd0:  segments = 7'b0111111;
   4'd1:  segments = 7'b0000110;
   4'd2:  segments = 7'b1011011;
   4'd3:  segments = 7'b1001111;
   4'd4:  segments = 7'b1100110;
   4'd5:  segments = 7'b1101101;
   4'd6:  segments = 7'b1111101;
   4'd7:  segments = 7'b0000111;
   4'd8:  segments = 7'b1111111;
   4'd9:  segments = 7'b1101111;

endcase
end
endmodule


//=======Led_7_Seg_Display============
 //==============Interface /\==================================================================

 
