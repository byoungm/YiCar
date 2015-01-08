#include "motorControl.h"

#define TMR0_MAX 255

UINT8 tmr0Duty;


void motorControl_init()
{
    PR2 = 0xff; // Period for timer 2
    T2CON=0x02; //Configure Timer2 with prescale 1
    //PIR1bits.TMR2IF=0; //Clear Timer2 interrupt
    //TMR2 = 0;

    // Left Motor (CCPR1) PIN: 17
    TRISCbits.TRISC2=0; //Set CCP1 to output
    CCP1CON=0x3C; //PWM enable, and set lower duty cycle bits
    CCPR1L = 0;//start at 50%

    // Right Motor (TMR0) PIN: 18
    TRISCbits.TRISC3 = 0; // Set as output
    PORTCbits.RC3 = 0; // Init output to 0
    T0CON = 0b01000011;  // 8 bit mode, 1:16 prescale enabled
    TMR0L = 0;
    tmr0Duty = 0;

    INTCONbits.TMR0IF = 0; // Clear Timer 0 Interrupt flag
    INTCONbits.TMR0IE = 1; // Enable Timer 0 Interrupt
    INTCONbits.GIE = 1; // Enable Global Interrupts


    // START PWMs
    T0CONbits.TMR0ON=1; // TMR0
    T2CONbits.TMR2ON=1; // CCP1
}

void motorControl_TMR0Interrupt()
{

    
    // Set Next Transition time if we are high we want to set time duty peroid for low
    if ( PORTCbits.RC3 )
    {
        TMR0L = tmr0Duty; // 1 - duty cycle time (for low)
    }
    else
    {
        TMR0L = TMR0_MAX - tmr0Duty; // duty cycle time (for high)
    }
    
    PORTCbits.RC3 = ~PORTCbits.RC3;

    // Reset Interrupt  
    INTCONbits.TMR0IF = 0; // Clear Timer 0 Interrupt flag
    INTCONbits.TMR0IE = 1; // Enable Timer 0 Interrupt
    INTCONbits.GIE = 1; // Enable Global Interrupts
    T0CONbits.TMR0ON = 1;  //turns timer on
}

void motorControl_setLeftDutyCycle(UINT8 value)
{
    CCPR1L = value;
}

void motorControl_setRightDutyCycle(UINT8 value)
{
    tmr0Duty = value;
}