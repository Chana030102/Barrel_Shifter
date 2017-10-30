/*
	Aaron Chan
	ECE351 (Spring 2017)	
	Homework #8 - N-bit Barrel Shifter Design Project
	
	Double Dabble Module
	
	Convert binary input into binary-coded decimal (BCD).
	Outputs will be amounts representing the tens and singles
	digits in decimal.
	
	**This module is specifically made for seven-segment
	  displays on the Nexys4FPGA. 
	
*/

module double_dabble( datain, singles, tens );
		
		// Port Declarations
		input 	[4:0]	datain;		// Binary Input
		output 	[4:0]	singles;	// Singles Digit
		output 	[4:0]	tens;		// Tens Digit
			
		reg [4:0] data0;
		reg [4:0] data1;

		assign singles	= data0;
		assign tens 	= data1;
		
		always@(datain)
		begin
			data0 = datain % 10;
			data1 = (datain - data0) / 10;
		end
	
endmodule