module TriBuffer(
	input E,
	input [7:0] Din,
	output [7:0] Dout
);

	assign Dout = E ? 8'bzzzzzz : Din;

endmodule