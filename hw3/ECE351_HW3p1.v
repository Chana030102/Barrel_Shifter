/* 
 Aaron Chan
 ECE351 (Spring 2017)
 Homework #3 Problem 1
 
 Level of Abstraction: Behavioral
 
 Prime Number Circuit
 Output a logic 1 when 4 bit input is 
  equivalent to a prime number.
  
 Possible prime numbers: { 2, 3, 5, 7, 11, 13 }
*/

module prime(A, B, C, D, Out);
	input A, B, C, D;
	output Out;
	
	// Combine inputs for evaluation
	parameter testval = {A,B,C,D};
	
	always 
	begin 
		casex (testval)
		4'b001X : Out = 1; // 2 or 3
		4'b01X1 : Out = 1; // 5 or 7
		4'bX101 : Out = 1; // 5 or 13
		4'bX011 : Out = 1; // 3 or 11
		default : Out = 0; // not prime
		endcase
	end 		
	
endmodule 