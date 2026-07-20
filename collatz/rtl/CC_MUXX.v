//=======================================================
//  MODULE Definition
//=======================================================
module CC_MUXX #(parameter DATAWIDTH_MUX_SELECTION=2, parameter DATAWIDTH_BUS=8)(
	//////////// OUTPUTS //////////
	CC_MUX_data_OutBUS,
	//////////// INPUTS //////////
	CC_MUX_data0_InBUS,
	CC_MUX_data1_InBUS,
	CC_MUX_selection_InBUS
);
//=======================================================
//  PORT declarations
//=======================================================
output reg	[DATAWIDTH_BUS-1:0] CC_MUX_data_OutBUS;
input			[DATAWIDTH_BUS-1:0] CC_MUX_data0_InBUS;
input			[DATAWIDTH_BUS-1:0] CC_MUX_data1_InBUS;
input			[DATAWIDTH_MUX_SELECTION-1:0] CC_MUX_selection_InBUS;
//=======================================================
//  Structural coding
//=======================================================
//INPUT LOGIC: COMBINATIONAL
always@(*)
begin
	case (CC_MUX_selection_InBUS)	
	// Example to more outputs: WaitStart: begin sResetCounter = 0; sCuenteUP = 0; end
		2'b00: CC_MUX_data_OutBUS = CC_MUX_data0_InBUS;
		2'b01: CC_MUX_data_OutBUS = CC_MUX_data1_InBUS;			// Test value
		2'b11: CC_MUX_data_OutBUS = 8'b00000000;					// DO NOTHING !!
		default :   CC_MUX_data_OutBUS = CC_MUX_data0_InBUS; 	// Channel 0 is selected 
	endcase
end

endmodule

