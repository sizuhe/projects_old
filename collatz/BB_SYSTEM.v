//=======================================================
//  MODULE Definition
//=======================================================
module BB_SYSTEM (
//////////// OUTPUTS //////////
	BB_SYSTEM_data_OutBUS,
//////////// INPUTS //////////
	BB_SYSTEM_CLOCK_50,
	BB_SYSTEM_RESET_InHigh,
	BB_SYSTEM_data_InBUS
);
//=======================================================
//  PARAMETER declarations
//=======================================================
// uDATAPATH WIDTH BUS.
parameter DATAWIDTH_BUS = 8;
// DECODER CONTROL INPUT BUS.
parameter DATAWIDTH_DECODER_SELECTION = 2;
// DECODER CONTROL OUTPUT BUS.
parameter DATAWIDTH_DECODER_OUT = 4;
// ALU CONTROL BUS.
parameter DATAWIDTH_ALU_SELECTION = 3;
// MUX CONTROL BUS.
parameter DATAWIDTH_MUX_SELECTION = 2;
//=======================================================
//  PORT declarations
//=======================================================
output	[DATAWIDTH_BUS-1:0] BB_SYSTEM_data_OutBUS;
input 	BB_SYSTEM_CLOCK_50;
input 	BB_SYSTEM_RESET_InHigh;
input 	[DATAWIDTH_BUS-1:0] BB_SYSTEM_data_InBUS;
//=======================================================
//  REG/WIRE declarations
//=======================================================
// FLAGS
wire uDATAPATH_2_STATEMACHINE_zero_wireCONTROL;
// DECODER CONTROL BUS: TO SELECT GENERAL_REGISTER TO LOAD DATA FROM DATA_BUS_C. ¡ONE BY ONE, NOT AT SAME TIME!
wire [DATAWIDTH_DECODER_SELECTION-1:0] STATEMACHINE_2_uDATAPATH_decoderloadselection_wireCONTROL; 
// MUX CONTROL: TO SELECT OUTPUT REGISTER TO BUS_A, BUS_B OR BOTH OF THEM
wire [DATAWIDTH_MUX_SELECTION-1:0] STATEMACHINE_2_uDATAPATH_muxselectionBUSA_wireCONTROL;
//ALU CONTROL. TO SELECT ALU OPERATION.
wire [DATAWIDTH_ALU_SELECTION-1:0] STATEMACHINE_2_uDATAPATH_aluselection_wireCONTROL;
// SHIFT_REGISTER CONTROL. TO LOAD DATA
wire STATEMACHINE_2_uDATAPATH_regSHIFTERload_wireCONTROL;

//=======================================================
//  Structural coding
//=======================================================
uDATAPATH #(.DATAWIDTH_BUS(DATAWIDTH_BUS), .DATAWIDTH_DECODER_SELECTION(DATAWIDTH_DECODER_SELECTION), .DATAWIDTH_DECODER_OUT(DATAWIDTH_DECODER_OUT), .DATAWIDTH_ALU_SELECTION(DATAWIDTH_ALU_SELECTION), .DATAWIDTH_MUX_SELECTION(DATAWIDTH_MUX_SELECTION)) uDATAPATH_u0 (
// port map - connection between master ports and signals/registers   
	.uDATAPATH_data_OutBUS(BB_SYSTEM_data_OutBUS),
	.uDATAPATH_zero_OutLow(uDATAPATH_2_STATEMACHINE_zero_wireCONTROL),
	.uDATAPATH_CLOCK_50(BB_SYSTEM_CLOCK_50),
	.uDATAPATH_RESET_InHigh(BB_SYSTEM_RESET_InHigh),
	.uDATAPATH_data_InBUS(BB_SYSTEM_data_InBUS),
	.uDATAPATH_decoderloadselection_InBUS(STATEMACHINE_2_uDATAPATH_decoderloadselection_wireCONTROL), 
	.uDATAPATH_muxselectionBUSA_InBUS(STATEMACHINE_2_uDATAPATH_muxselectionBUSA_wireCONTROL),
	.uDATAPATH_aluselection_InBUS(STATEMACHINE_2_uDATAPATH_aluselection_wireCONTROL),
	.uDATAPATH_regSHIFTERload_InLow(STATEMACHINE_2_uDATAPATH_regSHIFTERload_wireCONTROL)
);
SC_STATEMACHINE #(.DATAWIDTH_DECODER_SELECTION(DATAWIDTH_DECODER_SELECTION), .DATAWIDTH_ALU_SELECTION(DATAWIDTH_ALU_SELECTION)) SC_STATEMACHINE_u0 (
// port map - connection between master ports and signals/registers    
	.SC_STATEMACHINE_decoderloadselection_OutBUS(STATEMACHINE_2_uDATAPATH_decoderloadselection_wireCONTROL), 
	.SC_STATEMACHINE_muxselectionBUSA_OutBUS(STATEMACHINE_2_uDATAPATH_muxselectionBUSA_wireCONTROL),
	.SC_STATEMACHINE_aluselection_OutBUS(STATEMACHINE_2_uDATAPATH_aluselection_wireCONTROL),
	.SC_STATEMACHINE_regSHIFTERload_OutLow(STATEMACHINE_2_uDATAPATH_regSHIFTERload_wireCONTROL),
	.SC_STATEMACHINE_CLOCK_50(BB_SYSTEM_CLOCK_50),
	.SC_STATEMACHINE_RESET_InHigh(BB_SYSTEM_RESET_InHigh),
	.SC_STATEMACHINE_zero_InLow(uDATAPATH_2_STATEMACHINE_zero_wireCONTROL)	
);
endmodule
