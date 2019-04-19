`include "opcodes.v"

module register(Clk, Reset_N, rs, rt, rd, w_data, RegWrite, r_data1, r_data2);
	
	input [1:0] rs;
	input [1:0] rt;
	input [1:0] rd;
	input [`WORD_SIZE-1:0] w_data;
	input RegWrite;
	input Reset_N, Clk;

	output [`WORD_SIZE-1:0] r_data1;
	output [`WORD_SIZE-1:0] r_data2;

	wire [`WORD_SIZE-1:0] r_data1;
	wire [`WORD_SIZE-1:0] r_data2;
	
	reg [`WORD_SIZE-1:0] r[3:0];
	
	integer i;

	initial 
	begin
		for (i = 0 ; i < 4 ; i = i + 1)
			r[i] = 0;
	end

	always @(negedge reset_n) begin
		for (i = 0 ; i < 4 ; i = i + 1)
			r[i] = 0;
	end

	// When ID is Done, WB is executed
	always @(*) begin
		if(RegWrite)
			r[rd] <= w_data ;
	end

	assign r_data1 = r[rs];
	assign r_data2 = r[rt];
	

endmodule