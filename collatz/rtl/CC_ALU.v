//=======================================================
//  MODULE Definition
//=======================================================
module CC_ALU #(parameter DATAWIDTH_BUS=8, parameter DATAWIDTH_ALU_SELECTION=3)(
	//////////// OUTPUTS //////////
	CC_ALU_zero_OutLow,
	CC_ALU_data_OutBUS,
	//////////// INPUTS //////////
	CC_ALU_dataA_InBUS,
	CC_ALU_selection_InBUS
);
//=======================================================
//  PORT declarations
//=======================================================
output 		CC_ALU_zero_OutLow;
output reg	[DATAWIDTH_BUS-1:0] CC_ALU_data_OutBUS;
input			[DATAWIDTH_BUS-1:0] CC_ALU_dataA_InBUS;
input			[DATAWIDTH_ALU_SELECTION-1:0] CC_ALU_selection_InBUS;
//=======================================================
//  Structural coding
//=======================================================
//INPUT LOGIC: COMBINATIONAL
always@(*)
begin
	case (CC_ALU_selection_InBUS)	
		3'b000:  CC_ALU_data_OutBUS = CC_ALU_dataA_InBUS >> 1;											// Even number
		3'b001:  CC_ALU_data_OutBUS = (CC_ALU_dataA_InBUS << 1) + CC_ALU_dataA_InBUS + 1'b1;	// Odd number
		3'b010:  CC_ALU_data_OutBUS = CC_ALU_dataA_InBUS - 1'b1;											// DECREMENT A
		3'b011:  CC_ALU_data_OutBUS = CC_ALU_dataA_InBUS & 8'b00000001;								// Comparator for Even or Odd
		3'b100:  CC_ALU_data_OutBUS = CC_ALU_dataA_InBUS;													// DO NOTHING!!!!!!!!
		3'b101:  CC_ALU_data_OutBUS = CC_ALU_dataA_InBUS;													// DO NOTHING!!!!!!!!
		3'b110:  CC_ALU_data_OutBUS = CC_ALU_dataA_InBUS;													// DO NOTHING!!!!!!!!		
		3'b111:  CC_ALU_data_OutBUS = CC_ALU_dataA_InBUS;													// DO NOTHING!!!!!!!!		
		default :  CC_ALU_data_OutBUS = CC_ALU_dataA_InBUS;												// Channel 0 is selected
	endcase
end
//=======================================================
//  Outputs
//=======================================================
/*Flags*/
assign CC_ALU_zero_OutLow = (CC_ALU_data_OutBUS == 8'b00000000) ? 1'b0 : 1'b1;	// Determinación de la flag Zero

endmodule


