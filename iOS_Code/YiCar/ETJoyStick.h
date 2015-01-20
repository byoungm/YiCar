//
//  ETJoyStickSlider.h
//  YiCar
//
//  Created by Benjamin Young on 1/5/15.
//  Copyright (c) 2015 Benjamin Young. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ETJoyStick : UIControl

typedef struct
{
    BOOL leftForward;
    BOOL rightForward;
    float leftPowerPercent;
    float rightPowerPercent;
}MotorValue_t;

@property (nonatomic, readonly) CGPoint value;
@property (nonatomic, readonly) MotorValue_t motorValues;

@end
