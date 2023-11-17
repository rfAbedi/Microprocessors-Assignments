#include <stdio.h>


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

void KHTEXT(int n, int m) {
    KHPA(n);
    return COEFS[m];
}

