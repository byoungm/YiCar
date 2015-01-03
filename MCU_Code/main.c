/* 
 * File:   main.c
 * Author: Benjamin
 *
 * Created on April 30, 2013, 5:41 PM
 */

#include "main.h"
#include "stdincludes.h"
#include "lcd.h"
#include "interrupt.h"


// Function Declarations
void mcu_init();

// Global Variables
char lcdString[20];


void main() {

    mcu_init();
    lcd_initDisplay();


    while(1);
    
}


void mcu_init()
{
    // Internal osc. 8 MHz
    OSCCON = 0b01110000;
}