// Interrupt.c

#include "interrupt.h"

void checkInterrupt()
{
    // Interrupt Code Goes Here
    

}


#pragma code ADC_INT=0x08 //At interrupt, code jumps here
void interruptHappened ()
{   
    _asm
    GOTO checkInterrupt
    _endasm
    //not enought space in memory
}