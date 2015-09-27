// ============================================================================
// Copyright (c) 2015, Luis Ardila
// ============================================================================
//           
//                   Hochschule Karlsruhe
//                   Moltkestr. 30 
//                   Karlsruhe, Germany
//                   76133
//
//                   web: http://www.hs-karlsruhe.de/
//                   e-mail: arlu1011@hs-karlsruhe.de - leardilap@unal.edu.co
//
// ============================================================================
// Major Functions/Design Description:
//
// 
//
//
// ============================================================================
// Revision History:
// ============================================================================
//   Ver.: |Author:   		|Mod. Date:    |Changes Made:
//   V0.1  |Luis Ardila  	|27/09/15      |Created
// ============================================================================

module micFilter_Top(
			input clk, 						
			input rst, 					
			input [13:0] HSMC_ADA_D,			
			input HSMC_ADA_DCO,		
			input [13:0] HSMC_ADB_D,			
			input HSMC_ADB_DCO,		
			output [13:0] HSMC_DA,				
			output [13:0] HSMC_DB,
			output [14:0] fir_memory_s2_address,	
			output fir_memory_s2_clken,		
			input [31:0] fir_memory_s2_readdata,	
			output fir_memory_clk2_clk		
			
			
	);

wire adjust;
reg [15:0] sGamma;
reg [15:0] sGamma_b;
reg [15:0] sMic;
reg [15:0] sMic_b;
wire [15:0] sGamma_corr;

assign adjust	= 1'b1; 
assign HSMC_DA = sGamma_corr[13:0];

micFilter micFilter_inst(	
			.adj 						(adjust),					//Coefficient update halt input bit (low = stop update)
			.clk_in 					(clk),						//Clock input (nom. 25 MHz)
			.gamma 					(sGamma),					//Detector signal input s(k)
			.mic 						(sMic),						//Mechanical sensor signal input v(q)
			.rst 						(rst),						//Synchronous reset input
			.gamma_corr 			(sGamma_corr),				//Filter output y(k)
			.clk_outp 				(open),						//Clock output
			.fir_memory_s2_address		(fir_memory_s2_address),	 			
			.fir_memory_s2_clken			(fir_memory_s2_clken),		
			.fir_memory_s2_readdata		(fir_memory_s2_readdata),	
			.fir_memory_clk2_clk			(fir_memory_clk2_clk)		
	);

	//--- analog to digital converter capture and sync
	//--- Channel A
always @(posedge rst or posedge HSMC_ADA_DCO)
begin
	if (rst) begin
		sGamma_b	<= 16'd0;
	end
	else begin
		sGamma_b <= {{2{HSMC_ADA_D[13]}}, HSMC_ADA_D};
	end
end

always @(posedge rst or posedge clk)
begin
	if (rst) begin
		sGamma	<= 14'd0;
	end
	else begin
		sGamma	<= sGamma_b;
	end
end

	//--- Channel B
always @(posedge rst or posedge HSMC_ADB_DCO)
begin
	if (rst) begin
		sMic_b	<= 16'd0;
	end
	else begin
		sMic_b   <= {{2{HSMC_ADB_D[13]}}, HSMC_ADB_D};
	end
end

always @(posedge rst or posedge clk)
begin
	if (rst) begin
		sMic	<= 14'd0;
	end
	else begin
		sMic	<= sMic_b;
	end
end
	
endmodule