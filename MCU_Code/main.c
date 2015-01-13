/* 
 * File:   main.c
 * Author: Benjamin
 *
 * Created on April 30, 2013, 5:41 PM
 */

#include "main.h"
#include "stdincludes.h"
#include "interrupt.h"
#include "motorControl.h"


// Function Declarations
void mcu_init();
void usartSendString(char* text);

// Global Variables
char usartString[20];


void main() {
    UINT8 rx[4];

    mcu_init();
    motorControl_init();



    while(1)
    {
        usartString[0] = 0x0B;
        usartString[1] = 0x0;
        usartString[2] = 0x08;
        usartString[3] = '\0';

        putsUSART(usartString);

        while(!DataRdyUSART());// Wait for data to be received
        getsUSART(rx,4);
        if ( rx[0] == 'M') // If motor control command
        {
            motorControl_setLeftMotorPWM_MODE(rx[2], rx[1] & 0xF0 );
            motorControl_setRightMotorPWM_MODE(rx[3], rx[1] & 0x0F );
        }
    }

    CloseUSART();
}


void mcu_init()
{
    // Internal osc. 8 MHz
    OSCCON = 0b01110000;

    // USART INIT, BAUD = 57600 (8MHz clock)
    OpenUSART(USART_TX_INT_OFF & USART_RX_INT_OFF & USART_ASYNCH_MODE &
               USART_EIGHT_BIT & USART_CONT_RX & USART_BRGH_HIGH, 8);

}
