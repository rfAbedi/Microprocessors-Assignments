void GPIO_Init( unsigned int Port, unsigned int PIN_NO, unsigned int PIN_Dir, unsigned int Default_State)
{
	//enable clock of port
	switch (Port)
	{
		case('A'):
			//configure moder register for pin direction
			switch(PIN_Dir)
			{
				case (INPUT):
						GPIOA->MODER &= ~(0x03 << 2*PIN_NO);
				break;
				case (OUTPUT):
						GPIOA->MODER |= (0x01 << 2*PIN_NO);
				break;
			}// end switch
			//configure default state
			switch(Default_State)
			{
				case(PUSH_PULL):
						GPIOA->OTYPER &= ~(0x01<<PIN_NO);
				break;
				case(OPEN_DRAIN):
						GPIOA->OTYPER |= (0x01<<PIN_NO);
				break;
			}//end switch
		break;
		case('B'):
			//configure moder register for pin direction
			switch(PIN_Dir)
			{
				case (INPUT):
						GPIOB->MODER &= ~(0x03 << 2*PIN_NO);
				break;
				case (OUTPUT):
						GPIOB->MODER |= (0x01 << 2*PIN_NO);
				break;
			}// end switch
			switch(Default_State)
			{
				case(PUSH_PULL):
						GPIOB->OTYPER &= ~(0x01<<PIN_NO);
				break;
				case(OPEN_DRAIN):
						GPIOB->OTYPER |= (0x01<<PIN_NO);
				break;
			}//end switch
		break;
		case('C'):
			RCC->AHB1ENR |= RCC_AHB1ENR_GPIOCEN;
			//configure moder register for pin direction
			switch(PIN_Dir)
			{
				case (INPUT):
					GPIOC->MODER &= ~(0x03 << 2*PIN_NO);
				break;
				case (OUTPUT):
					GPIOC->MODER |= (0x01 << 2*PIN_NO);
				break;
			}// end switch
			switch(Default_State)
			{
				case(PUSH_PULL):
					GPIOC->OTYPER &= ~(0x01<<PIN_NO);
				break;
				case(OPEN_DRAIN):
					GPIOC->OTYPER |= (0x01<<PIN_NO);
				break;
			}//end switch
		break;
	}
}

void GPIO_EnableClock(unsigned int Port)
{
	RCC->AHB1ENR |= *RCC_AHB1ENR_GPIOEN[Port];
	
	switch (Port)
	{
		case ('A'):
			RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN;
		break;
		case ('B'):
			RCC->AHB1ENR |= RCC_AHB1ENR_GPIOBEN;
		break;
		case ('C'):
			RCC->AHB1ENR |= RCC_AHB1ENR_GPIOCEN;
		break;
	}
}