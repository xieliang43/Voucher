//
//  XLTouchLabel.m
//  Voucher
//
//  Created by xie liang on 8/1/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import "XLTouchLabel.h"

@implementation XLTouchLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)addTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.textColor = [UIColor grayColor];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.textColor = [UIColor blackColor];
    UITouch *touch = [touches anyObject];    
    CGPoint endPoint = [touch locationInView:self];
    if (endPoint.x > 0&&endPoint.x < self.frame.size.width&&endPoint.y > 0 && endPoint.y < self.frame.size.height) {
        if (_target && [_target respondsToSelector:_action]) {
            [_target performSelector:_action withObject:self];
        }
    }
}

@end
