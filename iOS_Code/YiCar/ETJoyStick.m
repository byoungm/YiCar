//
//  ETJoyStickSlider.m
//  YiCar
//
//  Created by Benjamin Young on 1/5/15.
//  Copyright (c) 2015 Benjamin Young. All rights reserved.
//

#import "ETJoyStick.h"

#define TOUCH_CIRCLE_RADIUS 75

typedef struct
{
    BOOL valid;
    CGPoint current;
    CGPoint origional;
}ETPointRef_t;

@interface ETJoyStick()

@property (nonatomic, readwrite) CGPoint value;
// Touch 1
@property (nonatomic) UIBezierPath *touch1BP;
@property (nonatomic) ETPointRef_t *touch1Ref;
// Touch 2
//@property (nonatomic) UIBezierPath *touch2BP;
//@property (nonatomic) ETPointRef_t *touch2Ref;

@end


@implementation ETJoyStick


- (UIBezierPath *)touch1BP
{
    if (!_touch1BP) _touch1BP = [UIBezierPath bezierPath];
    return _touch1BP;
}

- (ETPointRef_t *)touch1Ref
{
    if (!_touch1Ref)
    {
        _touch1Ref = malloc(sizeof(ETPointRef_t));
        _touch1Ref->current = CGPointZero;
        _touch1Ref->origional = CGPointZero;
        _touch1Ref->valid = 0;
    }
    return _touch1Ref;
}

- (CGPoint)value
{
    CGPoint limit = CGPointZero;
    CGPoint touchDiff = CGPointZero;
    CGPoint v = CGPointZero;
    CGFloat ratio = 0;
    _value = CGPointZero;
    
    if (self.touch1Ref->valid)
    {
        CGPoint c = self.touch1Ref->current;
        CGPoint o = self.touch1Ref->origional;
        touchDiff.x = o.x - c.x;
        touchDiff.y = o.y - c.y;
    
        // Find ratio and limit
        ratio = TOUCH_CIRCLE_RADIUS / ( sqrtf( powf(touchDiff.x, 2) + powf(touchDiff.y, 2) ) );
        limit.x = ratio * touchDiff.x;
        limit.y = ratio * touchDiff.y;
        
        // Clip the values
        v.x = [self clipValue:touchDiff.x withClipLimit:limit.x];
        v.y = [self clipValue:touchDiff.y withClipLimit:limit.y];
        
        // Scale to unit circle
        v.x /= TOUCH_CIRCLE_RADIUS;
        v.y /= TOUCH_CIRCLE_RADIUS;
        
        // Rotate
        _value.x = (v.x + v.y) / sqrtf(2.0);
        _value.y = (v.y - v.x) / sqrtf(2.0);
        
    }
    
    return _value;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [[UIColor whiteColor] setStroke];
    [self.touch1BP stroke];
    
    NSString *str = [NSString stringWithFormat:@"X: %3.1f, Y: %3.1f", self.value.x, self.value.y];
    [str drawAtPoint:CGPointZero withAttributes:nil];
}




#pragma mark - Respond to Touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touch = [[[event allTouches] anyObject]  locationInView:self];
    self.touch1Ref->origional = touch;
    self.touch1BP = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(touch.x - TOUCH_CIRCLE_RADIUS,
                                                                      touch.y - TOUCH_CIRCLE_RADIUS,
                                                                      2 * TOUCH_CIRCLE_RADIUS,
                                                                      2 * TOUCH_CIRCLE_RADIUS)];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.touch1BP = nil; // reset
    self.touch1Ref->valid = 0;
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.touch1Ref->current = [[[event allTouches] anyObject]  locationInView:self];
    self.touch1Ref->valid = 1;
#warning remove this line
    [self setNeedsDisplay];
}

- (float)clipValue:(float)value withClipLimit:(float)clipLimit
{
    double newValue = value;
    
    if (clipLimit < 0) clipLimit *= -1; // Force Clip limit to be positive
    
    // Clip if needed
    if (value < -1*clipLimit)
    {
        newValue = -1*clipLimit;
    }
    else if (value > clipLimit)
    {
        newValue = clipLimit;
    }
    
    return newValue;
}




@end
