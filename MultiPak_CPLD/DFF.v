module DFlipFlop (
	input nSET,
	input nRESET,
	input D,
	input CLK,
	output reg Q,
	output nQ
);

	initial begin
		Q = 0;
	end
	
	always @(negedge CLK) begin
		if (!nRESET)
			Q = 0;
		else if (!nSET)
			Q = D;
		else
			Q = ~Q;
	end
	
	assign nQ = ~Q;

endmodule