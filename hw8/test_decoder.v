/*
	Aaron Chan
	EC351 (Spring 2017)
	Homework #8 - N-bit Barrel Shifter Design Project
	
	- Double Dabble Testbench  -
	
	This is an exhaustive test of the double dabble module 
	to make sure it	properly converts binary to BCD. 
*/
module test_decoder;

	wire 	[4:0] 	single;
	wire 	[4:0] 	ten;
	
	reg 	[4:0]	data;
	
	// Instantiate decoder
	double_dabble D1(
			.datain(data),
			.singles(single),
			.tens(ten)	);
	
	integer i;
	initial

	begin
		data = 0;
		for(i = 0; i < 32; i = i + 1)
			#2 data = data + 1'b1;
	end
	
endmodule