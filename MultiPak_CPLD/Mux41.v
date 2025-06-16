module Mux41(
	input E,
	input [1:0] S,
	input [3:0] I,
	output Z
);

	assign Z = E ? 1'bz : I[S];

endmodule