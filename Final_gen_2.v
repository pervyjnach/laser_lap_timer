 //==============Interface \/==================================================================
  
 module Final_gen_2 

( 
input master_clk,
input laser_detector,
//input key_1, // pin 135
//input key_2, // pin 141

output reg [9:0] output_data,
output reg output_enable
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
wire [6:0] m;
wire [6:0] s;
wire [6:0] mll;
wire [6:0] minutes_2;
wire [6:0] seconds_2;
wire [6:0] milliseconds_2;


assign vcc = 1;
wire w_reset;

// input clk, in, rs, output out


lcd_top l_t(.clk(master_clk),
			.min_1(minutes),
			.sec_1(seconds),
			.milsec_1(milliseconds),
			.min_2(minutes_2),
			.sec_2(seconds_2),
			.milsec_2(milliseconds_2),
			.data(output_data),
			.enable(output_enable));

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
				
				
/*LED time_led   (.digit_1(m),
				.digit_2(s),
				.digit_3(mll),
				.led_clk_in(master_clk),
				.led_segments(segments),
				.led_cathode(cathode));
	*/			
time_trig ttr (.clk(w_reset),
			   .minutes(minutes),
			   .seconds(seconds),
			   .milliseconds(milliseconds), 
			   .out_minutes(minutes_2),
			   .out_seconds(seconds_2),
			   .out_milliseconds(milliseconds_2));
/*			  
time_mux tmx (.clk(master_clk),
			  .min_1(minutes),
			  .sec_1(seconds),
			  .mill_1(milliseconds),
			  .min_2(minutes_2),
			  .sec_2(seconds_2),
			  .mill_2(milliseconds_2),
			  .min_out(m),
			  .sec_out(s),
			  .mill_out(mll));							
*/
/*LED result_led (.digit_1()
				.digit_2(),
				.digit_3(),
				.led_clk_in(),
				.led_segments(),
				.led_led_cathode());		*/		



endmodule 

//=============LCD=================
module lcd_top(
 input clk,
 input [6:0] min_1,
 input [6:0] sec_1,
 input [6:0] milsec_1,
 input [6:0] min_2,
 input [6:0] sec_2,
 input [6:0] milsec_2,
 output [9:0] data,
 output enable 
 );
 
 wire [3:0] min_1_w;
 wire [3:0] sec_1_w;
 wire [3:0] milsec_1_w;
 wire [3:0] min_2_w;
 wire [3:0] sec_2_w;
 wire [3:0] milsec_2_w;
 
 wire [3:0] min_1_d;
 wire [3:0] sec_1_d;
 wire [3:0] milsec_1_d;
 wire [3:0] min_2_d;
 wire [3:0] sec_2_d;
 wire [3:0] milsec_2_d;
 
 
 wire [3:0] bidec_1 [1:0];
 wire [3:0] bidec_2 [1:0];
 wire [3:0] bidec_3 [1:0];
 wire [3:0] bidec_4 [1:0];
 wire [3:0] bidec_5 [1:0];
 wire [3:0] bidec_6 [1:0];

 wire [3:0] bidec_1_1 = bidec_1[1];
 wire [3:0] bidec_1_2 = bidec_1[0];
 wire [3:0] bidec_2_1 = bidec_2[1];
 wire [3:0] bidec_2_2 = bidec_2[0];
 wire [3:0] bidec_3_1 = bidec_3[1];
 wire [3:0] bidec_3_2 = bidec_3[0];
 
 wire [3:0] bidec_4_1 = bidec_4[1];
 wire [3:0] bidec_4_2 = bidec_4[0];
 wire [3:0] bidec_5_1 = bidec_5[1];
 wire [3:0] bidec_5_2 = bidec_5[0];
 wire [3:0] bidec_6_1 = bidec_6[1];
 wire [3:0] bidec_6_2 = bidec_6[0];
 
 wire [9:0] data_wire [34];
 
 
 wire [9:0] m_11;
 wire [9:0] m_12;
 wire [9:0] s_11;
 wire [9:0] s_12;
 wire [9:0] ms_11;
 wire [9:0] ms_12;
 
 wire [9:0] m_21 ;
 wire [9:0] m_22 ;
 wire [9:0] s_21;
 wire [9:0] s_22;
 wire [9:0] ms_21;
 wire [9:0] ms_22;
 
 wire [9:0] set_1 = 10'b0010000000;
 wire [9:0] set_2 = 10'b0011000000;
 wire [9:0] set_3 = 10'b0011000100;
 wire [9:0] T = 10'b1001010100;
 wire [9:0] i= 10'b1001101001;
 wire [9:0] m = 10'b1001101101;
 wire [9:0] e = 10'b1001100101;
 wire [9:0] double_point = 10'b1000111010;
 wire [9:0] L = 10'b1001001100;
 wire [9:0] a = 10'b1001100001;
 wire [9:0] p = 10'b1001110000;
 
 assign data_wire[0] = set_1;
 assign data_wire[1] = T;
 assign data_wire[2] = i;
 assign data_wire[3] = m;
 assign data_wire[4] = e;
 assign data_wire[5] = double_point;
 
 assign data_wire[6] = m_11;
 assign data_wire[7] = m_12;
 assign data_wire[8] = double_point;
 assign data_wire[9] = s_11;
 assign data_wire[10] = s_12;
 assign data_wire[11] = double_point;
 assign data_wire[12] = ms_11;
 assign data_wire[13] = ms_12;
 
 assign data_wire[14] = set_2;
 assign data_wire[15] = L;
 assign data_wire[16] = a;
 assign data_wire[17] = p;
 assign data_wire[18] = set_3;
 assign data_wire[19] = double_point;
 assign data_wire[20] = m_21;
 assign data_wire[21] = m_22;
 assign data_wire[22] = double_point;
 assign data_wire[23] = s_21;
 assign data_wire[24] = s_22;
 assign data_wire[25] = double_point;
 assign data_wire[26] = ms_21;
 assign data_wire[27] = ms_22;
 
 
 
 lcd mylcd(.master_clk(clk),
		   .data(data),
		   .input_data(data_wire),
		   .enable(enable));
		   
 bidec bdc1(.bidec_clk(clk),
			.vhod(min_1),
			.vyhod_1(bidec_1)			
			);
			
 bidec bdc2(.bidec_clk(clk),
			.vhod(sec_1),
			.vyhod_1(bidec_2)			
			);	
			
 bidec bdc3(.bidec_clk(clk),
			.vhod(milsec_1),
			.vyhod_1(bidec_3)			
			);					
			
 bidec bdc4(.bidec_clk(clk),
			.vhod(min_2),
			.vyhod_1(bidec_4)			
			);

 bidec bdc5(.bidec_clk(clk),
			.vhod(sec_2),
			.vyhod_1(bidec_5)			
			);	

 bidec bdc6(.bidec_clk(clk),
			.vhod(milsec_2),
			.vyhod_1(bidec_6)			
			);										
			
						
			
bidec_to_lcd btl1(.bi_in(bidec_1_1),
				.data(m_11)									  
				);
					
bidec_to_lcd btl2(.bi_in(bidec_1_2),	
				.data(m_12)				  				
				);	
				
				
				
bidec_to_lcd btl3(.bi_in(bidec_2_1),
				  .data(s_11)		
				);
					
bidec_to_lcd btl4(.bi_in(bidec_2_2),
				  .data(s_12)					
				);	
			
			
			
bidec_to_lcd btl5(.bi_in(bidec_3_1),
				  .data(ms_11)					
				);
					
bidec_to_lcd btl6(.bi_in(bidec_3_2),
				  .data(ms_12)					
				);												
//==================================================================

bidec_to_lcd bt21(.bi_in(bidec_4_1),
				.data(m_21)									  
				);
					
bidec_to_lcd bt22(.bi_in(bidec_4_2),	
				.data(m_22)				  				
				);	
				
				
				
bidec_to_lcd bt23(.bi_in(bidec_5_1),
				  .data(s_21)		
				);
					
bidec_to_lcd bt24(.bi_in(bidec_5_2),
				  .data(s_22)					
				);	
			
			
			
bidec_to_lcd bt25(.bi_in(bidec_6_1),
				  .data(ms_21)					
				);
					
bidec_to_lcd bt26(.bi_in(bidec_6_2),
				  .data(ms_22)					
				);	

						
 
 endmodule




module bidec_to_lcd
(   // bi-dec code to 7 segments
 input wire [3:0] bi_in,
 output reg [9:0] data);

always @*
    begin 
      
 case (bi_in)

   4'd0:  data = 10'b1000110000;
   4'd1:  data = 10'b1000110001;
   4'd2:  data = 10'b1000110010;
   4'd3:  data = 10'b1000110011;
   4'd4:  data = 10'b1000110100;
   4'd5:  data = 10'b1000110101;
   4'd6:  data = 10'b1000110110;
   4'd7:  data = 10'b1000110111;
   4'd8:  data = 10'b1000111000;
   4'd9:  data = 10'b1000111001;

endcase
end
endmodule


module lcd(
input master_clk,
input [9:0] input_data [34],

output [9:0] data,
output enable,
output enable_control,
output ready_out);


reg [9:0] in_data[34];

wire enable_wire;
wire ready;
wire [9:0] data_wire;
wire [9:0] data_init;
wire [9:0] data_write;
wire write_out_enable;
wire init_out_enable;

assign enable_wire = write_out_enable | init_out_enable;
assign enable = enable_wire;
assign enable_control = enable_wire;
assign data = data_wire;
assign data_wire = data_init | data_write;
assign ready_out = ~ready;
assign in_data = input_data;


initial begin
	in_data[0] = 10'b0010000000;// set cursor on 0x0
	
	in_data[1] = 10'b1001100001; 
	in_data[2] = 10'b1001100011; 
	in_data[3] = 10'b1000010000; 
	in_data[4] = 10'b1000010000; 
	
	in_data[5] = 10'b1000010000; 
	in_data[6] = 10'b1000010000;
	in_data[7] = 10'b1000010000;
	in_data[8] = 10'b1000010000;
	
	in_data[9] = 10'b1000010000;
	in_data[10] = 10'b1000010000;
	in_data[11] = 10'b1000010000;
	in_data[12] = 10'b1000010000;
	
	in_data[13] = 10'b1000010000;
	in_data[14] = 10'b1000010000;
	in_data[15] = 10'b1000010000;
	in_data[16] = 10'b1000010000;
	
	in_data[17] = 10'b0011000000; // set cursor on 0x1
	
	in_data[18] = 10'b1000010000;
	in_data[19] = 10'b1000010000;
	in_data[20] = 10'b1000010000;
	in_data[21] = 10'b1000010000;
	
	in_data[22] = 10'b1000010000;
	in_data[23] = 10'b1000010000;
	in_data[24] = 10'b1000010000;
	in_data[25] = 10'b1000010000;
	
	in_data[26] = 10'b1000010000;
	in_data[27] = 10'b1000010000;
	in_data[28] = 10'b1000010000;
	in_data[29] = 10'b1000010000;
	
	in_data[30] = 10'b1000010000;
	in_data[31] = 10'b1000010000;
	in_data[32] = 10'b1000010000;
	in_data[33] = 10'b1000010000;
	
	
end 

init initializator (.clk(master_clk), .data(data_init), .enable(init_out_enable), .ready(ready));
write wrt(.clk(master_clk), .in_data(in_data), .ready(ready), .data(data_write), .enable(write_out_enable));


endmodule


module write
#(parameter N = 14)
(
input ready,
input clk,
input [9:0] in_data[34],
output enable,
output reg [9:0] data
);

reg [9:0] data_in [34];
reg [6:0] inner_counter;
reg [N:0] inner_delitel;

assign data_in = in_data;
assign enable = inner_delitel[N];

always@ (posedge clk)
	if (ready)
		inner_delitel = inner_delitel + 1;
	else
		inner_delitel = 0;
		
always@ (posedge inner_delitel[N])
	if (ready)
	begin
		if (inner_counter == 34)
			inner_counter <= 0;
		else
			inner_counter = inner_counter + 1;
	end
	else 
		inner_counter = 0;
	
always@ (posedge inner_delitel[N])
	begin
	
		if (inner_counter >=0 | inner_counter <= 33)
			data = data_in[inner_counter];
	
		else
	
			data = 0;
			
			
	end	


endmodule


module init
	#(parameter N = 14)
	(
	input clk,
	output reg [9:0] data,
	output [3:0]counter_2_out,
	output enable,
	output reg ready
		   );
		   
reg [N:0] counter_1;
reg [3:0]  counter_2;
reg en;

assign counter_2_out = ~counter_2;
assign enable = counter_1[N] && ~ready;

initial begin en = 1;
ready = 0; end

always@ (posedge clk && en == 1)
	counter_1 = counter_1 + 1;
	

always@ (posedge counter_1[N])
	begin
		counter_2 = counter_2 + 1;
		if (counter_2 == 6)
			begin 
				en <= 0;
				counter_2 <= 0;
				ready <= 1; 
				
			end
	end

always@ (posedge counter_1[N])	
	begin
		case (counter_2)
			1: data = 10'b0000111100;
			2: data = 10'b0000001100;
			3: data = 10'b0000000001;
			4: data = 10'b0000000110;			
			5: data = 10'b0000000000;
		endcase
	end
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
module time_trig (
 input [6:0] minutes,
 input [6:0] seconds,
 input [6:0] milliseconds,
 input clk,
 output [6:0] out_minutes,
 output [6:0] out_seconds,
 output [6:0] out_milliseconds
 );
 
 always@ (posedge clk)
	begin
		out_minutes <= minutes;
		out_seconds <= seconds;
		out_milliseconds <= milliseconds;
	end
endmodule

module time_mux(
 input clk,
 input [6:0] min_1,
 input [6:0] sec_1,
 input [6:0] mill_1,
 input [6:0] min_2,
 input [6:0] sec_2,
 input [6:0] mill_2,
 output [6:0] min_out,
 output [6:0] sec_out,
 output [6:0] mill_out
  );
 always@ (posedge clk) 
	begin
		if (sec_1 < 10 && min_1 == 0)
			begin		
				min_out <= min_2;
				sec_out <= sec_2;
				mill_out <= mill_2;
			end
		else 	
			begin
				min_out <= min_1;
				sec_out <= sec_1;
				mill_out <= mill_1;
			end
			
	end
 endmodule	


module five_sec_trig (
input clk,
input rs,
input laser,
input [6:0] minutes,
input [6:0] seconds,
output reg reset
);


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

 
