/*
 * GPIO.C
 *
 *  Created on: Nov 24, 2021
 *      Author: ADVINTIC
 * 	Edited on: Nov 18, 2023
 * 		By: rfAbedi
 */

#include "GPIO.h"
#include "stm32f401xe.h"

static GPIO_TypeDef* GPIO_PORTS[3] = {GPIOA, GPIOB, GPIOC};
static unsigned long RCC_AHB1ENR_GPIOEN[3] = {RCC_AHB1ENR_GPIOAEN, RCC_AHB1ENR_GPIOBEN, RCC_AHB1ENR_GPIOCEN};


void GPIO_EnableClock(int Port) {
	RCC->AHB1ENR |= RCC_AHB1ENR_GPIOEN[Port];
}

void GPIO_Init(int Port, char PIN_NO, char PIN_Dir) {
	switch (PIN_Dir) {
		case (INPUT):
			GPIO_PORTS[Port]->MODER &= ~(0x03 << 2 * PIN_NO);
		break;
		case (OUTPUT):
			GPIO_PORTS[Port]->MODER |= (0x01 << 2 * PIN_NO);
		break;
	}
}

void GPIO_WritePin(int Port, char PIN_NO, char Data) {
	if(Data) {
		GPIO_PORTS[Port]->ODR |= (1<<PIN_NO);
	} else {
		GPIO_PORTS[Port]->ODR &= ~(1<<PIN_NO);
	}
}

unsigned int GPIO_ReadPin(int Port, char PIN_NO) {
	unsigned int data = 0;
	data = (GPIO_PORTS[Port]->IDR & (1 << PIN_NO)) >> PIN_NO;
	return data;
}
