/*
 * EXTI.h
 *
 *  Created on: Dec 29, 2021
 *      Author: Radwa_Saeed
 * 	Edited on: Nov 25, 2023
 * 		By: rfAbedi
 */

#ifndef INC_EXTI_H_
#define INC_EXTI_H_

#include "stm32f401xe.h"

/* EXTI options: */
#define EXTI0 0
#define EXTI1 1
#define EXTI2 2
#define EXTI3 3
#define EXTI4 4
#define EXTI5 5
#define EXTI6 6
#define EXTI7 7
#define EXTI8 8
#define EXTI9 9
#define EXTI10 10
#define EXTI11 11
#define EXTI12 12
#define EXTI13 13
#define EXTI14 14
#define EXTI15 15


/* state options: */
#define FALLING 1
#define RISSING 2
#define FALLING_RISSING 3


void EXTI_EnableClock(void);
void EXIT_INIT(unsigned int Port, int EXTx, char state);
void NVIC_ConfigIRQ(int IRQn, int priority);

#endif /* INC_EXTI_H_ */
