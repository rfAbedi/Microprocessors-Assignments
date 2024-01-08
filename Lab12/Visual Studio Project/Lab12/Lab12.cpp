// Lab12.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <conio.h>
#include <cstdlib>
#include <chrono>
using namespace std::chrono;

void print_array(float* arr, int size, bool is_float) {
    _cprintf_s("[");
    for (int i = 0; i < size; i++) {
        if (is_float) {
            _cprintf_s("%.2f, ", arr[i]);
        }
        else {
            _cprintf_s("%.2E, ", arr[i]);
        }
    }
    _cprintf_s("]\n");
}

int main()
{
    float a, b;
    float y[50];
    float zi1[50], zi2[50], zo1[50], zo2[50];

    _cprintf_s("Enter a: ");
    _cscanf_s("%f", &a);
    _cprintf_s("\n");
    _cprintf_s("Enter b: ");
    _cscanf_s("%f", &b);
    _cprintf_s("\n");

    for (int i = 0; i < 50; i++) {
        y[i] = 0 + (0.2 * i);
    }

    _cprintf_s("y: ");
    print_array(y, 50, true);

    for (int i = 0; i < 50; i++) {
        zi1[i] = y[i]*y[i] - a;
        zi2[i] = y[i]*y[i] + 2 * b;
    }

    _cprintf_s("\nzi1: ");
    print_array(zi1, 50, true);
    _cprintf_s("\nzi2: ");
    print_array(zi2, 50, true);

    auto start = high_resolution_clock::now();

    for (int i = 0; i < 50; i++) {
        zo1[i] = 1 / (2 * zi1[i] * zi2[i]);
    }

    auto stop = high_resolution_clock::now();
    auto duration = duration_cast<microseconds>(stop - start);

    _cprintf_s("\nTime taken by function: %f microseconds", duration.count());
    _cprintf_s("\nzo1: ");
    print_array(zo1, 50, false);
    _cprintf_s("\n");


    start = high_resolution_clock::now();

    __asm {
        mov ecx, 0
    LOOP1:
        movups xmm0, oword ptr zi1[4 * ecx]
        movups xmm1, oword ptr zi2[4 * ecx]

        movups xmm2, xmm0
        mulps xmm2, xmm1
        addps xmm2, xmm2
        rcpps xmm3, xmm2
        movups oword ptr zo2[4 * ecx], xmm3

        add ecx, 4
        cmp ecx, 50
        jl LOOP1
    }

    stop = high_resolution_clock::now();
    duration = duration_cast<microseconds>(stop - start);
    
    _cprintf_s("Time taken by function: %f microseconds", duration.count());
    _cprintf_s("\nzo2: ");
    print_array(zo2, 50, false);
    _cprintf_s("\n");
}

// Run program: Ctrl + F5 or Debug > Start Without Debugging menu
// Debug program: F5 or Debug > Start Debugging menu

// Tips for Getting Started: 
//   1. Use the Solution Explorer window to add/manage files
//   2. Use the Team Explorer window to connect to source control
//   3. Use the Output window to see build output and other messages
//   4. Use the Error List window to view errors
//   5. Go to Project > Add New Item to create new code files, or Project > Add Existing Item to add existing code files to the project
//   6. In the future, to open this project again, go to File > Open > Project and select the .sln file
