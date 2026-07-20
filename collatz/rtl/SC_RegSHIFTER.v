//=======================================================
//  MODULE Definition
//=======================================================
module SC_RegSHIFTER #(parameter RegSHIFTER_DATAWIDTH=8)(
	//////////// OUTPUTS //////////
	SC_RegSHIFTER_data_OutBUS,
	//////////// INPUTS //////////
	SC_RegSHIFTER_CLOCK_50,
	SC_RegSHIFTER_RESET_InHigh,
	SC_RegSHIFTER_load_InLow, 
	SC_RegSHIFTER_data_InBUS
);
//=======================================================
//  PORT declarations
//=======================================================
output	[RegSHIFTER_DATAWIDTH-1:0]	SC_RegSHIFTER_data_OutBUS;
input		SC_RegSHIFTER_CLOCK_50;
input		SC_RegSHIFTER_RESET_InHigh;
input		SC_RegSHIFTER_load_InLow;	
input		[RegSHIFTER_DATAWIDTH-1:0]	SC_RegSHIFTER_data_InBUS;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [RegSHIFTER_DATAWIDTH-1:0] RegSHIFTER_Register;
reg [RegSHIFTER_DATAWIDTH-1:0] RegSHIFTER_Signal;
//=======================================================
//  Structural coding
//=======================================================
//INPUT LOGIC: COMBINATIONAL
always @(*)
begin
	if (SC_RegSHIFTER_load_InLow == 1'b0)
		RegSHIFTER_Signal = SC_RegSHIFTER_data_InBUS;
	else
		RegSHIFTER_Signal = RegSHIFTER_Register;
	end	
//STATE REGISTER: SEQUENTIAL
always @(posedge SC_RegSHIFTER_CLOCK_50, posedge SC_RegSHIFTER_RESET_InHigh)
begin
	if (SC_RegSHIFTER_RESET_InHigh == 1'b1)
		RegSHIFTER_Register <= 0;
	else
		RegSHIFTER_Register <= RegSHIFTER_Signal;
end
//=======================================================
//  Outputs
//=======================================================
//OUTPUT LOGIC: COMBINATIONAL
assign SC_RegSHIFTER_data_OutBUS = RegSHIFTER_Register;

endmodule
