// motorControl.h

#ifndef MOTORCONTROL_H
#define MOTORCONTROL_H

#include "stdincludes.h"

void motorControl_init();
void motorControl_TMR0Interrupt();
void motorControl_setLeftDutyCycle(UINT8 value);
void motorControl_setRightDutyCycle(UINT8 value);

#endif  // MOTORCONTROL_H