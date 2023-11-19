#include "GPIO.h"
#include "EXTI.h"
#include "stm32f401xe.h"

static int COEFS[10];
static const unsigned char sevenSegHex[10] = {0x3F, 0x06, 0x5B, 0x4F, 0x66,0x6D, 0x7D, 0x07, 0x7F, 0x6F};
static volatile int button_counter = 0;
static int N;
static int M;

int pascal(int row, int col);
void KHPA(int n);
int KHEXT(int n, int m);

unsigned char bin_to_bcd(int bin);

void EXTI4_IRQHandler(void);

int main(void) {
	// Init SevenSegment
	GPIO_EnableClock(A);
	GPIO_EnableClock(C);
	for (char i = 0; i < 7; i++) {
		GPIO_Init(A, i, OUTPUT);
	}
	for (char i = 0; i < 7; i++) {
		GPIO_Init(C, i, OUTPUT);
	}

	// Init DipSwitch
	GPIO_EnableClock(B);
	for (char i = 0; i < 4; i++) {
		GPIO_Init(B, i, INPUT);
	}

	// Init UserButton
	GPIO_Init(B, 4, INPUT);
	
	// Port C EXTI
	EXTI_EnableClock();
	EXIT_INIT(B, EXTI4, RISSING);
		
	//Enable Interrupt
	__enable_irq();
	NVIC_ConfigIRQ(EXTI4_IRQn);


	// Clear SevenSeg Display
	for (char i = 0; i < 7; i++) {
		GPIO_WritePin(A, i, (sevenSegHex[0] >> i) & 0x01);
	}
	for (char i = 0; i < 7; i++) {
		GPIO_WritePin(C, i, (sevenSegHex[0] >> i) & 0x01);
	}

	while(1);
}

int pascal(int row, int col) {
    if (col == 1 || row == col)
        return 1;
    else
        return pascal(row - 1, col) + pascal(row - 1, col - 1);
}

void KHPA(int n) {
    for (int i = 1; i <= n; i++) {
        COEFS[i] = pascal(n, i);
    }
}

int KHEXT(int n, int m) {
    KHPA(n);
    return COEFS[m];
}

unsigned char bin_to_bcd(int bin) {
	unsigned char bcd = 0x00;
	int bin_temp = bin;

	for (int i = 0; i < 2; i++) {
		bcd |= (bin_temp % 10  << 4*(i));
		bin_temp /= 10;
	}
		
	return bcd;
}

void EXTI4_IRQHandler(void) {
	EXTI->PR |= EXTI_PR_PR4;
	NVIC_ClearPendingIRQ(EXTI4_IRQn);
	
	if ((GPIO_ReadPin(B, 4) == 0x01) && button_counter == 0) {
		N = 0;
		for(char i = 0; i < 4; i++) {
			N |= (GPIO_ReadPin(B, i) << i);
		}


		for (char i = 0; i < 7; i++) {
			GPIO_WritePin(A, i, (sevenSegHex[bin_to_bcd(N)] >> i) & 0x01);
		}

		button_counter++;
	} else if ((GPIO_ReadPin(B, 4) == 0x01) && button_counter == 1) {
		M = 0;
		for(char i = 0; i < 4; i++) {
			M |= (GPIO_ReadPin(B, i) << i);
		}

		for (char i = 0; i < 7; i++) {
			GPIO_WritePin(C, i, (sevenSegHex[bin_to_bcd(M)] >> i) & 0x01);
		}

		button_counter++;
	} else if ((GPIO_ReadPin(B, 4) == 0x01) && button_counter == 2) {
		char bcd = bin_to_bcd(KHEXT(N, M));

		int digit_1 = bcd & 0x0F;
		int digit_2 = (bcd >> 4) & 0x0F;

		for (char i = 0; i < 7; i++) {
			GPIO_WritePin(A, i, (sevenSegHex[digit_1] >> i) & 0x01);
		}
		for (char i = 0; i < 7; i++) {
			GPIO_WritePin(C, i, (sevenSegHex[digit_2] >> i) & 0x01);
		}

		button_counter = 0;
	}
}
