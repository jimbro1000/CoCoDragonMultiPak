module DataLatch(
	input CLK,
	input OE,
	input [7:0] DataIn,
	output [7:0] DataOut
);

	reg [7:0] DataHeld;

	initial begin
		DataHeld = 8'b00000000;
	end
	
	assign DataOut = OE ? 8'bzzzzzzzz : DataHeld;
	
	always @(negedge CLK) begin
		DataHeld = DataIn;
	end
	
endmodule