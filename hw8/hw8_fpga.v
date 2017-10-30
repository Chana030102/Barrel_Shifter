/*
	Aaron Chan
	ECE351 (Spring 2017)
	Homework #8 - N-bit Barrel Shifter Design Project
		
	Top level module for Homework #8
	FPGA used: Nexys4 
	
	Description:
	------------
	Top level module for homework #8, implementing a 5-bit barrel shifter
	and displaying all inputs and outputs of it on LEDs and the seven segment
	display. Switches will act as inputs and a push button will act as our clock.
	
	External ports will match pin names in the n4DDRfpga.xdc constraints file	
	
*/

module hw8_fpga (
	input 				clk,           	// 100MHz clock from on-board oscillator
	input				btnCpuReset,	// red pushbutton input 
	
	input				btnC,			// on-board center button
	input				btnU,			// on-board upper button
	input				btnL,			// on-board left button
	input				btnR,			// on-board right button
	input				btnD,			// on-board down "lower" button
	input 	[15:0]		sw,				// set of switches for input
	
	output 	[6:0]		seg,			// Seven segment display cathode pins
	output              dp,
	output	[7:0]		an,				// Seven segment display anode pins	
	
	output	[15:0]		led				// on-board LEDs
); 

	// parameter
	parameter SIMULATE = 0;

	// internal variables
	wire				sysclk;			// 100MHz clock from on-board oscillator	
	wire				sysreset;		// system reset signal - asserted high to 
										// force reset
	 
	wire	[7:0]		segs_int		// seven segment display segments
	wire				clk_1Hz;		// 1HZ clock to drive the counter

	wire	[5:0]		btn;							
	wire	[5:0]		btn_db;			// debounced button signals
	wire	[15:0]		sw_db;			// debounced switch signals
	
	// To be used as input to seven_segment displays
	wire	[4:0]		data_in_0;		// data_in BCD of singles digit
	wire	[4:0]		data_in_1;		// data_in BCD of tens digit
	wire	[4:0]		data_out_0;		// data_out BCD of singles digit
	wire	[4:0]		data_out_1;		// data_out BCD of tens digit
	wire	[4:0]		op_code_0;		// op_code BCD of singles digit
	wire	[4:0]		op_code_1;		// op_code BCD of tens digit
	
	// global assigns
	assign	sysclk = clk;				// clock for seven segment display
	assign 	sysreset = ~btn_db[5];		// btnCpuReset is asserted low	
	assign	dp = segs_int[7];			// multiplexed decimal points and segments
	assign	seg = segs_int[6:0];		// produced by the Seven Segment display driver	

	assign	btn = {btnCpuReset,btnC,btnU,btnR,btnL,btnD};
	assign	led[9:6] = sw[9:6];			// op_code binary input to LEDs
	assign	led[12:11] = sw[12:11];		// shift amount binary input to LEDs
	
	// instantiate debouncer
	debounce DB
	(
		.clk(sysclk),
		.pbtn_in(btn),
		.switch_in(sw),
		.pbtn_db(btn_db),
		.swtch_db(sw_db)
	);
		
	// instantiate barrel shifter
	barrel_shifter B1
	(
		.datain(sw_db[4:0]),
		.op(sw_db[9:6]),
		.s(sw_db[12:11]),
		.clk(btn_db[4]),
		.dataout(led[4:0])
	);
	
	// instantiate three double_dabble modules
	double_dabble DD1	// data_in 
	(
		.datain(sw_db[4:0]),
		.singles(data_in_0),
		.tens(data_in_1)
	);
	
	double_dabble DD2	// op_code
	(
		.datain({0,	sw_db[9:6]}),
		.singles(op_code_0),
		.tens(op_code_1)
	);
	
	double_dabble DD3	// data_out
	(
		.datain(led[4:0]),
		.singles(data_out_0),
		.tens(data_out_1)
	);
    
	// instantiate the 7-segment, 8-digit display
	sevensegment
	#(
		.RESET_POLARITY_LOW(0),
		.SIMULATE(SIMULATE)
	) SSB
	(
		// inputs for control signals
		// 5'b11111 is the code for blank
		.d0(data_out_0),	
		.d1(data_out_1),
 		.d2(data_in_0),
		.d3(data_in_1),
		.d4({3'b000,sw_db[12:11]}),
		.d5(op_code_0),
		.d6(op_code_1),
		.d7(5'b11111),
		.dp(0),
		
		// outputs to seven segment display
		.seg(segs_int),			
		.an(an),
		
		// clock and reset signals (100 MHz clock, active high reset)
		.clk(sysclk),
		.reset(sysreset),
		
		// ouput for simulation only
		.digits_out()
	);
	
	endmodule