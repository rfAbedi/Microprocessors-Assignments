#include "LCD.h"
#include "stm32f401xe.h"


int printed_length = 0;


void LCD_print_number(int num) {
	int digits = digit_count(num);
	char* str = (char*)malloc(digits * sizeof(char));
	sprintf(str, "%d", num);
	LCD_print_string(str);
}

void LCD_print_string(char str[]) {
	for(int i=0;; i++) {
		if(str[i] == '\0') break;
		LCD_data(str[i]);
	}
}

int digit_count(int num) {
	int count = 0;
	while (num != 0) {
			count++;
			num /= 10;
	}
	return count;
}


void LCD_clear(void) {
	LCD_command(1);
	printed_length=0;
}

/* Initialize port pins then initialize LCD controller */
void LCD_init(void) {
	PORTS_init();
	delayMs(30); /* initialization sequence */
	LCD_command_noPoll(0x30); /* LCD does not respond to status poll yet*/
	delayMs(10);
	LCD_command_noPoll(0x30);
	delayMs(1);
	LCD_command_noPoll(0x30); /* busy flag cannot be polled before this*/
	LCD_command(0x38); /* set 8-bit data, 2-line, 5x7 font */
	LCD_command(0x06); /* move cursor right after each char */
	LCD_command(0x01); /* clear screen, move cursor to home */
	LCD_command(0x0F); /* turn on display, cursor blinking */
}


void LCD_ready(void) {
	char status;
	/* change to read configuration to poll the status register */
	GPIOC->MODER &= ~0x0000FFFF; /* clear pin mode */
	GPIOB->BSRR = RS << 16; /* RS = 0 for status register */
	GPIOB->BSRR = RW; /* R/W = 1 for read */
		
	do { /* stay in the loop until it is not busy */
	GPIOB->BSRR = EN; /* pulse E high */
	delayMs(0);
	status = GPIOC->IDR; /* read status register */
	GPIOB->BSRR = EN << 16; /* clear E */
	delayMs(0);
	} while (status & 0x80); /* check busy bit */

	/* return to default write configuration */
	GPIOB->BSRR = RW << 16; /* R/W = 0, LCD input */
	GPIOC->MODER |= 0x00005555; /* Port C as output */
}


void LCD_command(unsigned char command) {
	LCD_ready(); /* wait for LCD controller ready */
	GPIOB->BSRR = (RS | RW) << 16; /* RS = 0, R/W = 0 */
	GPIOC->ODR = command; /* put command on data bus */
	GPIOB->BSRR = EN; /* pulse E high */
	delayMs(0);
	GPIOB->BSRR = EN << 16; /* clear E */
}


/* This function is used at the beginning of the initialization *
when the busy bit of the status register is not readable. */
void LCD_command_noPoll(unsigned char command) {
	GPIOB->BSRR = (RS | RW) << 16; /* RS = 0, R/W = 0 */
	GPIOC->ODR = command; /* put command on data bus */
	GPIOB->BSRR = EN; /* pulse E high */
	delayMs(0);
	GPIOB->BSRR = EN << 16; /* clear E */
}


void LCD_data(char data) {
	LCD_ready(); /* wait for LCD controller ready */
	GPIOB->BSRR = RS; /* RS = 1 */
	GPIOB->BSRR = RW << 16; /* R/W = 0 */
	GPIOC->ODR = data; /* put data on data bus */
	GPIOB->BSRR = EN; /*pulse E high */
	delayMs(0);
	GPIOB->BSRR = EN << 16; /* clear E */
	printed_length++;
	if(printed_length == LCD_LENGTH) {
		LCD_command(0xC0);
	}
}


/* delay n milliseconds (16 MHz CPU clock) */
void delayMs(int n) {
	int i;
	for (; n > 0; n--)
	for (i = 0; i < 3195; i++) ;
}





/******************* GPIO Part *******************/

void PORTS_init(void) {
	RCC->AHB1ENR |= 0x06; /* enable GPIOB/C clock */
	/* PB5 for LCD R/S */
	/* PB6 for LCD R/W */
	/* PB7 for LCD EN */
	GPIOB->MODER &= ~0x0000FC00; /* clear pin mode */
	GPIOB->MODER |= 0x00005400; /* set pin output mode */
	GPIOB->BSRR = 0x00C00000; /*turn off EN and R/W */
	
	/* ----------------------------------------------------------- */
	/* This function waits until LCD controller is ready to*/
	/* PC0-PC7 for LCD D0-D7, respectively. */
	GPIOC->MODER &= ~0x0000FFFF; /* clear pin mode */
	GPIOC->MODER |= 0x00005555; /* set pin output mode */
}

/* accept a new command/data before returns.
* It polls the busy bit of the status register of LCD controller. *
In order to read the status register, the data port of the *microcontroller has to change to an input port before reading * the
LCD. The data port of the microcontroller is return to * output port
before the end of this function.
*/
/* ----------------------------------------------------------- */
