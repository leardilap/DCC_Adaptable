
#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include "PCIE.h"


#define DEMO_PCIE_USER_BAR			PCIE_BAR0
#define DEMO_PCIE_IO_LED_ADDR		0x00
#define DEMO_PCIE_IO_BUTTON_ADDR	0x20
#define DEMO_PCIE_FIFO_WRITE_ADDR	0x40
#define DEMO_PCIE_FIFO_STATUS_ADDR	0x60
#define DEMO_PCIE_FIFO_READ_ADDR	0x80

#define PCIE_MICFILTER_CNTL_ADDR	0x100
#define PCIE_MICFILTER_RST_ADDR	0x120

#define PCIE_MICFILTER_ADJUST_ADDR	0x140
#define PCIE_MICFILTER_ADJUST_ADDR	0x140
#define PCIE_MICFILTER_ADJUST_ADDR	0x140
#define PCIE_MICFILTER_ADJUST_ADDR	0x140
#define PCIE_MICFILTER_ADJUST_ADDR	0x140
#define PCIE_MICFILTER_ADJUST_ADDR	0x140
#define PCIE_MICFILTER_ADJUST_ADDR	0x140

#define PCIE_FIR_MEM_ADDR			0x20000
#define PCIE_INTERPO_4_0_ADDR		0x40000
#define PCIE_INTERPO_5_0_ADDR		0x50000
#define PCIE_INTERPO_5_1_ADDR		0x51000
#define PCIE_INTERPO_5_2_ADDR		0x52000
#define PCIE_INTERPO_5_3_ADDR		0x53000
#define PCIE_ADAPT_FIR_MEM_ADDR		0x60000

#define FIR_MEM_SIZE			(4*257) 		// ~1 kB
#define INTERPO_4_0_SIZE		(4*32)	// 128 bytes
#define INTERPO_5_0_SIZE		(4*40)	// 160 bytes
#define INTERPO_5_1_SIZE		(4*40)	// 160 bytes
#define INTERPO_5_2_SIZE		(4*40)	// 160 bytes
#define INTERPO_5_3_SIZE		(4*40)	// 160 bytes
#define ADAPT_FIR_MEM_SIZE		(4*500)	// ~2 kB

#define FIFO_SIZE			(16*1024) // 2KBx8

typedef enum{
	MENU_LED = 0,
	MENU_BUTTON,
   MENU_MICFILTER_CNTL,
	MENU_MICFILTER_RST,
	MENU_MICFILTER_ADJUST,
	MENU_WRITE_COEFF,
	MENU_READ_COEFF,
	MENU_QUIT = 99
}MENU_ID;

void UI_ShowMenu(void){
	printf("==============================\r\n");
	printf("[%d]: Led control\r\n", MENU_LED);							//from example
	printf("[%d]: Button Status Read\r\n", MENU_BUTTON);				//from example
	printf("[%d]: MICFILTER_CNTL\r\n", MENU_MICFILTER_CNTL);
	printf("[%d]: MICFILTER_RST\r\n", MENU_MICFILTER_RST);
	printf("[%d]: MICFILTER_ADJUST\r\n", MENU_MICFILTER_ADJUST);
	printf("[%d]: WRITE COEFF\r\n", MENU_WRITE_COEFF);
	printf("[%d]: READ COEFF\r\n", MENU_READ_COEFF);
	printf("[%d]: Quit\r\n", MENU_QUIT);
	printf("Please input your selection:");
}

int UI_UserSelect(void){
	int nSel;
	scanf("%d",&nSel);
	return nSel;
}


BOOL TEST_LED(PCIE_HANDLE hPCIe){
	BOOL bPass;
	int	Mask;
	
	printf("Please input led control mask:");
	scanf("%d", &Mask);

	bPass = PCIE_Write32(hPCIe, DEMO_PCIE_USER_BAR, DEMO_PCIE_IO_LED_ADDR,(DWORD)Mask);
	if (bPass)
		printf("Led control success, mask=%xh\r\n", Mask);
	else
		printf("Led control failed\r\n");

	
	return bPass;
}

BOOL TEST_BUTTON(PCIE_HANDLE hPCIe){
	BOOL bPass = TRUE;
	DWORD Status;

	bPass = PCIE_Read32(hPCIe, DEMO_PCIE_USER_BAR, DEMO_PCIE_IO_BUTTON_ADDR,&Status);
	if (bPass)
		printf("Button status mask=%xh\r\n", Status);
	else
		printf("Failed to read button status\r\n");

	
	return bPass;
}

BOOL MICFILTER_CNTL(PCIE_HANDLE hPCIe){
	BOOL bPass;
	int	Mask;
	
	printf("Please input micFilter control mask:");
	scanf("%d", &Mask);

	bPass = PCIE_Write32(hPCIe, DEMO_PCIE_USER_BAR, PCIE_MICFILTER_CNTL_ADDR,(DWORD)Mask);
	if (bPass)
		printf("micFilter control success, mask=%xh\r\n", Mask);
	else
		printf("micFilter control failed\r\n");

	
	return bPass;
}

BOOL MICFILTER_RST(PCIE_HANDLE hPCIe, int Mask){
	BOOL bPass;
	
	if (Mask == 55){
	
	printf("Please input micFilter rst mask:");
	scanf("%d", &Mask);
	}
	
	bPass = PCIE_Write32(hPCIe, DEMO_PCIE_USER_BAR, PCIE_MICFILTER_RST_ADDR,(DWORD)Mask);
	if (bPass)
		printf("micFilter rst success, mask=%xh\r\n", Mask);
	else
		printf("micFilter rst failed\r\n");

	
	return bPass;
}

BOOL MICFILTER_ADJUST(PCIE_HANDLE hPCIe, int Mask){
	BOOL bPass;
	
	if (Mask == 55) {
	
	printf("Please input micFilter Adjust mask:");
	scanf("%d", &Mask);
	}
	
	bPass = PCIE_Write32(hPCIe, DEMO_PCIE_USER_BAR, PCIE_MICFILTER_ADJUST_ADDR,(DWORD)Mask);
	if (bPass)
		printf("micFilter Adjust success, mask=%xh\r\n", Mask);
	else
		printf("micFilter Adjust failed\r\n");

	
	return bPass;
}


char PAT_GEN(int nIndex){
	char Data;
	Data = nIndex & 0xFF;
	return Data;
}

BOOL WRITE_COEFF(PCIE_HANDLE hPCIe, int selector){
	BOOL bPass = TRUE;
	int nTestSize;
	char *fileName;
	char szError[256];
	int i;
	int addr;
	unsigned int val;
	int CNTL_Mask;
	char *pWrite;
	PCIE_LOCAL_ADDRESS LocalAddr;

	if (selector == 55) {
		printf("==============================\r\n");
		printf("[%d]: INT4_0\r\n", 0);							
		printf("[%d]: INT5_0\r\n", 1);				
		printf("[%d]: INT5_1\r\n", 2);
		printf("[%d]: INT5_2\r\n", 3);							
		printf("[%d]: INT5_3\r\n", 4);
		printf("[%d]: FIR\r\n", 5);	
		printf("Please input your selection:");
		selector = UI_UserSelect();
	}
	
	switch(selector){
		case 0:
			nTestSize = INTERPO_4_0_SIZE;
			fileName = "INT4_0_wr.txt";
			LocalAddr = PCIE_INTERPO_4_0_ADDR;
			CNTL_Mask = 1;
			break;
		case 1:
			nTestSize = INTERPO_5_0_SIZE;
			fileName = "INT5_0_wr.txt";
			LocalAddr = PCIE_INTERPO_5_0_ADDR;
			CNTL_Mask = 2;
			break;
		case 2:
			nTestSize = INTERPO_5_1_SIZE;
			fileName = "INT5_1_wr.txt";
			LocalAddr = PCIE_INTERPO_5_1_ADDR;
			CNTL_Mask = 4;
			break;
		case 3:
			nTestSize = INTERPO_5_2_SIZE;
			fileName = "INT5_2_wr.txt";
			LocalAddr = PCIE_INTERPO_5_2_ADDR;
			CNTL_Mask = 8;
			break;
		case 4:
			nTestSize = INTERPO_5_3_SIZE;
			fileName = "INT5_3_wr.txt";
			LocalAddr = PCIE_INTERPO_5_3_ADDR;
			CNTL_Mask = 16;
			break;	
		case 5:
			nTestSize = FIR_MEM_SIZE;
			fileName = "FIRwr.txt";
			LocalAddr = PCIE_FIR_MEM_ADDR;
			CNTL_Mask = 32;							// not connected, does not need it
			break;	
	}

	pWrite = (char *)malloc(nTestSize);

	FILE *fileWrite = fopen(fileName, "r");
	if (fileWrite == NULL)
	{
    	printf("Error opening file!\n");
    	exit(1);
	}
	
	
	for(i=0;i<nTestSize/4;i++) {
		fscanf(fileWrite, "%d 0x%08X", &addr, &val);
		*(pWrite+i) = PAT_GEN(val & 0xFF);
		*(pWrite+i+1) = PAT_GEN(val & 0xFF00);
		*(pWrite+i+2) = PAT_GEN(val & 0xFF0000);
		*(pWrite+i+3) = PAT_GEN(val & 0xFF000000);
	}

	// write test pattern
	if (bPass){
		bPass = PCIE_DmaWrite(hPCIe, LocalAddr, pWrite, nTestSize);
		if (!bPass)
			sprintf(szError, "DMA Memory:PCIE_DmaWrite failed\r\n");
	}
	
	// Trigger corresponting CNTL bit
	bPass = PCIE_Write32(hPCIe, DEMO_PCIE_USER_BAR, PCIE_MICFILTER_CNTL_ADDR,(DWORD)CNTL_Mask);
	if (bPass)
		printf("micFilter control success, mask=%xh\r\n", CNTL_Mask);
	else
		printf("micFilter control failed\r\n");

	// CNTL to zero
	CNTL_Mask = 0;
	bPass = PCIE_Write32(hPCIe, DEMO_PCIE_USER_BAR, PCIE_MICFILTER_CNTL_ADDR,(DWORD)CNTL_Mask);
	if (bPass)
		printf("micFilter control success, mask=%xh\r\n", CNTL_Mask);
	else
		printf("micFilter control failed\r\n");
	
	// free resource
	fclose(fileWrite);
	
	if (pWrite)
		free(pWrite);
	
	
	if (!bPass)
		printf("%s", szError);
	else
		printf("DMA-Memory write (Size = %d byes) pass\r\n", nTestSize);

	return bPass;
}

BOOL READ_COEFF(PCIE_HANDLE hPCIe, int selector){
	BOOL bPass = TRUE;
	int nTestSize;
	char *fileName;
	char szError[256];
	int i;
	char *pRead;
	PCIE_LOCAL_ADDRESS LocalAddr;

	if (selector == 55) {
		printf("==============================\r\n");
		printf("[%d]: INT4_0\r\n", 0);							
		printf("[%d]: INT5_0\r\n", 1);				
		printf("[%d]: INT5_1\r\n", 2);
		printf("[%d]: INT5_2\r\n", 3);							
		printf("[%d]: INT5_3\r\n", 4);
		printf("[%d]: FIR\r\n", 5);	
		printf("[%d]: ADAPT_FIR\r\n", 6);
		printf("Please input your selection:");
		selector = UI_UserSelect();
	}
	
	switch(selector){
		case 0:
			nTestSize = INTERPO_4_0_SIZE;
			fileName = "INT4_0_rd.txt";
			LocalAddr = PCIE_INTERPO_4_0_ADDR;
			break;
		case 1:
			nTestSize = INTERPO_5_0_SIZE;
			fileName = "INT5_0_rd.txt";
			LocalAddr = PCIE_INTERPO_5_0_ADDR;
			break;
		case 2:
			nTestSize = INTERPO_5_1_SIZE;
			fileName = "INT5_1_rd.txt";
			LocalAddr = PCIE_INTERPO_5_1_ADDR;
			break;
		case 3:
			nTestSize = INTERPO_5_2_SIZE;
			fileName = "INT5_2_rd.txt";
			LocalAddr = PCIE_INTERPO_5_2_ADDR;
			break;
		case 4:
			nTestSize = INTERPO_5_3_SIZE;
			fileName = "INT5_3_rd.txt";
			LocalAddr = PCIE_INTERPO_5_3_ADDR;
			break;
		case 5:
			nTestSize = FIR_MEM_SIZE;
			fileName = "FIRrd.txt";
			LocalAddr = PCIE_FIR_MEM_ADDR;
			break;	
		case 6:
			nTestSize = ADAPT_FIR_MEM_SIZE;
			fileName = "ADAPT_FIRrd.txt";
			LocalAddr = PCIE_ADAPT_FIR_MEM_ADDR;
			break;		
		
	}

	pRead = (char *)malloc(nTestSize);

	FILE *fileRead = fopen(fileName, "w");
	if (fileRead == NULL)
	{
    	printf("Error opening file!\n");
    	exit(1);
	}

	// read back test pattern and verify
	if (bPass){
		bPass = PCIE_DmaRead(hPCIe, LocalAddr, pRead, nTestSize);

		if (!bPass){
			sprintf(szError, "DMA Memory:PCIE_DmaRead failed\r\n");
		}else{
			for(i=0;i<nTestSize && bPass;i = i + 4){
				fprintf(fileRead, "%d\t0x%02X%02X%02X%02X\n", i/4, (unsigned char)*(pRead+i+3), (unsigned char)*(pRead+i+2), (unsigned char)*(pRead+i+1), (unsigned char)*(pRead+i));
			}
		}
	}
	fclose(fileRead);
	
	if (pRead)
		free(pRead);
	
	
	if (!bPass)
		printf("%s", szError);
	else
		printf("DMA-Memory read (Size = %d byes) pass\r\n", nTestSize);

	return bPass;
}

void init(PCIE_HANDLE hPCIe) 
{
	MICFILTER_RST(hPCIe, 0);
	MICFILTER_ADJUST(hPCIe, 1);
	int i;
	for(i = 0; i < 7; i++) {	// 0 to 6
	READ_COEFF(hPCIe, i);
	}
	for(i = 0; i < 6; i++) {	// 0 to 5
		WRITE_COEFF(hPCIe, i);
	}
}

int main(void)
{
	void *lib_handle;
	PCIE_HANDLE hPCIE;
	BOOL bQuit = FALSE;
	int nSel;

	printf("== Terasic: PCIe Demo Program ==\r\n");

	lib_handle = PCIE_Load();
	if (!lib_handle){
		printf("PCIE_Load failed!\r\n");
		return 0;
	}

	hPCIE = PCIE_Open(0,0,0);
	if (!hPCIE){
		printf("PCIE_Open failed\r\n");
	}else{
		init(hPCIE);
		while(!bQuit){
			UI_ShowMenu();
			nSel = UI_UserSelect();
			switch(nSel){	
				case MENU_LED:
					TEST_LED(hPCIE);
					break;
				case MENU_BUTTON:
					TEST_BUTTON(hPCIE);
					break;
				case MENU_MICFILTER_CNTL:
					MICFILTER_CNTL(hPCIE);
					break;
				case MENU_MICFILTER_RST:
					MICFILTER_RST(hPCIE, 55);
					break;
				case MENU_MICFILTER_ADJUST:
					MICFILTER_ADJUST(hPCIE, 55);
					break;
				case MENU_WRITE_COEFF:
					WRITE_COEFF(hPCIE, 55);
					break;
				case MENU_READ_COEFF:
					READ_COEFF(hPCIE, 55);
					break;
				case MENU_QUIT:
					bQuit = TRUE;
					printf("Bye!\r\n");
					break;
				default:
					printf("Invalid selection\r\n");
			} // switch

		}// while

		PCIE_Close(hPCIE);

	}


	PCIE_Unload(lib_handle);
	return 0;
}
