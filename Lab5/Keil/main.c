#include <stm32f4xx.h>

#define mask(x) (1UL << (x))

int COEFS[10];

int pascal(int row, int col) {
    if(col == 1 || row == col)
        return 1;
    else
        return pascal(row - 1, col) + pascal(row - 1, col - 1);
}

void KHPA(int n) {
    for (int i = 1; i <= n; i++) {
        COEFS[i] = pascal(n, i);
    }
}

int KHTEXT(int n, int m) {
    KHPA(n);
    return COEFS[m];
}


int main(void) {
	
	
	while(1);
}