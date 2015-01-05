/* 
 * File:   lcd.h
 * Author: tech
 *
 * Created on December 18, 2012, 7:33 PM
 */

#ifndef LCD_H
#define	LCD_H

#include "stdincludes.h"

#define E PORTEbits.RE0
#define RW PORTEbits.RE1
#define RS PORTEbits.RE2


// Public Funtions
void lcd_initDisplay();
void lcd_displayOff();
void lcd_displayOn();
void lcd_clearDisplay();
void lcd_setAddr(UINT16);
void lcd_writeLine(char *text, UINT8 lineNumber);
void lcd_putCharAtAddr(char c, UINT16 addr);
void lcd_delayInUS(UINT16 time);

#endif	/* LCD_H */


