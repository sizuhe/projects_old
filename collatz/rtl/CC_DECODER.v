//=======================================================
//  MODULE Definition
//=======================================================
module CC_DECODER #(parameter DATAWIDTH_DECODER_SELECTION=2, parameter DATAWIDTH_DECODER_OUT=4)(
	//////////// OUTPUTS //////////
	CC_DECODER_datadecoder_OutBUS,
	//////////// INPUTS //////////
	CC_DECODER_selection_InBUS
);
//=======================================================
//  PORT declarations
//=======================================================
output reg	[DATAWIDTH_DECODER_OUT-1:0] CC_DECODER_datadecoder_OutBUS;
input			[DATAWIDTH_DECODER_SELECTION-1:0] CC_DECODER_selection_InBUS;
//=======================================================
//  Structural coding
//=======================================================
//INPUT LOGIC: COMBINATIONAL
always@(*)
begin
	case (CC_DECODER_selection_InBUS)	
		2'b00: CC_DECODER_datadecoder_OutBUS = 4'b1110;
		2'b01: CC_DECODER_datadecoder_OutBUS = 4'b1101;
		2'b11: CC_DECODER_datadecoder_OutBUS = 4'b1111;
		default : CC_DECODER_datadecoder_OutBUS = 4'b1111; 
	endcase
end

endmodule
