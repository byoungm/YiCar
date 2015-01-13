// motorControl.h

#ifndef MOTORCONTROL_H
#define MOTORCONTROL_H

#include "stdincludes.h"

void motorControl_init();
void motorControl_TMR0Interrupt();
void motorControl_setLeftMotorPWM_MODE(UINT8 pwm, UINT8 mode);
void motorControl_setRightMotorPWM_MODE(UINT8 pwm, UINT8 mode);

#endif  // MOTORCONTROL_H