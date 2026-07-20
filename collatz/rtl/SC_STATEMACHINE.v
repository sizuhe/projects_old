//=======================================================
//  MODULE Definition
//=======================================================
module SC_STATEMACHINE #(parameter DATAWIDTH_DECODER_SELECTION=2, parameter DATAWIDTH_MUX_SELECTION=2, parameter DATAWIDTH_ALU_SELECTION=3) (
	//////////// OUTPUTS //////////
	SC_STATEMACHINE_decoderloadselection_OutBUS,
	SC_STATEMACHINE_muxselectionBUSA_OutBUS,
	SC_STATEMACHINE_aluselection_OutBUS,
	SC_STATEMACHINE_regSHIFTERload_OutLow,
	//////////// INPUTS //////////
	SC_STATEMACHINE_CLOCK_50,
	SC_STATEMACHINE_RESET_InHigh,
	SC_STATEMACHINE_zero_InLow
);	
//=======================================================
//  PARAMETER declarations
//=======================================================
// states declaration
localparam State_RESET_0										= 0;
localparam State_START_0										= 1;
localparam State_EntryValue									= 2;			//	Select test value given in TB_SYSTEM.tv
localparam State_COLLATZ_Dec_Reg0		   				= 3;			//	Decrease value in Reg3
localparam State_COLLATZ_Odd_Process			       	= 4;			//	Odd number processing
localparam State_COLLATZ_Even_Process				      = 5;			//	Even number processing
localparam State_COLLATZ_ComparatorEVOD 					= 6;			// Comparator for even and odd numbers
localparam State_COLLATZ_Load_Reg0					   	= 7;			// Load to Reg0
localparam State_COLLATZ_Load_Reg0_Display				= 8;			// Load to Reg0
localparam State_END_0											= 9;
//=======================================================
//  PORT declarations
//=======================================================
output reg	[DATAWIDTH_DECODER_SELECTION-1:0] SC_STATEMACHINE_decoderloadselection_OutBUS;
output reg	[DATAWIDTH_MUX_SELECTION-1:0] SC_STATEMACHINE_muxselectionBUSA_OutBUS;
output reg	[DATAWIDTH_ALU_SELECTION-1:0] SC_STATEMACHINE_aluselection_OutBUS;
output reg	SC_STATEMACHINE_regSHIFTERload_OutLow;
input		SC_STATEMACHINE_CLOCK_50;
input		SC_STATEMACHINE_RESET_InHigh;
input		SC_STATEMACHINE_zero_InLow;		
//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [7:0] State_Register;
reg [7:0] State_Signal;
//=======================================================
//  Structural coding
//=======================================================
always @(*)
case (State_Register)
	State_RESET_0: State_Signal = State_START_0;
	State_END_0: State_Signal = State_END_0;
	
	/* ========== COMPARATOR ========== */
	State_START_0: State_Signal = State_EntryValue;
	State_EntryValue: State_Signal = State_COLLATZ_Load_Reg0;
	State_COLLATZ_Load_Reg0: State_Signal = State_COLLATZ_ComparatorEVOD;
	State_COLLATZ_ComparatorEVOD: if (SC_STATEMACHINE_zero_InLow == 0) State_Signal = State_COLLATZ_Even_Process;
											else State_Signal = State_COLLATZ_Odd_Process;
															
															
	/* === EVEN NUMBER STATES === */
	/*             N/2            */
	State_COLLATZ_Even_Process: State_Signal = State_COLLATZ_Load_Reg0_Display;
	
	
	/* === ODD NUMBER STATES === */
	/*           3N + 1          */
	State_COLLATZ_Odd_Process: State_Signal = State_COLLATZ_Load_Reg0_Display;	
	
	
	/* ========== VALIDATOR ========== */
	State_COLLATZ_Load_Reg0_Display: State_Signal = State_COLLATZ_Dec_Reg0;
	State_COLLATZ_Dec_Reg0: if (SC_STATEMACHINE_zero_InLow == 1) State_Signal = State_COLLATZ_ComparatorEVOD;
									else State_Signal = State_END_0;
										  
	default : State_Signal = State_RESET_0;
endcase
	
// STATE REGISTER : SEQUENTIAL
always @ ( posedge SC_STATEMACHINE_CLOCK_50 , posedge SC_STATEMACHINE_RESET_InHigh)
if (SC_STATEMACHINE_RESET_InHigh==1)
	State_Register <= State_RESET_0;
else
	State_Register <= State_Signal;
//=======================================================
//  Outputs
//=======================================================
// OUTPUT LOGIC : COMBINATIONAL
always @ (*)
case (State_Register)
//=========================================================
// RESET STATE
//=========================================================
State_RESET_0 :	
	begin	
	//=========================================================
	// DECODERS. a) LOAD DATA: FROM BUSC TO GENERAL REGISTERS b) CLEAR DATA
	//=========================================================
		// 111 NO GenREG Selected; 000 GenREG_0, ... 011 GenREG_3;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 2'b11;
	//=========================================================
	// READ DATA: FROM REGISTER(FIXED OR GENERAL) TO BUSA or BUS_B or BOTH OF THEM
	//=========================================================
		// 00 RegGEN_0; 01 RegGEN_1; 10 TestValue; 11 NOTHING;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 2'b11;				
	//=========================================================
	// ALU OPERATION: 
	//=========================================================
		// 000 Even number; 001 Odd number; 010 Decrease; 011 Comparator; 100 - 111 NOTHING;
		SC_STATEMACHINE_aluselection_OutBUS = 3'b111;
	//=========================================================
	// SHIFT REGISTER CONTROL: LOAD DATA IN REGSHIFER and REGSHIFER SELECTION
	//=========================================================
		// LOAD: 1 NO LOAD;  0 LOAD;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;
	end
//=========================================================
// START STATE
//=========================================================
State_START_0 :	
	begin	
		SC_STATEMACHINE_decoderloadselection_OutBUS = 2'b11;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 2'b11;
		SC_STATEMACHINE_aluselection_OutBUS = 3'b111;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;
	end
//=========================================================
// State_COLLATZ Comparator state
//=========================================================	
State_COLLATZ_ComparatorEVOD :	
	begin	
		SC_STATEMACHINE_decoderloadselection_OutBUS = 2'b11;	
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 2'b00;
		SC_STATEMACHINE_aluselection_OutBUS = 3'b011;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 0;		
	end
//=========================================================
// State_COLLATZ increasing and decreasing states
//=========================================================	
State_COLLATZ_Dec_Reg0 : 
	begin	
		SC_STATEMACHINE_decoderloadselection_OutBUS = 2'b11;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 2'b00;
		SC_STATEMACHINE_aluselection_OutBUS = 3'b010;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;		// Doesnt load to Register. Only for zero signal from ALU.
	end
//=========================================================
// State_COLLATZ multiplier and divider
//=========================================================	
State_COLLATZ_Even_Process :	
	begin	
		SC_STATEMACHINE_decoderloadselection_OutBUS = 2'b11;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 2'b00;				
		SC_STATEMACHINE_aluselection_OutBUS = 3'b000;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 0;							
	end
State_COLLATZ_Odd_Process :	
	begin	
		SC_STATEMACHINE_decoderloadselection_OutBUS = 2'b11;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 2'b00;				
		SC_STATEMACHINE_aluselection_OutBUS = 3'b001;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 0;							
	end
//=========================================================
// State_COLLATZ loading fixed registers
//=========================================================	
State_EntryValue :	
	begin	
		SC_STATEMACHINE_decoderloadselection_OutBUS = 2'b11;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 2'b01;
		SC_STATEMACHINE_aluselection_OutBUS = 3'b111;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 0;	
	end
//=========================================================
// State_COLLATZ register load states
//=========================================================	
State_COLLATZ_Load_Reg0 :	
	begin	
		SC_STATEMACHINE_decoderloadselection_OutBUS = 2'b00;	
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 2'b11;
		SC_STATEMACHINE_aluselection_OutBUS = 3'b111;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;	
	end
State_COLLATZ_Load_Reg0_Display :	
	begin	
		SC_STATEMACHINE_decoderloadselection_OutBUS = 2'b00;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 2'b11;				
		SC_STATEMACHINE_aluselection_OutBUS = 3'b111;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;								
	end
//=========================================================
// END STATE
//=========================================================
State_END_0 :	
	begin	
		SC_STATEMACHINE_decoderloadselection_OutBUS = 2'b11;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 2'b11;				
		SC_STATEMACHINE_aluselection_OutBUS = 3'b111;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;							
	end	
//=========================================================
// DEFAULT
//=========================================================
default:	
	begin	
		SC_STATEMACHINE_decoderloadselection_OutBUS = 2'b11;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 2'b11;
		SC_STATEMACHINE_aluselection_OutBUS = 3'b111;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;
	end
endcase

endmodule
