/*
	Aaron Chan
	ECE351 (Spring 2017)
	Homework #8 - Barrel Shifter Design Project
	
	- Barrel Shifter Testbench  -
	Tests every op code for functionality. 
*/
module test_shifter;

	wire [4:0] OUT;	// For output of shifter
	
	reg [4:0] data;
	reg [1:0] amount;
	reg [3:0] code;
	reg 	  CLK;
	
	// instantiate barrel shifter, leave default N = 5
	barrel_shifter N1(
				.datain(data),
				.op(code),
				.s(amount),
				.clk(CLK),
				.dataout(OUT) );
				
	initial
	begin
		// Load first
		data = 5'b00000; code = 4'b0100; amount = 0; CLK = 0;
		
		// Load value that we can test other ops with
		#2 data = 5'b01010;
		
		// Test to see if it will hold values with changing inputs
		#2 data = 5'b10000; code = 4'b0101; amount = 2;
		
		// Rotate left by 2 bits
		#2 code = 4'b1000;
		
		// Rotate right by 2 bits.
		#2 code = 4'b0001;
		
		// Rotate right again by 3 bits.
		#2 amount = 3; code = 4'b1001; 
		
		// logical shift left by 1
		#2 amount = 1; code = 4'b0010;
		
		// right arithmetic shift by 0 (shouldn't do anything)
		#2 amount = 0; code = 4'b1011;
		
		// right arithmetic shift by 3
		#2 amount = 3;
		
		// test hold again
		#2 code = 4'b0101; amount = 2; data = 5'b10010;
		
		// test undefined opcode. Module should just hold.
		#2 code = 4'b0111;
		
		// load new value
		#2 code = 4'b0100; 
		
		// arithmetic right shift by 2
		#2 code = 4'b1011;
			
		// arithmetic shift left by 2
		#2 code = 4'b1010;
		
		// load again and finish
		#2 data = 5'b00000; code = 4'b0100;
	end
	
	always
		#1 CLK = ~CLK;
		
endmodule