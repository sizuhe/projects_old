/*######################################################################
//#	G0B1T: HDL EXAMPLES. 2018.
//######################################################################
//# Copyright (C) 2018. F.E.Segura-Quijano (FES) fsegura@uniandes.edu.co
//# 
//# This program is free software: you can redistribute it and/or modify
//# it under the terms of the GNU General Public License as published by
//# the Free Software Foundation, version 3 of the License.
//#
//# This program is distributed in the hope that it will be useful,
//# but WITHOUT ANY WARRANTY; without even the implied warranty of
//# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//# GNU General Public License for more details.
//#
//# You should have received a copy of the GNU General Public License
//# along with this program.  If not, see <http://www.gnu.org/licenses/>
//####################################################################*/
//=======================================================
//  MODULE Definition
//=======================================================
module SC_STATEMACHINE #(parameter DATAWIDTH_DECODER_SELECTION=3, parameter DATAWIDTH_MUX_SELECTION=3, parameter DATAWIDTH_ALU_SELECTION=4,  parameter DATAWIDTH_REGSHIFTER_SELECTION=2 ) (
	//////////// OUTPUTS //////////
	SC_STATEMACHINE_decoderclearselection_OutBUS,
	SC_STATEMACHINE_decoderloadselection_OutBUS,
	SC_STATEMACHINE_muxselectionBUSA_OutBUS,
	SC_STATEMACHINE_muxselectionBUSB_OutBUS,
	SC_STATEMACHINE_aluselection_OutBUS,
	SC_STATEMACHINE_regSHIFTERclear_OutLow,
	SC_STATEMACHINE_regSHIFTERload_OutLow,
	SC_STATEMACHINE_regSHIFTERshiftselection_OutLow,
	//////////// INPUTS //////////
	SC_STATEMACHINE_CLOCK_50,
	SC_STATEMACHINE_RESET_InHigh,
	SC_STATEMACHINE_overflow_InLow,
	SC_STATEMACHINE_carry_InLow,
	SC_STATEMACHINE_negative_InLow,
	SC_STATEMACHINE_zero_InLow
);	
//=======================================================
//  PARAMETER declarations
//=======================================================
// states declaration
localparam State_RESET_0								= 0;
localparam State_START_0								= 1;
localparam State_ABS_RegGEN3_RegFIX0_0					= 2;
localparam State_ABS_RegGEN3_RegFIX0_1					= 3;
localparam State_ABS_RegGEN3_RegFIX0_2					= 4;
localparam State_ABS_RegGEN3_RegFIX0_3					= 5;
localparam State_ABS_RegGEN3_RegFIX0_4					= 6;
localparam State_ABS_RegGEN3_RegFIX0_5					= 7;
localparam State_ABS_RegGEN3_RegFIX0_6					= 8;
localparam State_ABS_RegGEN3_RegFIX0_7					= 9;	
localparam State_ABS_RegGEN3_RegFIX0_8					= 10;		
localparam State_END_0									= 11;
//=======================================================
//  PORT declarations
//=======================================================
output reg	[DATAWIDTH_DECODER_SELECTION-1:0] SC_STATEMACHINE_decoderclearselection_OutBUS;
output reg	[DATAWIDTH_DECODER_SELECTION-1:0] SC_STATEMACHINE_decoderloadselection_OutBUS;
output reg	[DATAWIDTH_MUX_SELECTION-1:0] SC_STATEMACHINE_muxselectionBUSA_OutBUS;
output reg	[DATAWIDTH_MUX_SELECTION-1:0] SC_STATEMACHINE_muxselectionBUSB_OutBUS;
output reg	[DATAWIDTH_ALU_SELECTION-1:0] SC_STATEMACHINE_aluselection_OutBUS;
output reg	SC_STATEMACHINE_regSHIFTERclear_OutLow;
output reg	SC_STATEMACHINE_regSHIFTERload_OutLow;
output reg	[DATAWIDTH_REGSHIFTER_SELECTION-1:0] SC_STATEMACHINE_regSHIFTERshiftselection_OutLow;
input		SC_STATEMACHINE_CLOCK_50;
input		SC_STATEMACHINE_RESET_InHigh;
input		SC_STATEMACHINE_overflow_InLow;	
input		SC_STATEMACHINE_carry_InLow;	
input		SC_STATEMACHINE_negative_InLow;	
input		SC_STATEMACHINE_zero_InLow;		
//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [7:0] State_Register;
reg [7:0] State_Signal;
//=======================================================
//  Structural coding
//=======================================================
//=========================================================
// ABS: RegGEN3 = ABS(RegFIX0)
//=========================================================
//INPUT LOGIC: COMBINATIONAL
// NEXT STATE LOGIC : COMBINATIONAL
always @(*)
case (State_Register)
//TO INIT REGISTERS
	// 
	State_RESET_0: State_Signal = State_START_0;
	State_START_0: State_Signal = State_ABS_RegGEN3_RegFIX0_0;
	State_ABS_RegGEN3_RegFIX0_0: if (SC_STATEMACHINE_negative_InLow == 1) State_Signal = State_ABS_RegGEN3_RegFIX0_6;
									else State_Signal = State_ABS_RegGEN3_RegFIX0_1;
	State_ABS_RegGEN3_RegFIX0_1: State_Signal = State_ABS_RegGEN3_RegFIX0_2;
	State_ABS_RegGEN3_RegFIX0_2: State_Signal = State_ABS_RegGEN3_RegFIX0_3;
	State_ABS_RegGEN3_RegFIX0_3: State_Signal = State_ABS_RegGEN3_RegFIX0_4;
	State_ABS_RegGEN3_RegFIX0_4: State_Signal = State_ABS_RegGEN3_RegFIX0_5;
	State_ABS_RegGEN3_RegFIX0_5: State_Signal = State_ABS_RegGEN3_RegFIX0_8;
	
	State_ABS_RegGEN3_RegFIX0_6: State_Signal = State_ABS_RegGEN3_RegFIX0_7;
	State_ABS_RegGEN3_RegFIX0_7: State_Signal = State_ABS_RegGEN3_RegFIX0_8;
	
	State_ABS_RegGEN3_RegFIX0_8: State_Signal = State_END_0;
	State_END_0: State_Signal = State_END_0;
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
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		// 111 NO GenREG Selected; 000 GenREG_0, ... 011 GenREG_3;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;
	//=========================================================
	// READ DATA: FROM REGISTER(FIXED OR GENERAL) TO BUSA or BUS_B or BOTH OF THEM
	//=========================================================
		// TO BUS A: 000 RegGen_0; 001 RegGen_1; 010 RegGen_2; 011 RegGen_3; 100 RegFIX_0; 101 RegFIX_1;110 NA; 111 NA;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b111;				
		// TO BUS B: 000 RegGen_0; 001 RegGen_1; 010 RegGen_2; 011 RegGen_3; 100 RegFIX_0; 101 RegFIX_1; 110 NA; 111 NA;
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;				
	//=========================================================
	// ALU OPERATION: 
	//=========================================================
		// 0000 BUSA; 0001 OR; 0010 AND; 0011 NOT A; 0100 XOR; 0101-0111 A; 1000 ADD; 1001 SUB; 1010 INC; 1011 DEC; 1100-1111 A;
		SC_STATEMACHINE_aluselection_OutBUS = 4'b1111;
	//=========================================================
	// SHIFT REGISTER CONTROL: LOAD DATA IN REGSHIFER and REGSHIFER SELECTION
	//=========================================================
		// CLEAR: 1 NO CLEAR; 0 CLEAR;
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		// LOAD: 1 NO LOAD;  0 LOAD;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;
		// SHIFT: 01 ShiftLeft; 10 ShiftRight; 00-11 NOTHING
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;
	end
//=========================================================
// START STATE
//=========================================================
State_START_0 :	
	begin	
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;
		SC_STATEMACHINE_aluselection_OutBUS = 4'b1111;
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;
	end
//=========================================================
// ABS(BUSA): RegGEN3 = ABS(RegFIX0)
//=========================================================
State_ABS_RegGEN3_RegFIX0_0 :	
	begin	
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;	
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b100;				//*
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;				
		SC_STATEMACHINE_aluselection_OutBUS = 4'b0000;					//*
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;						
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;		
	end		
// IF NEG (NOT(BUSA)) (2 Complement)
State_ABS_RegGEN3_RegFIX0_1 :	
	begin	
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;	
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b100;				//*
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;				
		SC_STATEMACHINE_aluselection_OutBUS = 4'b0011;					//*
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;						
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;		
	end				
State_ABS_RegGEN3_RegFIX0_2 :	
	begin	
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;	
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b100;				//*
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;				//*
		SC_STATEMACHINE_aluselection_OutBUS = 4'b0011;					
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 0;					//*	
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;		
	end				
State_ABS_RegGEN3_RegFIX0_3 :	
	begin	
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b011;	//*
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b111;				
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;				
		SC_STATEMACHINE_aluselection_OutBUS = 4'b1111;
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;						
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;		
	end		
// IF NEG (INC(BUSA)) (2 Complement)
State_ABS_RegGEN3_RegFIX0_4 :	
	begin	
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;	
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b011;				//*
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;				
		SC_STATEMACHINE_aluselection_OutBUS = 4'b1010;					//*
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;						
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;		
	end				
State_ABS_RegGEN3_RegFIX0_5 :	
	begin	
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;	
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b011;				//*
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;				//*
		SC_STATEMACHINE_aluselection_OutBUS = 4'b1010;			
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 0;					//*	
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;		
	end				
// UPDATE REG3	
State_ABS_RegGEN3_RegFIX0_6 :	
	begin	
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;	
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b100;				//*			
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;				
		SC_STATEMACHINE_aluselection_OutBUS = 4'b0000;					//*
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;						
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;		
	end		
State_ABS_RegGEN3_RegFIX0_7 :	
	begin	
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;	
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b100;				//*
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;				
		SC_STATEMACHINE_aluselection_OutBUS = 4'b0000;					//*
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 0;					//*	
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;		
	end						
State_ABS_RegGEN3_RegFIX0_8 :	
	begin	
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b011;	//*
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b111;				
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;				
		SC_STATEMACHINE_aluselection_OutBUS = 4'b1111;
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;						
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;		
	end		
//=========================================================
// END STATE
//=========================================================
State_END_0 :	
	begin	
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b111;				
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;				
		SC_STATEMACHINE_aluselection_OutBUS = 4'b1111;
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;						
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;		
	end	
//=========================================================
// DEFAULT
//=========================================================
default:	
	begin	
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;
		SC_STATEMACHINE_aluselection_OutBUS = 4'b1111;
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;
	end
endcase

endmodule
