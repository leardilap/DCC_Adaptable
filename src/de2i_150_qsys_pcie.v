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
//   DE2i-150 Development Board + DCC(AD/DA Data Conversion Card)
//
//   user interface define
//     LEDG :
//        LEDG[0] 	  --> 
//        LEDG[1] 	  --> 
//        LEDG[2] 	  --> 
//        LEDG[3] 	  --> 
//        LEDG[4] 	  --> 
//        LEDG[5] 	  --> 
//        LEDG[6] 	  --> 
//        LEDG[7] 	  --> 
//
//		 LEDR :
//        LEDR[0] 	  --> Heart_beat
//
//      SW : 
//        SW[0] --> ADC DFS(Data Format Select)
//        SW[1] --> ADC DCS(Duty Cycle Stabilizer Select)
//        SW[2] --> 
//		    SW[3] --> 
//		    SW[4] --> 
//
//      KEY : 
//        KEY[0]   --> 
//        KEY[1]   --> 
//        KEY[2]   --> 
//        KEY[3]   --> 
//
// ============================================================================
// Revision History:
// ============================================================================
//   Ver.: |Author:   		|Mod. Date:    |Changes Made:
//   V0.1  |Luis Ardila  	|26/09/15      |Created from PCIe_Fundamental Example
// ============================================================================

`define ENABLE_PCIE
`define DATE 32'h06101504

module de2i_150_qsys_pcie(

							///////////CLOCK2/////////////
							CLOCK2_50,

							/////////CLOCK3/////////
							CLOCK3_50,

							/////////CLOCK/////////
							CLOCK_50,

							/////////DRAM/////////
							DRAM_ADDR,
							DRAM_BA,
							DRAM_CAS_N,
							DRAM_CKE,
							DRAM_CLK,
							DRAM_CS_N,
							DRAM_DQ,
							DRAM_DQM,
							DRAM_RAS_N,
							DRAM_WE_N,

							/////////EEP/////////
							EEP_I2C_SCLK,
							EEP_I2C_SDAT,

							/////////ENET/////////
							ENET_GTX_CLK,
							ENET_INT_N,
							ENET_LINK100,
							ENET_MDC,
							ENET_MDIO,
							ENET_RST_N,
							ENET_RX_CLK,
							ENET_RX_COL,
							ENET_RX_CRS,
							ENET_RX_DATA,
							ENET_RX_DV,
							ENET_RX_ER,
							ENET_TX_CLK,
							ENET_TX_DATA,
							ENET_TX_EN,
							ENET_TX_ER,

							/////////FAN/////////
							FAN_CTRL,

							/////////FL/////////
							FL_CE_N,
							FL_OE_N,
							FL_RY,
							FL_WE_N,
							FL_WP_N,
							FL_RESET_N,
							/////////FS/////////
							FS_DQ,
							FS_ADDR,
							/////////GPIO/////////
							GPIO,

							/////////G/////////
							G_SENSOR_INT1,
							G_SENSOR_SCLK,
							G_SENSOR_SDAT,

							/////////HEX/////////
							HEX0,
							HEX1,
							HEX2,
							HEX3,
							HEX4,
							HEX5,
							HEX6,
							HEX7,

							//////// HSMC //////////
							HSMC_SCL,				
							HSMC_SDA,					
							HSMC_AD_SCLK,
							HSMC_AD_SDIO,
							HSMC_ADA_D,
							HSMC_ADA_DCO,
							HSMC_ADA_OE,
							HSMC_ADA_OR,
							HSMC_ADA_SPI_CS,
							HSMC_ADB_D,
							HSMC_ADB_DCO,
							HSMC_ADB_OE,
							HSMC_ADB_OR,
							HSMC_ADB_SPI_CS,
							HSMC_AIC_BCLK,
							HSMC_AIC_DIN,
							HSMC_AIC_DOUT,
							HSMC_AIC_LRCIN,
							HSMC_AIC_LRCOUT,
							HSMC_AIC_SPI_CS,
							HSMC_AIC_XCLK,
							HSMC_CLKIN1,
							HSMC_CLKOUT0,
							HSMC_DA,
							HSMC_DB,
							HSMC_FPGA_CLK_A_N,
							HSMC_FPGA_CLK_A_P,
							HSMC_FPGA_CLK_B_N,
							HSMC_FPGA_CLK_B_P,
							HSMC_J1_152,
							HSMC_XT_IN_N,
							HSMC_XT_IN_P, 

							/////////I2C/////////
							I2C_SCLK,
							I2C_SDAT,

							/////////IRDA/////////
							IRDA_RXD,

							/////////KEY/////////
							KEY,

							/////////LCD/////////
							LCD_DATA,
							LCD_EN,
							LCD_ON,
							LCD_RS,
							LCD_RW,

							/////////LEDG/////////
							LEDG,

							/////////LEDR/////////
							LEDR,

							/////////PCIE/////////
`ifdef ENABLE_PCIE

							PCIE_PERST_N,
							PCIE_REFCLK_P,
							PCIE_RX_P,
							PCIE_TX_P,
							PCIE_WAKE_N,
`endif 
							/////////SD/////////
							SD_CLK,
							SD_CMD,
							SD_DAT,
							SD_WP_N,

							/////////SMA/////////
							SMA_CLKIN,
							SMA_CLKOUT,

							/////////SSRAM/////////
							SSRAM_ADSC_N,
							SSRAM_ADSP_N,
							SSRAM_ADV_N,
							SSRAM_BE,
							SSRAM_CLK,
							SSRAM_GW_N,
							SSRAM_OE_N,
							SSRAM_WE_N,
							SSRAM0_CE_N,
							SSRAM1_CE_N,							
							/////////SW/////////
							SW,

							/////////TD/////////
							TD_CLK27,
							TD_DATA,
							TD_HS,
							TD_RESET_N,
							TD_VS,

							/////////UART/////////
							UART_CTS,
							UART_RTS,
							UART_RXD,
							UART_TXD,

							/////////VGA/////////
							VGA_B,
							VGA_BLANK_N,
							VGA_CLK,
							VGA_G,
							VGA_HS,
							VGA_R,
							VGA_SYNC_N,
							VGA_VS,
);

//=======================================================
//  PORT declarations
//=======================================================

							///////////CLOCK2/////////////

input                                              CLOCK2_50;

///////// CLOCK3 /////////
input                                              CLOCK3_50;

///////// CLOCK /////////
input                                              CLOCK_50;

///////// DRAM /////////
output                        [12:0]               DRAM_ADDR;
output                        [1:0]                DRAM_BA;
output                                             DRAM_CAS_N;
output                                             DRAM_CKE;
output                                             DRAM_CLK;
output                                             DRAM_CS_N;
inout                         [31:0]               DRAM_DQ;
output                        [3:0]                DRAM_DQM;
output                                             DRAM_RAS_N;
output                                             DRAM_WE_N;

///////// EEP /////////
output                                             EEP_I2C_SCLK;
inout                                              EEP_I2C_SDAT;

///////// ENET /////////
output                                             ENET_GTX_CLK;
input                                              ENET_INT_N;
input                                              ENET_LINK100;
output                                             ENET_MDC;
inout                                              ENET_MDIO;
output                                             ENET_RST_N;
input                                              ENET_RX_CLK;
input                                              ENET_RX_COL;
input                                              ENET_RX_CRS;
input                         [3:0]                ENET_RX_DATA;
input                                              ENET_RX_DV;
input                                              ENET_RX_ER;
input                                              ENET_TX_CLK;
output                        [3:0]                ENET_TX_DATA;
output                                             ENET_TX_EN;
output                                             ENET_TX_ER;

///////// FAN /////////
inout                                              FAN_CTRL;

///////// FL /////////
output                                             FL_CE_N;
output                                             FL_OE_N;
input                                              FL_RY;
output                                             FL_WE_N;
output                                             FL_WP_N;
output                                             FL_RESET_N;
///////// FS /////////
inout                         [31:0]               FS_DQ;
output                        [26:0]               FS_ADDR;
///////// GPIO /////////
inout                         [35:0]               GPIO;

///////// G /////////
input                                              G_SENSOR_INT1;
output                                             G_SENSOR_SCLK;
inout                                              G_SENSOR_SDAT;

///////// HEX /////////
output                        [6:0]                HEX0;
output                        [6:0]                HEX1;
output                        [6:0]                HEX2;
output                        [6:0]                HEX3;
output                        [6:0]                HEX4;
output                        [6:0]                HEX5;
output                        [6:0]                HEX6;
output                        [6:0]                HEX7;

//////////// HSMC //////////
output 						HSMC_SCL;
inout 						HSMC_SDA;	
inout		          		HSMC_AD_SCLK;
inout		          		HSMC_AD_SDIO;
input		   [13:0]		HSMC_ADA_D;
input		          		HSMC_ADA_DCO;
output		       		HSMC_ADA_OE;
input		          		HSMC_ADA_OR;
output		        		HSMC_ADA_SPI_CS;
input		   [13:0]		HSMC_ADB_D;
input		          		HSMC_ADB_DCO;
output		        		HSMC_ADB_OE;
input		          		HSMC_ADB_OR;
output		        		HSMC_ADB_SPI_CS;
inout		          		HSMC_AIC_BCLK;
output		        		HSMC_AIC_DIN;
input		          		HSMC_AIC_DOUT;
inout		          		HSMC_AIC_LRCIN;
inout		          		HSMC_AIC_LRCOUT;
output		        		HSMC_AIC_SPI_CS;
output		        		HSMC_AIC_XCLK;
input		          		HSMC_CLKIN1;
output		        		HSMC_CLKOUT0;
output		[13:0]		HSMC_DA;
output		[13:0]		HSMC_DB;
output	          		HSMC_FPGA_CLK_A_N;
output	          		HSMC_FPGA_CLK_A_P;
output	          		HSMC_FPGA_CLK_B_N;
output	          		HSMC_FPGA_CLK_B_P;
inout		          		HSMC_J1_152;
input		          		HSMC_XT_IN_N;
input		          		HSMC_XT_IN_P; 

///////// I2C /////////
output                                             I2C_SCLK;
inout                                              I2C_SDAT;

///////// IRDA /////////
input                                              IRDA_RXD;

///////// KEY /////////
input                         [3:0]                KEY;

///////// LCD /////////
inout                         [7:0]                LCD_DATA;
output                                             LCD_EN;
output                                             LCD_ON;
output                                             LCD_RS;
output                                             LCD_RW;

///////// LEDG /////////
output                        [8:0]                LEDG;

///////// LEDR /////////
output                        [17:0]               LEDR;

///////// PCIE /////////
`ifdef ENABLE_PCIE
input                                              PCIE_PERST_N;
input                                              PCIE_REFCLK_P;
input                         [0:0]                PCIE_RX_P;
output                        [0:0]                PCIE_TX_P;
output                                             PCIE_WAKE_N;
`endif 
///////// SD /////////
output                                             SD_CLK;
inout                                              SD_CMD;
inout                         [3:0]                SD_DAT;
input                                              SD_WP_N;

///////// SMA /////////
input                                              SMA_CLKIN;
output                                             SMA_CLKOUT;

///////// SSRAM /////////
output                                             SSRAM_ADSC_N;
output                                             SSRAM_ADSP_N;
output                                             SSRAM_ADV_N;
output                         [3:0]                SSRAM_BE;
output                                             SSRAM_CLK;
output                                             SSRAM_GW_N;
output                                             SSRAM_OE_N;
output                                             SSRAM_WE_N;
output                                             SSRAM0_CE_N;
output                                             SSRAM1_CE_N;

///////// SW /////////
input                         [17:0]               SW;

///////// TD /////////
input                                              TD_CLK27;
input                         [7:0]                TD_DATA;
input                                              TD_HS;
output                                             TD_RESET_N;
input                                              TD_VS;

///////// UART /////////
input                                             UART_CTS;
output                                              UART_RTS;
input                                              UART_RXD;
output                                             UART_TXD;

///////// VGA /////////
output                        [7:0]                VGA_B;
output                                             VGA_BLANK_N;
output                                             VGA_CLK;
output                        [7:0]                VGA_G;
output                                             VGA_HS;
output                        [7:0]                VGA_R;
output                                             VGA_SYNC_N;
output                                             VGA_VS;

//=======================================================
//  REG/WIRE declarations
//=======================================================

wire reset_n;
wire hb_50;


// MicFilter
// assign for ADC control signal
assign	HSMC_AD_SCLK			= SW[0];			// (DFS)Data Format Select
assign	HSMC_AD_SDIO			= SW[1];			// (DCS)Duty Cycle Stabilizer Select
assign	HSMC_ADA_OE				= 1'b0;				// enable ADA output
assign	HSMC_ADA_SPI_CS		= 1'b1;				// disable ADA_SPI_CS (CSB)
assign	HSMC_ADB_OE				= 1'b0;				// enable ADB output
assign	HSMC_ADB_SPI_CS		= 1'b1;				// disable ADB_SPI_CS (CSB)
assign 	HSMC_FPGA_CLK_A_N		= sCLK25_180;
assign 	HSMC_FPGA_CLK_A_P		= ~sCLK25_180;
assign 	HSMC_FPGA_CLK_B_N		= sCLK25_270;
assign 	HSMC_FPGA_CLK_B_P		= ~sCLK25_270;
// CLK

wire sCLK25_0;
wire sCLK25_180;
wire sCLK25_270;

// MEM
wire [14:0] fir_memory_s2_address;                      //              fir_memory_s2.address
wire        fir_memory_s2_clken;                        //                           .clken
wire [31:0] fir_memory_s2_readdata;                     //                           .readdata
wire        fir_memory_clk2_clk;                        //            fir_memory_clk2.clk

wire [4:0]  interpo_4_0_s2_address;                       //               interpo_4_s2.address
wire        interpo_4_0_s2_clken;                         //                           .clken
wire [31:0] interpo_4_0_s2_readdata;                      //                           .readdata
wire        interpo_4_0_clk2_clk;                         //             interpo_4_clk2.clk

wire [5:0]  interpo_5_0_s2_address;                     //             interpo_5_0_s2.address
wire        interpo_5_0_s2_clken;                       //                           .clken
wire [31:0] interpo_5_0_s2_readdata;                    //                           .readdata
wire        interpo_5_0_clk2_clk;                      //           interpo_5_0_clk2.clk

wire [5:0]  interpo_5_1_s2_address;                     //             interpo_5_1_s2.address
wire        interpo_5_1_s2_clken;                       //                           .clken
wire [31:0] interpo_5_1_s2_readdata;                    //                           .readdata
wire        interpo_5_1_clk2_clk;                       //           interpo_5_1_clk2.clk

wire [5:0]  interpo_5_2_s2_address;                     //             interpo_5_2_s2.address
wire        interpo_5_2_s2_clken;                       //                           .clken
wire [31:0] interpo_5_2_s2_readdata;                    //                           .readdata
wire        interpo_5_2_clk2_clk;                       //           interpo_5_2_clk2.clk

wire [5:0]  interpo_5_3_s2_address;                     //             interpo_5_3_s2.address
wire        interpo_5_3_s2_clken;                      //                           .clken
wire [31:0] interpo_5_3_s2_readdata;                    //                           .readdata
wire        interpo_5_3_clk2_clk;                      //           interpo_5_3_clk2.clk

wire [8:0]  adapt_fir_mem_s2_address;                   //           adapt_fir_mem_s2.address
wire        adapt_fir_mem_s2_clken;                     //                           .clken
wire [31:0] adapt_fir_mem_s2_readdata;                  //                           .readdata
wire        adapt_fir_mem_clk2_clk;                     //         adapt_fir_mem_clk2.clk

wire [31:0] micfilter_cntl_export;                      //             micfilter_cntl.export
wire       micfilter_rst_export;                        //              micfilter_rst.export
//=======================================================
//  Structural coding
//=======================================================
assign reset_n = 1'b1;
assign PCIE_WAKE_N = 1'b1;	 // 07/30/2013, pull-high to avoid system reboot after power off

assign LEDG[7:4] = 4'b1010;

heart_beat	heart_beat_clk50(
	.clk(CLOCK_50),
	.led(hb_50)
);
assign LEDR[0] = hb_50;

	

 
    de2i_150_qsys u0 (
         .clk_clk                            	(CLOCK_50),                                    //                        clk.clk
         .reset_reset_n                      	(reset_n),                              //                      reset.reset_n
         .pcie_ip_refclk_export              	(PCIE_REFCLK_P),                      //             pcie_ip_refclk.export
         .pcie_ip_pcie_rstn_export           	(PCIE_PERST_N),                   //          pcie_ip_pcie_rstn.export
         .pcie_ip_rx_in_rx_datain_0          	(PCIE_RX_P[0]),                  //              pcie_ip_rx_in.rx_datain_0
         .pcie_ip_tx_out_tx_dataout_0        	(PCIE_TX_P[0]),                //             pcie_ip_tx_out.tx_dataout_0
         .led_external_connection_export     	(LEDG[3:0]),             //    led_external_connection.export
         .button_external_connection_export  	(KEY),           // button_external_connection.export
		   .fir_memory_s2_address              	(fir_memory_s2_address),       											//              fir_memory_s2.address
		   .fir_memory_s2_chipselect           	(1'b1),    											//                           .chipselect
		   .fir_memory_s2_clken                	(fir_memory_s2_clken),         											//                           .clken
		   .fir_memory_s2_write                	(1'b0),         											//                           .write
		   .fir_memory_s2_readdata             	(fir_memory_s2_readdata),      											//                           .readdata
		   .fir_memory_s2_writedata            	(32'b0),     											//                           .writedata
		   .fir_memory_s2_byteenable           	(3'b0),    											//                           .byteenable
		   .fir_memory_clk2_clk                	(fir_memory_clk2_clk),         											//            fir_memory_clk2.clk
		   .fir_memory_reset2_reset            	(1'b0),     											//          fir_memory_reset2.reset
		   .fir_memory_reset2_reset_req        	(1'b0),  											//                           .reset_req
			.interpo_4_0_s2_address						(interpo_4_0_s2_address),                       //               interpo_4_s2.address
			.interpo_4_0_s2_chipselect					(1'b1),                    //                           .chipselect
			.interpo_4_0_s2_clken						(interpo_4_0_s2_clken),                         //                           .clken
			.interpo_4_0_s2_write						(1'b0),                         //                           .write
			.interpo_4_0_s2_readdata					(interpo_4_0_s2_readdata),                      //                           .readdata
			.interpo_4_0_s2_writedata					(32'b0),                     //                           .writedata
			.interpo_4_0_s2_byteenable					(3'b0),                    //                           .byteenable
			.interpo_4_0_clk2_clk						(interpo_4_0_clk2_clk),                         //             interpo_4_clk2.clk
			.interpo_4_0_reset2_reset					(1'b0),                     //           interpo_4_reset2.reset
			.interpo_4_0_reset2_reset_req				(1'b0),                 //                           .reset_req
			.interpo_5_0_s2_address						(interpo_5_0_s2_address),                       //               interpo_4_s2.address
			.interpo_5_0_s2_chipselect					(1'b1),                    //                           .chipselect
			.interpo_5_0_s2_clken						(interpo_5_0_s2_clken),                         //                           .clken
			.interpo_5_0_s2_write						(1'b0),                         //                           .write
			.interpo_5_0_s2_readdata					(interpo_5_0_s2_readdata),                      //                           .readdata
			.interpo_5_0_s2_writedata					(32'b0),                     //                           .writedata
			.interpo_5_0_s2_byteenable					(3'b0),                    //                           .byteenable
			.interpo_5_0_clk2_clk						(interpo_5_0_clk2_clk),                         //             interpo_4_clk2.clk
			.interpo_5_0_reset2_reset					(1'b0),                     //           interpo_4_reset2.reset
			.interpo_5_0_reset2_reset_req				(1'b0),                 //                           .reset_req
			.interpo_5_1_s2_address						(interpo_5_1_s2_address),                       //               interpo_4_s2.address
			.interpo_5_1_s2_chipselect					(1'b1),                    //                           .chipselect
			.interpo_5_1_s2_clken						(interpo_5_1_s2_clken),                         //                           .clken
			.interpo_5_1_s2_write						(1'b0),                         //                           .write
			.interpo_5_1_s2_readdata					(interpo_5_1_s2_readdata),                      //                           .readdata
			.interpo_5_1_s2_writedata					(32'b0),                     //                           .writedata
			.interpo_5_1_s2_byteenable					(3'b0),                    //                           .byteenable
			.interpo_5_1_clk2_clk						(interpo_5_1_clk2_clk),                         //             interpo_4_clk2.clk
			.interpo_5_1_reset2_reset					(1'b0),                     //           interpo_4_reset2.reset
			.interpo_5_1_reset2_reset_req				(1'b0),                 //                           .reset_req
			.interpo_5_2_s2_address						(interpo_5_2_s2_address),                       //               interpo_4_s2.address
			.interpo_5_2_s2_chipselect					(1'b1),                    //                           .chipselect
			.interpo_5_2_s2_clken						(interpo_5_2_s2_clken),                         //                           .clken
			.interpo_5_2_s2_write						(1'b0),                         //                           .write
			.interpo_5_2_s2_readdata					(interpo_5_2_s2_readdata),                      //                           .readdata
			.interpo_5_2_s2_writedata					(32'b0),                     //                           .writedata
			.interpo_5_2_s2_byteenable					(3'b0),                    //                           .byteenable
			.interpo_5_2_clk2_clk						(interpo_5_2_clk2_clk),                         //             interpo_4_clk2.clk
			.interpo_5_2_reset2_reset					(1'b0),                     //           interpo_4_reset2.reset
			.interpo_5_2_reset2_reset_req				(1'b0),                 //                           .reset_req
			.interpo_5_3_s2_address						(interpo_5_3_s2_address),                       //               interpo_4_s2.address
			.interpo_5_3_s2_chipselect					(1'b1),                    //                           .chipselect
			.interpo_5_3_s2_clken						(interpo_5_3_s2_clken),                         //                           .clken
			.interpo_5_3_s2_write						(1'b0),                         //                           .write
			.interpo_5_3_s2_readdata					(interpo_5_3_s2_readdata),                      //                           .readdata
			.interpo_5_3_s2_writedata					(32'b0),                     //                           .writedata
			.interpo_5_3_s2_byteenable					(3'b0),                    //                           .byteenable
			.interpo_5_3_clk2_clk						(interpo_5_3_clk2_clk),                         //             interpo_4_clk2.clk
			.interpo_5_3_reset2_reset					(1'b0),                     //           interpo_4_reset2.reset
			.interpo_5_3_reset2_reset_req				(1'b0),                 //                           .reset_req
			.adapt_fir_mem_s2_address             	(adapt_fir_mem_s2_address),      //           adapt_fir_mem_s2.address
			.adapt_fir_mem_s2_chipselect         	(1'b1),                        //                           .chipselect
			.adapt_fir_mem_s2_clken                (adapt_fir_mem_s2_clken),        //                           .clken
			.adapt_fir_mem_s2_write                (1'b0),                        //                           .write
			.adapt_fir_mem_s2_readdata             (adapt_fir_mem_s2_readdata),     //                           .readdata
			.adapt_fir_mem_s2_writedata            (32'b0),                       //                           .writedata
			.adapt_fir_mem_s2_byteenable           (3'b0),                        //                           .byteenable
			.adapt_fir_mem_clk2_clk                (adapt_fir_mem_clk2_clk),        //         adapt_fir_mem_clk2.clk
			.adapt_fir_mem_reset2_reset            (1'b0),                        //       adapt_fir_mem_reset2.reset
			.adapt_fir_mem_reset2_reset_req        (1'b0),                 //     //                           .reset_req
			.micfilter_cntl_export                 (micfilter_cntl_export),     //             micfilter_cntl.export
			.micfilter_rst_export                  (micfilter_rst_export)      //              micfilter_rst.export

  );

hex_module hex_module_inst(
			.HDIG			(`DATE),		
			.HEX_0		(HEX0),	
			.HEX_1		(HEX1),	
			.HEX_2		(HEX2),	
			.HEX_3		(HEX3),	
			.HEX_4		(HEX4),	
			.HEX_5		(HEX5),	
			.HEX_6		(HEX6),	
			.HEX_7		(HEX7)	
);

micFilterCLK micFilterCLK_inst(
	.areset			(micfilter_rst_export),
	.inclk0			(CLOCK_50),
	.c0				(sCLK25_0),
	.c1				(sCLK25_180),
	.c2				(sCLK25_270),
);

micFilter_Top micFilter_Top_inst(
			.clk 						(sCLK25_0),						//Clock input (nom. 25 MHz)
			.rst 						(micfilter_rst_export),	 	//Synchronous reset input
			.cntl						(micfilter_cntl_export),
			.HSMC_ADA_D				(HSMC_ADA_D),
			.HSMC_ADA_DCO			(HSMC_ADA_DCO),
			.HSMC_ADB_D				(HSMC_ADB_D),
			.HSMC_ADB_DCO			(HSMC_ADB_DCO),
			.HSMC_DA					(HSMC_DA),
			.HSMC_DB             (HSMC_DB),
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
			.interpo_5_3_clk2_clk		(interpo_5_3_clk2_clk)
	);


endmodule
