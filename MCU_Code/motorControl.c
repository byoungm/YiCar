#include "motorControl.h"

#define TMR0_MAX 255
#define L_IN_1 PORTDbits.RD0
#define L_IN_2 PORTDbits.RD1
#define R_IN_1 PORTDbits.RD2
#define R_IN_2 PORTDbits.RD3



void motorControl_init()
{
    PR2 = 0xff; // Period for timer 2
    T2CON=0x02; //Configure Timer2 with prescale 1

    // Motor Drive Controls using PortD
    TRISD = 0x00; // All portD is output

    // Left Motor (CCPR1) PIN: 17
    TRISCbits.TRISC2=0; //Set CCP1 to output
    CCP1CON=0x3C; //PWM enable, and set lower duty cycle bits
    CCPR1L = 0;//start at 50%


    // Right Motor (TMR0) PIN: 16
    TRISCbits.TRISC1=0; //Set CCP2 to output
    CCP2CON=0x3C; //PWM enable, and set lower duty cycle bits
    CCPR2L = 0;//start at 50%

    // Timer 0 (if needed)
    T0CON = 0b01000011;  // 8 bit mode, 1:16 prescale enabled
    TMR0L = 0;

    INTCONbits.TMR0IF = 0; // Clear Timer 0 Interrupt flag
    INTCONbits.TMR0IE = 1; // Enable Timer 0 Interrupt
    INTCONbits.GIE = 1; // Enable Global Interrupts


    // START PWMs
    T2CONbits.TMR2ON = 1; // CCP1 & CCP2
}

void motorControl_TMR0Interrupt()
{

    

    // Reset Interrupt  
    INTCONbits.TMR0IF = 0; // Clear Timer 0 Interrupt flag
    INTCONbits.TMR0IE = 1; // Enable Timer 0 Interrupt
    INTCONbits.GIE = 1; // Enable Global Interrupts
    T0CONbits.TMR0ON = 1;  //turns timer on
}

void motorControl_setLeftMotorPWM_MODE(UINT8 pwm, UINT8 mode)
{
    CCPR1L = pwm;

    if (mode == 0x00)
    {
        // Backwards
        L_IN_1 = 1;
        L_IN_2 = 0;
    }
    else
    {
        // Forwards
        L_IN_1 = 0;
        L_IN_2 = 1;
    }
}

void motorControl_setRightMotorPWM_MODE(UINT8 pwm, UINT8 mode)
{
    CCPR2L = pwm;

    if (mode == 0x00)
    {
        // Backwards
        R_IN_1 = 1;
        R_IN_2 = 0;
    }
    else
    {
        // Forwards
        R_IN_1 = 0;
        R_IN_2 = 1;
    }
}