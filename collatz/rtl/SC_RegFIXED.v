//=======================================================
//  MODULE Definition
//=======================================================
module SC_RegFIXED #(parameter DATAWIDTH_BUS=8, parameter DATA_REGFIXED_INIT=8'b00000000)(
	//////////// OUTPUTS //////////
	SC_RegFIXED_data_OutBUS,
	//////////// INPUTS //////////
	SC_RegFIXED_CLOCK_50,
	SC_RegFIXED_RESET_InHigh
);
//=======================================================
//  PARAMETER declarations
//=======================================================

//=======================================================
//  PORT declarations
//=======================================================
output reg		[DATAWIDTH_BUS-1:0] SC_RegFIXED_data_OutBUS;
input			SC_RegFIXED_CLOCK_50;
input			SC_RegFIXED_RESET_InHigh;
//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [DATAWIDTH_BUS-1:0] RegFIXED_Register;
reg [DATAWIDTH_BUS-1:0] RegFIXED_Signal;
//=======================================================
//  Structural coding
//=======================================================
//INPUT LOGIC: COMBINATIONAL
always @ (*)
	RegFIXED_Signal = RegFIXED_Register;
// REGISTER : SEQUENTIAL
always @ ( posedge SC_RegFIXED_CLOCK_50 , posedge SC_RegFIXED_RESET_InHigh)
	if (SC_RegFIXED_RESET_InHigh==1)
		RegFIXED_Register <= DATA_REGFIXED_INIT;
	else
		RegFIXED_Register <= RegFIXED_Signal;
//=======================================================
//  Outputs
//=======================================================
// OUTPUT LOGIC : COMBINATIONAL
	always @ (*)
		SC_RegFIXED_data_OutBUS = RegFIXED_Register;  

endmodule

