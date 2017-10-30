/* 
 Aaron Chan
 EC351 (Spring 2017)
 Homework #3 Problem 2
 
 - Testbench -
 
 Testbench for prime number circuit. 
 We will test all 16 possible numbers for the
 4-bit input circuit and expect to ONLY get
 logic 1 outputs when the input is prime.
 
 Possible prime numbers: { 2, 3, 5, 7, 11, 13 }
*/
module prime_stimulus;

	wire PRIME;  // Output of circuit
	reg a,b,c,d; // Inputs to prime number circuit
	
	parameter testval = {a,b,c,d}; 
	integer count; // use in 'for' loop
	
	// instantiate prime number circuit
	prime P1(.A(a), .B(b), .C(c), .D(d), .Out(PRIME));

	for( count=0; count < 16; count = count + 1)
		testval = count;
	
endmodule