/*
	Aaron Chan
	ECE351 (Spring 2017)
	Homework #8 - N-bit Barrel Shifter Design Project
	
	This module is defaulted to 5-bit data manipulations, but has a 
	parameter to change the data size and is flexible with sizes of 
	data greater than 3.
	
	An amount input determines how many places to shift or rotate.
	Operation code inputs determine what bit operations to perform.
	The operation codes are as follows:
	X000	rotate left
	X001	rotate right
	0010	logical shift left
	0011	logicla shift right
	1010	arithmetic shift left
	1011	arithmetic shift right
	
	X100	load
	X101	hold
	
	NOTE: other undefined operation codes will do nothing
		  and do the same operation as hold
*/
module barrel_shifter (datain,op,s,clk,dataout);
	parameter integer N = 5;
	
	// Port Declarations
	input 	[N-1:0]	datain;
	input 	[3:0]	op;
	input	[1:0]	s;
	input			clk;
	output	[N-1:0]	dataout;
	
	reg 	[N-1:0]	d;	// store data for manipulation
	integer loop;
	
	assign dataout = d;
	
	always@(posedge clk)
		casex(op)
			// Left Rotate
			4'bX000: 
			begin										
				for(loop = 0; loop < s; loop=loop+1)
					d = {d[N-2:0],d[N-1]};
			end
			// Right Rotate		 
			4'bX001:
			begin 										
				for(loop = 0; loop < s; loop=loop+1)
					d = {d[0],d[N-1:1]};
			end

			4'bX010: d = (d << s);		// Left Shift
			4'b0011: d = (d >> s);		// Logical Right Shift		
			4'b1011: 					// Arithmetic Right Shift
				begin
					for(loop = 0; loop < s; loop=loop+1)
						d = {d[N-1],d[N-1:1]};
				end
			4'bX100: d = datain;		// Load 
			default: d = d;				// do nothing. Hold;
		endcase
endmodule