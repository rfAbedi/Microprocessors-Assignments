/*
 * EXTI.c
 *
 *  Created on: Dec 29, 2021
 *      Author: Radwa_Saeed
 * 	Edited on: Nov 25, 2023
 * 		By: rfAbedi
 */

#include "EXTI.h"

void EXTI_EnableClock(void) {
	RCC->APB2ENR |= RCC_APB2ENR_SYSCFGEN;
}

void EXIT_INIT(unsigned int Port, int EXTx, char state) {
	SYSCFG->EXTICR[(int) EXTx/4] |= (Port << (EXTx%4)*4);
	EXTI->IMR |= (1UL << EXTx);

	if (state == FALLING || state == FALLING_RISSING) {
		EXTI->FTSR |= (1UL << EXTx);
	}
	if (state == RISSING || state == FALLING_RISSING) {
		EXTI->RTSR |= (1UL << EXTx);
	}
}

void NVIC_ConfigIRQ(int IRQn, int priority) {
	NVIC_SetPriority(IRQn, priority);
	NVIC_ClearPendingIRQ(IRQn);
	NVIC_EnableIRQ(IRQn);
}
