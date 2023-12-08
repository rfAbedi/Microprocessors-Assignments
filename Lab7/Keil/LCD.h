#ifndef INC_LCD_H_
#define INC_LCD_H_

#include "stm32f401xe.h"

#define RS 0x20 /* PB5 mask for reg select */
#define RW 0x40 /* PB6 mask for read/write */
#define EN 0x80 /* PB7 mask for enable */
#define LCD_LENGTH 16 

void delayMs(int n);
void LCD_command(unsigned char command);
void LCD_command_noPoll(unsigned char command);
void LCD_data(char data);
void LCD_init(void);
void LCD_ready(void);
int digit_count(int num);
void LCD_print_number(int num);
void LCD_print_string(char str[]);
void LCD_clear(void);

void PORTS_init(void);

#endif /* INC_LCD_H_ */