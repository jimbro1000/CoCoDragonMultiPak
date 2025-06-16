module Demux42(
	input E,
	input [1:0] A,
	output reg [3:0] S
);
	
	always @(E) begin
		case(A)
			2'b00:
				S = 4'b1110;
			2'b01:
				S = 4'b1101;
			2'b10:
				S = 4'b1011;
			2'b11:
				S = 4'b0111;
		endcase
	end
	
endmodule