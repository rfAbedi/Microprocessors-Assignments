/* p3_2.c: Initialize and display "Hello" on the LCD using 8-bit
data mode. *
* Data pins use Port C; control pins use Port B.
* Polling of the busy bit of the LCD status register is used for
timing. *
* The LCD controller is connected to the Nucleo-F446RE
* board as follows:
*
* PC0-PC7 for LCD D0-D7, respectively.
* PB5 for LCD R/S
* PB6 for LCD R/W
* PB7 for LCD EN
*
* This program was tested with Keil uVision v5.24a with DFP v2.11.0
*/
#include "stm32f4xx.h"
#include "LCD.h"
#include "GPIO.h"
#include "EXTI.h"

int pascal(int row, int col);
void LCD_print_KHPA(int n);
void TIM2_IRQHandler(void);
void EXTI15_10_IRQHandler(void);

float freq = 0.5;

int main(void) {
	LCD_init();
	
	// Init SevenSegment
	GPIO_EnableClock(B);
	GPIO_EnableClock(C);
	
	char i;
	for (i = 5; i < 7; i++) {
		GPIO_Init(B, i, OUTPUT, NO_PULL_UP_DOWN);
	}
	for (i = 0; i < 8; i++) {
		GPIO_Init(C, i, OUTPUT, NO_PULL_UP_DOWN);
	}
	
	// Init UserButton
	GPIO_Init(C, 13, INPUT, PULL_UP);
	
	// Port C EXTI
	EXTI_EnableClock();
	EXIT_INIT(C, EXTI13, FALLING_RISSING);
		
	//Enable Interrupt
	__enable_irq();
	NVIC_ConfigIRQ(EXTI15_10_IRQn, 0);

	
	while(1) {
		__enable_irq();
		/* __disable_irq(); /* global disable IRQs */
		RCC->AHB1ENR |= 1; /* enable GPIOA clock */
		GPIOA->MODER &= ~0x00000C00;
		GPIOA->MODER |= 0x00000400;
		/* setup TIM2 */
		RCC->APB1ENR |= 1; /* enable TIM2 clock */
		TIM2->PSC = 16000 - 1; /* divided by 16000 */
		TIM2->ARR = 1000 / freq - 1; /* divided by 1000 */
		TIM2->CR1 = 1; /* enable counter */
		TIM2->DIER |= 1; /* enable UIE */
		NVIC_EnableIRQ(TIM2_IRQn); /* enable interrupt in NVIC */
		/* __enable_irq(); /* global enable IRQs */
	}
}

int i=1;

void TIM2_IRQHandler(void) {
	TIM2->SR = 0; /* clear UIF */
	LCD_clear();
	LCD_print_KHPA(i);
	i=(i+1)%9 == 0 ? 9:((i+1)%9);
}

void LCD_print_KHPA(int n) {
	for (int i = 1; i <= n; i++) {
		LCD_print_number(pascal(n, i));
		LCD_print_string(" ");
	}
}


int pascal(int row, int col) {
	if (col == 1 || row == col)
		return 1;
	else
		return pascal(row - 1, col) + pascal(row - 1, col - 1);
}


void EXTI15_10_IRQHandler(void) {
	RCC->APB1ENR |= 0; /* disable TIM2 clock */
	EXTI->PR |= EXTI_PR_PR13;
	NVIC_ClearPendingIRQ(EXTI15_10_IRQn);
	if(GPIO_ReadPin(C, 13) == 1) {
		freq = (freq == 1) ? 0.5 : 1;
	}
	TIM2->SR = 0; /* clear UIF */
	RCC->APB1ENR |= 1; /* enable TIM2 clock */

}