
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

#define PCIE_FIR_MEM_ADDR			0x20000
#define PCIE_INTERPO_4_0_ADDR		0x40000
#define PCIE_INTERPO_5_0_ADDR		0x50000
#define PCIE_INTERPO_5_1_ADDR		0x51000
#define PCIE_INTERPO_5_2_ADDR		0x52000
#define PCIE_INTERPO_5_3_ADDR		0x53000
#define PCIE_ADAPT_FIR_MEM_ADDR		0x60000

#define FIR_MEM_SIZE			(4*1024) // 4kB
#define INTERPO_4_0_SIZE		(4*32)	// 128 bytes
#define INTERPO_5_0_SIZE		(4*40)	// 160 bytes
#define INTERPO_5_1_SIZE		(4*40)	// 160 bytes
#define INTERPO_5_2_SIZE		(4*40)	// 160 bytes
#define INTERPO_5_3_SIZE		(4*40)	// 160 bytes
#define ADAPT_FIR_MEM_SIZE		(4*512)	// 2kB

#define FIFO_SIZE			(16*1024) // 2KBx8

typedef enum{
	MENU_LED = 0,
	MENU_BUTTON,
	MENU_FIR_DMA_MEMORY,
	MENU_ADAPT_FIR_MEM,
   MENU_MICFILTER_CNTL,
	MENU_MICFILTER_RST,
	MENU_DMA_FIFO,
	MENU_WRITE_COEFF,
	MENU_READ_COEFF,
	MENU_QUIT = 99
}MENU_ID;

void UI_ShowMenu(void){
	printf("==============================\r\n");
	printf("[%d]: Led control\r\n", MENU_LED);							//from example
	printf("[%d]: Button Status Read\r\n", MENU_BUTTON);				//from example
	printf("[%d]: FIR DMA Memory\r\n", MENU_FIR_DMA_MEMORY);
	printf("[%d]: ADAPT FIR DMA Memory\r\n", MENU_ADAPT_FIR_MEM);
	printf("[%d]: MICFILTER_CNTL\r\n", MENU_MICFILTER_CNTL);
	printf("[%d]: MICFILTER_RST\r\n", MENU_MICFILTER_RST);
	printf("[%d]: DMA Fifo Test\r\n", MENU_DMA_FIFO);					//from example
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

BOOL MICFILTER_RST(PCIE_HANDLE hPCIe){
	BOOL bPass;
	int	Mask;
	
	printf("Please input micFilter rst mask:");
	scanf("%d", &Mask);

	bPass = PCIE_Write32(hPCIe, DEMO_PCIE_USER_BAR, PCIE_MICFILTER_RST_ADDR,(DWORD)Mask);
	if (bPass)
		printf("micFilter rst success, mask=%xh\r\n", Mask);
	else
		printf("micFilter rst failed\r\n");

	
	return bPass;
}


char PAT_GEN(int nIndex){
	char Data;
	Data = nIndex & 0xFF;
	return Data;
}

BOOL FIR_DMA_MEMORY(PCIE_HANDLE hPCIe){
	BOOL bPass=TRUE;
	int i;
	const int nTestSize = FIR_MEM_SIZE;
	const PCIE_LOCAL_ADDRESS LocalAddr = PCIE_FIR_MEM_ADDR;
	char *pWrite;
	char *pRead;
	char szError[256];


	pWrite = (char *)malloc(nTestSize);
	pRead = (char *)malloc(nTestSize);
	if (!pWrite || !pRead){
		bPass = FALSE;
		sprintf(szError, "DMA Memory:malloc failed\r\n");
	}
	

	// init test pattern
	FILE *fileWrite = fopen("FIRwr.txt", "w");
	if (fileWrite == NULL)
	{
    	printf("Error opening file!\n");
    	exit(1);
	}

	for(i=0;i<nTestSize && bPass;i++) {
		*(pWrite+i) = PAT_GEN(i);
		fprintf(fileWrite, "%d\t0x%02X\n", i, (unsigned char)*(pWrite+i));
	}
	fclose(fileWrite);
	// write test pattern
	if (bPass){
		bPass = PCIE_DmaWrite(hPCIe, LocalAddr, pWrite, nTestSize);
		if (!bPass)
			sprintf(szError, "DMA Memory:PCIE_DmaWrite failed\r\n");
	}		
	
	FILE *fileRead = fopen("FIRrd.txt", "w");
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
			for(i=0;i<nTestSize && bPass;i++){
				fprintf(fileRead, "%d\t0x%02X\n", i, (unsigned char)*(pRead+i));
				if (*(pRead+i) != PAT_GEN(i)){
					bPass = FALSE;
					sprintf(szError, "DMA Memory:Read-back verify unmatch, index = %d, read=%xh, expected=%xh\r\n", i, *(pRead+i), PAT_GEN(i));
				}
			}
		}
	}
	fclose(fileRead);

	// free resource
	if (pWrite)
		free(pWrite);
	if (pRead)
		free(pRead);
	
	if (!bPass)
		printf("%s", szError);
	else
		printf("DMA-Memory (Size = %d byes) pass\r\n", nTestSize);


	return bPass;
}

BOOL INTERPO(PCIE_HANDLE hPCIe, const int nTestSize, const PCIE_LOCAL_ADDRESS LocalAddr) {
	BOOL bPass=TRUE;
	int i;
	
	char *pWrite;
	char *pRead;
	char szError[256];
	char *wrName;
   char *rdName;
	switch(LocalAddr){
		case 0x40000:
			wrName = "INT4_0_wr.txt";
			rdName = "INT4_0_rd.txt";
			break;
		case 0x50000:
			wrName = "INT5_0_wr.txt";
			rdName = "INT5_0_rd.txt";
			break;
		case 0x51000:
			wrName = "INT5_1_wr.txt";
			rdName = "INT5_1_rd.txt";
			break;
		case 0x52000:
			wrName = "INT5_2_wr.txt";
			rdName = "INT5_2_rd.txt";
			break;
		case 0x53000:
			wrName = "INT5_3_wr.txt";
			rdName = "INT5_3_rd.txt";
			break;
		default:
			printf("Other Address");
	}

	pWrite = (char *)malloc(nTestSize);
	pRead = (char *)malloc(nTestSize);
	if (!pWrite || !pRead){
		bPass = FALSE;
		sprintf(szError, "DMA Memory:malloc failed\r\n");
	}
	

	// init test pattern
	FILE *fileWrite = fopen(wrName, "w");
	if (fileWrite == NULL)
	{
    	printf("Error opening file!\n");
    	exit(1);
	}

	for(i=0;i<nTestSize && bPass;i++) {
		*(pWrite+i) = PAT_GEN(i);
		fprintf(fileWrite, "%d\t0x%02X\n", i, (unsigned char)*(pWrite+i));
	}
	fclose(fileWrite);
	// write test pattern
	if (bPass){
		bPass = PCIE_DmaWrite(hPCIe, LocalAddr, pWrite, nTestSize);
		if (!bPass)
			sprintf(szError, "DMA Memory:PCIE_DmaWrite failed\r\n");
	}		
	
	FILE *fileRead = fopen(rdName, "w");
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
			for(i=0;i<nTestSize && bPass;i++){
				fprintf(fileRead, "%d\t0x%02X\n", i, (unsigned char)*(pRead+i));
				if (*(pRead+i) != PAT_GEN(i)){
					bPass = FALSE;
					sprintf(szError, "DMA Memory:Read-back verify unmatch, index = %d, read=%xh, expected=%xh\r\n", i, *(pRead+i), PAT_GEN(i));
				}
			}
		}
	}
	fclose(fileRead);

	// free resource
	if (pWrite)
		free(pWrite);
	if (pRead)
		free(pRead);
	
	if (!bPass)
		printf("%s", szError);
	else
		printf("DMA-Memory (Size = %d byes) pass\r\n", nTestSize);


	return bPass;
}

BOOL ADAPT_FIR_DMA_MEMORY(PCIE_HANDLE hPCIe){
	BOOL bPass=TRUE;
	int i;
	const int nTestSize = ADAPT_FIR_MEM_SIZE;
	const PCIE_LOCAL_ADDRESS LocalAddr = PCIE_ADAPT_FIR_MEM_ADDR;
	char *pWrite;
	char *pRead;
	char szError[256];


	pWrite = (char *)malloc(nTestSize);
	pRead = (char *)malloc(nTestSize);
	if (!pWrite || !pRead){
		bPass = FALSE;
		sprintf(szError, "DMA Memory:malloc failed\r\n");
	}
	

	// init test pattern
	FILE *fileWrite = fopen("FIRwr.txt", "w");
	if (fileWrite == NULL)
	{
    	printf("Error opening file!\n");
    	exit(1);
	}

	for(i=0;i<nTestSize && bPass;i++) {
		*(pWrite+i) = PAT_GEN(i);
		fprintf(fileWrite, "%d\t0x%02X\n", i, (unsigned char)*(pWrite+i));
	}
	fclose(fileWrite);
	// write test pattern
	if (bPass){
		bPass = PCIE_DmaWrite(hPCIe, LocalAddr, pWrite, nTestSize);
		if (!bPass)
			sprintf(szError, "DMA Memory:PCIE_DmaWrite failed\r\n");
	}		
	
	FILE *fileRead = fopen("FIRrd.txt", "w");
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
			for(i=0;i<nTestSize && bPass;i++){
				fprintf(fileRead, "%d\t0x%02X\n", i, (unsigned char)*(pRead+i));
				if (*(pRead+i) != PAT_GEN(i)){
					bPass = FALSE;
					sprintf(szError, "DMA Memory:Read-back verify unmatch, index = %d, read=%xh, expected=%xh\r\n", i, *(pRead+i), PAT_GEN(i));
				}
			}
		}
	}
	fclose(fileRead);

	// free resource
	if (pWrite)
		free(pWrite);
	if (pRead)
		free(pRead);
	
	if (!bPass)
		printf("%s", szError);
	else
		printf("DMA-Memory (Size = %d byes) pass\r\n", nTestSize);


	return bPass;
}

BOOL TEST_DMA_FIFO(PCIE_HANDLE hPCIe){
	BOOL bPass=TRUE;
	int i;
	const int nTestSize = FIFO_SIZE;
	const PCIE_LOCAL_ADDRESS FifoID_Write = DEMO_PCIE_FIFO_WRITE_ADDR;
	const PCIE_LOCAL_ADDRESS FifoID_Read = DEMO_PCIE_FIFO_READ_ADDR;
	char *pBuff;
	char szError[256];


	pBuff = (char *)malloc(nTestSize);
	if (!pBuff){
		bPass = FALSE;
		sprintf(szError, "DMA Fifo: malloc failed\r\n");
	}
	

	// init test pattern
	if (bPass){
		for(i=0;i<nTestSize;i++)
			*(pBuff+i) = PAT_GEN(i);
	}

	// write test pattern into fifo
	if (bPass){
		bPass = PCIE_DmaFifoWrite(hPCIe, FifoID_Write, pBuff, nTestSize);
		if (!bPass)
			sprintf(szError, "DMA Fifo: PCIE_DmaFifoWrite failed\r\n");
	}		

	// read back test pattern and verify
	if (bPass){
		memset(pBuff, 0, nTestSize); // reset buffer content
		bPass = PCIE_DmaFifoRead(hPCIe, FifoID_Read, pBuff, nTestSize);

		if (!bPass){
			sprintf(szError, "DMA Fifo: PCIE_DmaFifoRead failed\r\n");
		}else{
			for(i=0;i<nTestSize && bPass;i++){
				if (*(pBuff+i) != PAT_GEN(i)){
					bPass = FALSE;
					sprintf(szError, "DMA Fifo: Read-back verify unmatch, index = %d, read=%xh, expected=%xh\r\n", i, *(pBuff+i), PAT_GEN(i));
				}
			}
		}
	}


	// free resource
	if (pBuff)
		free(pBuff);
	
	if (!bPass)
		printf("%s", szError);
	else
		printf("DMA-Fifo (Size = %d byes) pass\r\n", nTestSize);


	return bPass;
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
			CNTL_Mask = 32;
			break;	
	}

	pWrite = (char *)malloc(nTestSize);

	FILE *fileWrite = fopen(fileName, "r");
	if (fileWrite == NULL)
	{
    	printf("Error opening file!\n");
    	exit(1);
	}
	
	
	for(i=0;i<nTestSize;i++) {
		fscanf(fileWrite, "%d 0x%02X", &addr, &val);
		//printf("ADD: %d \tVAL: 0x%02X\n", addr, val);
		*(pWrite+i) = PAT_GEN(val);
		//printf("%d\t0x%02X\n", i, (unsigned char)*(pWrite+i));
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
			for(i=0;i<nTestSize && bPass;i++){
				fprintf(fileRead, "%d\t0x%02X\n", i, (unsigned char)*(pRead+i));
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
	int i;
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
				case MENU_FIR_DMA_MEMORY:
					FIR_DMA_MEMORY(hPCIE);
					break;
				case MENU_ADAPT_FIR_MEM:
					ADAPT_FIR_DMA_MEMORY(hPCIE);
					break;
				case MENU_MICFILTER_CNTL:
					MICFILTER_CNTL(hPCIE);
					break;
				case MENU_MICFILTER_RST:
					MICFILTER_RST(hPCIE);
					break;
				case MENU_DMA_FIFO:
					TEST_DMA_FIFO(hPCIE);
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
