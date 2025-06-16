module MultiPak(
	input [15:0] A,
	inout wire [7:0] D,
	input E,
	input Q,
	input RnW,
	input nSLEN,
	input nCTS,
	input iRESET,
	input [1:0] DEFAULT,
	input iP2,
	input [3:0] CART,
	output IOW,
	output [3:0] P2,
	output [3:0] CTS,
	output iCART
);

	wire FFxx;
	wire low7A;
	wire latch;
	wire ENREG;
	wire ENSW;
	wire IOR;
	wire DBEN;
	
	wire [7:0] PR;
	wire [1:0] REGS;
	wire [1:0] REGC;
	wire [3:0] CK;
	
	wire LOADREG;
	
	reg [7:0] Dout;


	DataLatch PakRegister(
		.CLK (LOADREG),
		.OE (ENREG),
		.DataIn (D),
		.DataOut (PR)
	);
	
	Demux42 SelectP2(
		.E (P2),
		.A (REGS),
		.S (iP2)
	);
	
	Demux42 SelectCTS(
		.E (nCTS),
		.A (REGC),
		.S (CTS)
	);
	
	Mux41 CartSelect(
		.E (1'b0),
		.S (REGC),
		.I (CART)
	);
	
	DFlipFlop regLoad(
		.nSET (1'b1),
		.D (1'b1),
		.nRESET (iRESET),
		.CLK (LOADREG),
		.Q (ENSW),
		.nQ (ENREG)
	);
	
	wire [5:0] defaultSwitch;
	wire [6:0] switchState;
	assign switchState = {1'b0, DBEN, DEFAULT[0], DEFAULT[1], DEFAULT[0], DEFAULT[1]};
	
	TriInvBuffer EnableSwitch(
		.E (ENSW),
		.Din (switchState),
		.Dout (defaultSwitch)
	);
	
	assign LOADREG = (!ENSW) ? ~DBEN : 1'bz;
	assign REGS = (!ENSW) ? defaultSwitch[3:2] : PR[1:0];
	assign REGC = (!ENSW) ? defaultSwitch[5:4] : PR[5:4];
	assign CK = {PR[7:6],PR[3:2]};
	
	wire [7:0] regOutput;
	assign regOutput = {CK[3:2], REGC, CK[1:0], REGS};
	wire [7:0] volatileReg;
	
	TriBuffer OutputRegister(
		.E  (IOR),
		.Din (regOutput),
		.Dout (volatileReg)
	);
	
	always @(volatileReg) begin
		Dout = volatileReg;
	end
	
	// must be high impedence on write operations, read operations just work (apparently)
	assign D = LOADREG ? 8'bzzzzzzzz : Dout;
	
	assign FFxx = A[15:8] == 8'b11111111;
	assign low7A = A[6:0] == 7'b1111111;

	assign DBEN = A[6] & !A[7] & FFxx | nSLEN | nCTS;
	assign IOR = latch & E & FFxx & RnW;
	assign IOW = latch & E & FFxx & !Q & !RnW;
	assign latch = low7A & !A[7];


endmodule