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
void mcu_init(void);
void usartSendString(char* text);

// Global Variables
char usartString[20];

typedef union 
{
    UINT8 all;
    struct 
    {
        UINT8 cmd            :1;
        UINT8 leftDirection  :1;
        UINT8 leftPower      :1;
        UINT8 rightDirection :1;
        UINT8 rightPower     :1;
        UINT8 pad            :3;

    }bits;
}DataTransferParity_t;

typedef struct
{
    UINT8 all;
    struct 
    {
        UINT8 left  :4;
        UINT8 right :4;
    }bits;
}MotorDirection_t;

struct 
{
    UINT8 cmd;
    MotorDirection_t motorDirections;
    UINT8 leftPower;
    UINT8 rightPower;
    DataTransferParity_t parity;
    
}dataTransfer;


void main() {
    UINT8 rx[6];

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
        getsUSART(rx,6);
        memcpy(&dataTransfer, rx, sizeof(dataTransfer));
        if ( dataTransfer.cmd == 'M') // If motor control command
        {
            motorControl_setLeftMotorPWM_MODE(dataTransfer.leftPower, dataTransfer.motorDirections.left );
            motorControl_setRightMotorPWM_MODE(dataTransfer.rightPower, dataTransfer.motorDirections.right );
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
