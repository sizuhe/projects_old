//=======================================================
//  MODULE Definition
//=======================================================
module SC_RegGENERAL #(parameter RegGENERAL_DATAWIDTH=8)(
	//////////// OUTPUTS //////////
	SC_RegGENERAL_data_OutBUS,
	//////////// INPUTS //////////
	SC_RegGENERAL_CLOCK_50,
	SC_RegGENERAL_RESET_InHigh,
	SC_RegGENERAL_load_InLow, 
	SC_RegGENERAL_data_InBUS
);
//=======================================================
//  PORT declarations
//=======================================================
output	[RegGENERAL_DATAWIDTH-1:0]	SC_RegGENERAL_data_OutBUS;
input		SC_RegGENERAL_CLOCK_50;
input		SC_RegGENERAL_RESET_InHigh;
input		SC_RegGENERAL_load_InLow;	
input		[RegGENERAL_DATAWIDTH-1:0]	SC_RegGENERAL_data_InBUS;
//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [RegGENERAL_DATAWIDTH-1:0] RegGENERAL_Register;
reg [RegGENERAL_DATAWIDTH-1:0] RegGENERAL_Signal;
//=======================================================
//  Structural coding
//=======================================================
//INPUT LOGIC: COMBINATIONAL
always @(*)
begin
	if (SC_RegGENERAL_load_InLow == 1'b0)
		RegGENERAL_Signal = SC_RegGENERAL_data_InBUS;
	else
		RegGENERAL_Signal = RegGENERAL_Register;
	end	
//STATE REGISTER: SEQUENTIAL
always @(posedge SC_RegGENERAL_CLOCK_50, posedge SC_RegGENERAL_RESET_InHigh)
begin
	if (SC_RegGENERAL_RESET_InHigh == 1'b1)
		RegGENERAL_Register <= 0;
	else
		RegGENERAL_Register <= RegGENERAL_Signal;
end
//=======================================================
//  Outputs
//=======================================================
//OUTPUT LOGIC: COMBINATIONAL
assign SC_RegGENERAL_data_OutBUS = RegGENERAL_Register;

endmodule
