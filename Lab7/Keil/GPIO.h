/*
 * GPIO.h
 *
 *  Created on: Nov 24, 2021
 *      Author: ADVINTIC
 * 	Edited on: Nov 18, 2023
 * 		By: rfAbedi
 */

#ifndef INC_GPIO_H_
#define INC_GPIO_H_

#include "stm32f401xe.h"

#define A 0
#define B 1
#define C 2

// Mode Types
#define INPUT ((char)0x00)
#define OUTPUT ((char)0x01)
#define ALTERNATE_FUN ((char)0x02)
#define ANALOG ((char)0x03)

// Output modes
#define PUSH_PULL ((char)0x00)
#define OPEN_DRAIN ((char)0x01)

// Resistor modes
#define NO_PULL_UP_DOWN ((char)0x00)
#define PULL_UP ((char)0x02)
#define PULL_DOWN ((char)0x04)


void GPIO_EnableClock(int Port);
void GPIO_Init(int Port, char PIN_NO, char PIN_Dir, char PIN_PuPd);
void GPIO_WritePin(int Port, char PIN_NO, char Data);
unsigned int GPIO_ReadPin(int PortID, char PIN_NO);

#endif /* INC_GPIO_H_ */
