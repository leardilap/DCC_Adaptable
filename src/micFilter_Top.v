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
			input adj,
			input clk, 						
			input rst, 		
			input [31:0] cntl,   			
			input [13:0] HSMC_ADA_D,			
			input HSMC_ADA_DCO,		
			input [13:0] HSMC_ADB_D,			
			input HSMC_ADB_DCO,		
			output [13:0] HSMC_DA,				
			output [13:0] HSMC_DB,
			input [3:0] output1_sel,
			input [3:0] output2_sel,
			input [2:0] bypass_sel,
			input  [18:0] delay_lenght,
			input [11:0] DownSampleRate,
			input [31:0] DownSampleMult,
			input [15:0] sub_factor,
			input [11:0] clkGen_lP,		    // Clock Generator - Low Period   1250;
			input [11:0] clkGeN_hP,		    // Clock Generator - High Period   2500;
			input [11:0] intClkGen_lP1,	 // Interp Clock Generator - Clk1 Low Period		3
			input [11:0] intClkGen_hP1,	 // Interp Clock Generator - Clk1 High Period   5
			input [11:0] intClkGen_lP2,	 // Interp Clock Generator - Clk2 Low Period     13	
			input [11:0] intClkGen_hP2,	 // Interp Clock Generator - Clk2 High Period    25	
			input [11:0] intClkGen_lP3,	 // Interp Clock Generator - Clk3 Low Period     63	
			input [11:0] intClkGen_hP3,	 // Interp Clock Generator - Clk3 High Period    125	
			input [11:0] intClkGen_lP4,	 // Interp Clock Generator - Clk4 Low Period     313	
			input [11:0] intClkGen_hP4,	 // Interp Clock Generator - Clk4 High Period    625
			input [31:0] adapt_weight,     // Adaptive Filter - Weight mu (4.28) 26844
			input [15:0] adapt_pTh,		    // Adaptive Filter - Positive Threshold (4.12) 2048
			input [15:0] adapt_nTh,		    // Adaptive Filter - Negative Threshold (4.12) -2048
			output [14:0] fir_memory_s2_address,	
			output fir_memory_s2_clken,		
			input [31:0] fir_memory_s2_readdata,	
			output fir_memory_clk2_clk,
			output [4:0] 	interpo_4_0_s2_address,	
			output 			interpo_4_0_s2_clken,		
			input  [31:0]	interpo_4_0_s2_readdata,	
			output 			interpo_4_0_clk2_clk,
			output [5:0] 	interpo_5_0_s2_address, 		
			output 			interpo_5_0_s2_clken,			
			input  [31:0]	interpo_5_0_s2_readdata,		
			output 			interpo_5_0_clk2_clk,			
			output [5:0] 	interpo_5_1_s2_address,		
			output 			interpo_5_1_s2_clken,			
			input  [31:0]	interpo_5_1_s2_readdata,		
			output 			interpo_5_1_clk2_clk,			
			output [5:0] 	interpo_5_2_s2_address, 		
			output 			interpo_5_2_s2_clken,			
			input  [31:0]	interpo_5_2_s2_readdata,		
			output 			interpo_5_2_clk2_clk,			
			output [5:0] 	interpo_5_3_s2_address, 		
			output 			interpo_5_3_s2_clken,			
			input  [31:0]	interpo_5_3_s2_readdata,		
			output 			interpo_5_3_clk2_clk,			
			output [8:0]  adapt_fir_mem_s2_address,    
			output        adapt_fir_mem_s2_write,      
			output [31:0] adapt_fir_mem_s2_writedata,  
			output        adapt_fir_mem_clk2_clk      
			
	);

reg [15:0] sGamma;
reg [15:0] sGamma_b;
reg [15:0] sMic;
reg [15:0] sMic_b;

wire [15:0] sOutput1;
wire [15:0] sOutput2;

assign HSMC_DA = sOutput1[13:0];
assign HSMC_DB = sOutput2[13:0];

micFilter micFilter_inst(	
			.adj 						(adj),					//Coefficient update halt input bit (low = stop update)
			.clk_in 					(clk),						//Clock input (nom. 25 MHz)
			.cntl						(cntl),
			.clk_outp 				(open),						//Clock output
			.gamma 					(sGamma),					//Detector signal input s(k)
			.mic 						(sMic),						//Mechanical sensor signal input v(q)
			.rst 						(rst),						//Synchronous reset input
			.output1 				(sOutput1),				//Filter output y(k)
			.output2					(sOutput2),
			.output1_sel			(output1_sel),
			.output2_sel         (output2_sel),
			.bypass_sel          (bypass_sel),
			.sub_factor				(sub_factor),
			.delay_lenght 			(delay_lenght),
			.DownSampleMult      (DownSampleMult),
			.adapt_weight    		(adapt_weight),  
			.adapt_pTh	     		(adapt_pTh),		 
			.adapt_nTh	     		(adapt_nTh),	
			.fir_memory_s2_address		(fir_memory_s2_address),	 			
			.fir_memory_s2_clken			(fir_memory_s2_clken),		
			.fir_memory_s2_readdata		(fir_memory_s2_readdata),	
			.fir_memory_clk2_clk			(fir_memory_clk2_clk),
			.interpo_4_0_s2_address		(interpo_4_0_s2_address),	
			.interpo_4_0_s2_clken		(interpo_4_0_s2_clken),	
			.interpo_4_0_s2_readdata	(interpo_4_0_s2_readdata),
			.interpo_4_0_clk2_clk		(interpo_4_0_clk2_clk),		
			.interpo_5_0_s2_address		(interpo_5_0_s2_address),	
			.interpo_5_0_s2_clken		(interpo_5_0_s2_clken),	
			.interpo_5_0_s2_readdata	(interpo_5_0_s2_readdata),
			.interpo_5_0_clk2_clk		(interpo_5_0_clk2_clk),	
			.interpo_5_1_s2_address		(interpo_5_1_s2_address),	
			.interpo_5_1_s2_clken		(interpo_5_1_s2_clken),	
			.interpo_5_1_s2_readdata	(interpo_5_1_s2_readdata),
			.interpo_5_1_clk2_clk		(interpo_5_1_clk2_clk),	
			.interpo_5_2_s2_address		(interpo_5_2_s2_address),	
			.interpo_5_2_s2_clken		(interpo_5_2_s2_clken),	
			.interpo_5_2_s2_readdata	(interpo_5_2_s2_readdata),
			.interpo_5_2_clk2_clk		(interpo_5_2_clk2_clk),	
			.interpo_5_3_s2_address		(interpo_5_3_s2_address),	
			.interpo_5_3_s2_clken		(interpo_5_3_s2_clken),	
			.interpo_5_3_s2_readdata	(interpo_5_3_s2_readdata),
			.interpo_5_3_clk2_clk		(interpo_5_3_clk2_clk),
			.adapt_fir_mem_s2_address    (adapt_fir_mem_s2_address),  
			.adapt_fir_mem_s2_write      (adapt_fir_mem_s2_write),   
			.adapt_fir_mem_s2_writedata  (adapt_fir_mem_s2_writedata),
			.adapt_fir_mem_clk2_clk      (adapt_fir_mem_clk2_clk)
			
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