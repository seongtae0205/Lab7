`include "Datapath.v"
`include "ControlUnit.v"
`include "opcodes.v"

`timescale 1ns/1ns
//`define WORD_SIZE 16    // data and address word size

module cpu(clk, reset_n, readM1, address1, data1, readM2, writeM2, address2, data2, num_inst, output_port, is_halted);

	input clk;
	wire clk;
	input reset_n;
	wire reset_n;
	output readM1; // instruction fetch
	wire readM1;
	output [`WORD_SIZE-1:0] address1; //instruction fetch
	reg [`WORD_SIZE-1:0] address1;
	output readM2; // load 
	wire readM2;
	output writeM2; //store
	wire writeM2;
	output [`WORD_SIZE-1:0] address2; //load or store
	wire [`WORD_SIZE-1:0] address2;

	input [`WORD_SIZE-1:0] data1; // instruction
	wire [`WORD_SIZE-1:0] data1;
	inout [`WORD_SIZE-1:0] data2; //memory data
	wire [`WORD_SIZE-1:0] data2;

	output [`WORD_SIZE-1:0] num_inst;
	wire [`WORD_SIZE-1:0] num_inst;
	output [`WORD_SIZE-1:0] output_port;
	wire [`WORD_SIZE-1:0] output_port;
	output is_halted;
	wire is_halted;

	wire readM1_to_mem;
	wire readM1_from_datapath;
	wire [`WORD_SIZE-1:0] address1_from_datapath;
	wire [`WORD_SIZE-1:0] data1_from_mem [0 : 3];
	reg [`WORD_SIZE-1:0] data1_from_mem_reg [0 : 3];

	wire [`WORD_SIZE-1:0] address1_to_mem;
	wire [`WORD_SIZE-1:0] data1_to_datapath;
	wire is_hit;
	wire is_miss;

	wire readM2_to_mem;
	wire writeM2_to_mem;
	wire [`WORD_SIZE-1:0] data2_to_mem;
	wire [`WORD_SIZE-1:0] address2_to_mem;
	wire [`WORD_SIZE-1:0] data2_from_mem [0 : 3];
	wire [`WORD_SIZE-1:0] data2_to_cpu;
	integer i;


	// TODO : Implement your pipelined CPU!

	assign readM1 = readM1_to_mem;
	assign address1 = address1_to_mem;

	assign data1_from_mem = data1_from_mem_reg;


	always @(posedge clk) begin
		if(is_miss && i == 0) begin
			address1 = (address1_to_mem / 4) *4;
			i = 4;
		end
		else if (is_miss) begin
			address1 =  address1 + 1;
			data1_from_mem_reg[4-i] = data1;
			i = i-1;
		end
	end
	always @(posedge clk) begin
		if(reset_n) begin
			if(is_miss) begin
				for(i = 0; i < 4 ; i = i+1) beign
					data1_from_mem_reg[i] = data1;
				end
			end
		end
	end
				
	

	
	Icache icache(clk, reset_n, readM1_from_datapath, address1_from_datapath, readM1_to_mem, address1_to_mem, data1_from_mem, data1_to_datapath, is_hit, is_miss);
	

	//Dcache dcache(clk, reset_n, readM2, writeM2, data2, address2, readM2_to_mem, writeM2_to_mem, data2_to_mem, address2_to_mem, data2_from_mem, data2_to_cpu, is_hit, is_miss);
	Datapath datapath(clk, reset_n, readM1, address1, data1_to_cpu, readM2, writeM2, address2, data2_to_cpu, num_inst, output_port, is_halted, is_hit, is_miss);



endmodule
