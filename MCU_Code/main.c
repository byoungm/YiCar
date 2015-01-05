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
void usartSendString(char* text);

// Global Variables
char usartString[20];


void main() {

    mcu_init();
    lcd_initDisplay();


    sprintf(usartString,"Number:%d",5);
    putsUSART(usartString); //Delay10KTCYx(7) ???

    while(1);
    
}


void mcu_init()
{
    // Internal osc. 8 MHz
    OSCCON = 0b01110000;

    // USART INIT
    OpenUSART(USART_TX_INT_OFF & USART_RX_INT_OFF & USART_ASYNCH_MODE &
               USART_EIGHT_BIT & USART_CONT_RX & USART_BRGH_HIGH, 25);
}
