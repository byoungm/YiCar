//
//  ETJoyStickSlider.m
//  YiCar
//
//  Created by Benjamin Young on 1/5/15.
//  Copyright (c) 2015 Benjamin Young. All rights reserved.
//

#import "ETJoyStickSlider.h"

@implementation ETJoyStickSlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


// Reset slider when the touches end
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.value = (self.maximumValue + self.minimumValue) / 2;
}


@end
