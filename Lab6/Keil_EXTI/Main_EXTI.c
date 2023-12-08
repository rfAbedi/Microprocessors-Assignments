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

void EXTI15_10_IRQHandler(void);

int main(void) {
	// Init SevenSegment
	GPIO_EnableClock(A);
	GPIO_EnableClock(C);
	for (char i = 0; i < 7; i++) {
		GPIO_Init(A, i, OUTPUT, NO_PULL_UP_DOWN);
		GPIO_Init(C, i, OUTPUT, NO_PULL_UP_DOWN);
	}

	// Init DipSwitch
	GPIO_EnableClock(B);
	for (char i = 0; i < 4; i++) {
		GPIO_Init(B, i, INPUT, PULL_DOWN);
	}

	// Init UserButton
	GPIO_Init(C, 13, INPUT, PULL_UP);

	// Port C EXTI
	EXTI_EnableClock();
	EXIT_INIT(C, EXTI13, FALLING_RISSING);
		
	//Enable Interrupt
	__enable_irq();
	NVIC_ConfigIRQ(EXTI15_10_IRQn, 0);


	// Clear SevenSeg Display
	for (char i = 0; i < 7; i++) {
		GPIO_WritePin(A, i, (sevenSegHex[0] >> i) & 0x01);
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

void EXTI15_10_IRQHandler(void) {
	EXTI->PR |= EXTI_PR_PR13;
	NVIC_ClearPendingIRQ(EXTI15_10_IRQn);
	
	if ((GPIO_ReadPin(C, 13) == 0) && button_counter == 0) {
			N = 0;
			for(char i = 0; i < 4; i++) {
				N |= (GPIO_ReadPin(B, i) << i);
			}

			for (char i = 0; i < 7; i++) {
				GPIO_WritePin(A, i, (sevenSegHex[bin_to_bcd(N)] >> i) & 0x01);
			}
			
			button_counter++;
		} else if ((GPIO_ReadPin(C, 13) == 1) && button_counter == 1) {
			M = 0;
			for(char i = 0; i < 4; i++) {
				M |= (GPIO_ReadPin(B, i) << i);
			}

			for (char i = 0; i < 7; i++) {
				GPIO_WritePin(C, i, (sevenSegHex[bin_to_bcd(M)] >> i) & 0x01);
			}
			
			button_counter++;
		} else if ((GPIO_ReadPin(C, 13) == 1) && button_counter == 2) {
			char bcd = bin_to_bcd(KHEXT(N, M));

			int digit_1 = bcd & 0x0F;
			int digit_2 = (bcd >> 4) & 0x0F;

			for (char i = 0; i < 7; i++) {
				GPIO_WritePin(A, i, (sevenSegHex[digit_1] >> i) & 0x01);
				GPIO_WritePin(C, i, (sevenSegHex[digit_2] >> i) & 0x01);
			}

			button_counter = 0;
		}
}
