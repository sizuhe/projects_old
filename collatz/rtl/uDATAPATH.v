//=======================================================
//  MODULE Definition
//=======================================================
module uDATAPATH #(parameter DATAWIDTH_BUS=8, parameter DATAWIDTH_DECODER_SELECTION=2, parameter DATAWIDTH_DECODER_OUT=4, parameter DATAWIDTH_ALU_SELECTION=3, parameter DATAWIDTH_MUX_SELECTION=2)(
	//////////// OUTPUTS //////////
	uDATAPATH_data_OutBUS,
	uDATAPATH_zero_OutLow,
	//////////// INPUTS //////////
	uDATAPATH_CLOCK_50,
	uDATAPATH_RESET_InHigh,
	uDATAPATH_data_InBUS,
	uDATAPATH_decoderloadselection_InBUS,
	uDATAPATH_muxselectionBUSA_InBUS,
	uDATAPATH_aluselection_InBUS,
	uDATAPATH_regSHIFTERload_InLow
);
//=======================================================
//  PORT declarations
//=======================================================
output 	[DATAWIDTH_BUS-1:0] uDATAPATH_data_OutBUS;
output 	uDATAPATH_zero_OutLow;
//////////// INPUTS //////////
input 	uDATAPATH_CLOCK_50;
input 	uDATAPATH_RESET_InHigh;
input 	[DATAWIDTH_BUS-1:0] uDATAPATH_data_InBUS;
input 	[DATAWIDTH_DECODER_SELECTION-1:0] uDATAPATH_decoderloadselection_InBUS;
input 	[DATAWIDTH_MUX_SELECTION-1:0]	uDATAPATH_muxselectionBUSA_InBUS;
input 	[DATAWIDTH_ALU_SELECTION-1:0]	uDATAPATH_aluselection_InBUS;
input 	uDATAPATH_regSHIFTERload_InLow;
//=======================================================
//  REG/WIRE declarations
//=======================================================
// GENERAL_REGISTERS OUTPUTS WIRES
wire [DATAWIDTH_BUS-1:0] RegGENERAL_2_MUX_data0_wireBUS; 
// ARCHITECTURE BUSES WIRES
wire [DATAWIDTH_BUS-1:0] MUX_2_ALU_dataA_wireBUS;
wire [DATAWIDTH_BUS-1:0] ALU_2_RegSHIFTER_data_wireBUS;
wire [DATAWIDTH_BUS-1:0] RegSHIFTER_2_RegGENERAL_dataC_wireBUS;
// DECODER CONTROL LOAD
wire [DATAWIDTH_DECODER_OUT-1:0] DECODER_2_RegGENERAL_decoderloadselection_wireBUS;
//=======================================================
//  Structural coding
//=======================================================
//-------------------------------------------------------
//-------------------------------------------------------
//GENERAL_REGISTERS
SC_RegGENERAL #(.RegGENERAL_DATAWIDTH(DATAWIDTH_BUS)) SC_RegGENERAL_u0 (
// port map - connection between master ports and signals/registers   
	.SC_RegGENERAL_data_OutBUS(RegGENERAL_2_MUX_data0_wireBUS),
	.SC_RegGENERAL_CLOCK_50(uDATAPATH_CLOCK_50),
	.SC_RegGENERAL_RESET_InHigh(uDATAPATH_RESET_InHigh),
	.SC_RegGENERAL_load_InLow(DECODER_2_RegGENERAL_decoderloadselection_wireBUS[0]),
	.SC_RegGENERAL_data_InBUS(RegSHIFTER_2_RegGENERAL_dataC_wireBUS)
);
//-------------------------------------------------------
//-------------------------------------------------------
// SHIFT_REGISTER
SC_RegSHIFTER #(.RegSHIFTER_DATAWIDTH(DATAWIDTH_BUS)) SC_RegSHIFTER_u0 (
// port map - connection between master ports and signals/registers   
	.SC_RegSHIFTER_data_OutBUS(RegSHIFTER_2_RegGENERAL_dataC_wireBUS),
	.SC_RegSHIFTER_CLOCK_50(uDATAPATH_CLOCK_50),
	.SC_RegSHIFTER_RESET_InHigh(uDATAPATH_RESET_InHigh),
	.SC_RegSHIFTER_load_InLow(uDATAPATH_regSHIFTERload_InLow),
	.SC_RegSHIFTER_data_InBUS(ALU_2_RegSHIFTER_data_wireBUS)
);
//-------------------------------------------------------
//-------------------------------------------------------
// 
CC_DECODER #(.DATAWIDTH_DECODER_SELECTION(DATAWIDTH_DECODER_SELECTION), .DATAWIDTH_DECODER_OUT(DATAWIDTH_DECODER_OUT)) CC_DECODER_u0
(
// port map - connection between master ports and signals/registers   
	.CC_DECODER_datadecoder_OutBUS(DECODER_2_RegGENERAL_decoderloadselection_wireBUS),
	.CC_DECODER_selection_InBUS(uDATAPATH_decoderloadselection_InBUS)
);
//-------------------------------------------------------
//-------------------------------------------------------
// 
CC_MUXX #(.DATAWIDTH_MUX_SELECTION(DATAWIDTH_MUX_SELECTION), .DATAWIDTH_BUS(DATAWIDTH_BUS)) CC_MUXX_u0
(
// port map - connection between master ports and signals/registers   
	.CC_MUX_data_OutBUS(MUX_2_ALU_dataA_wireBUS),
	.CC_MUX_data0_InBUS(RegGENERAL_2_MUX_data0_wireBUS), 
	.CC_MUX_data1_InBUS(uDATAPATH_data_InBUS), 
	.CC_MUX_selection_InBUS(uDATAPATH_muxselectionBUSA_InBUS)
);
//-------------------------------------------------------
//-------------------------------------------------------
//
CC_ALU #(.DATAWIDTH_BUS(DATAWIDTH_BUS), .DATAWIDTH_ALU_SELECTION(DATAWIDTH_ALU_SELECTION)) CC_ALU_u0
(
// port map - connection between master ports and signals/registers   
	.CC_ALU_zero_OutLow(uDATAPATH_zero_OutLow),
	.CC_ALU_data_OutBUS(ALU_2_RegSHIFTER_data_wireBUS),
	.CC_ALU_dataA_InBUS(MUX_2_ALU_dataA_wireBUS), 
	.CC_ALU_selection_InBUS(uDATAPATH_aluselection_InBUS)
);
//-------------------------------------------------------
assign uDATAPATH_data_OutBUS = RegGENERAL_2_MUX_data0_wireBUS;

endmodule

