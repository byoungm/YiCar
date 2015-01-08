// Interrupt.c

#include "interrupt.h"

void checkInterrupt()
{
    // Interupt Code Goes Here
    if ( INTCONbits.TMR0IF ) // Timer 0 Interrupt
    {
        motorControl_TMR0Interrupt();
    }
}

#pragma code ADC_INT=0x08 //At interrupt, code jumps here
void interruptHappened ()
{   
    _asm
    GOTO checkInterrupt
    _endasm
    //not enought space in memory
}