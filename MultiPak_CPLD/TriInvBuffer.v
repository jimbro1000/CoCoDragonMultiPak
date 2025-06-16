module TriInvBuffer(
	input E,
	input [5:0] Din,
	output [5:0] Dout
);

	assign Dout = E ? 6'bzzzzzz : 6'b111111 ^ Din;

endmodule