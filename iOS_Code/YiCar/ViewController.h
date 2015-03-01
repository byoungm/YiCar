//
//  ViewController.h
//  YiCar
//
//  Created by Benjamin Young on 1/3/15.
//  Copyright (c) 2015 Benjamin Young. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UInt8 UINT8;

@interface ViewController : UIViewController


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

    typedef struct
    {
        UINT8 cmd;
        MotorDirection_t motorDirections;
        UINT8 leftPower;
        UINT8 rightPower;
        DataTransferParity_t parity;
        
    }DataTransfer_t;


@end

