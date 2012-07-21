//
//  XLNavigationBar.m
//  Voucher
//
//  Created by xie liang on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XLNavigationBar.h"

@implementation XLNavigationBar

@synthesize leftItem = _leftItem;
@synthesize rightItem = _rightItem;

- (void)dealloc
{
    [_leftItem release];
    [_rightItem release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithTitle:(NSString *)title leftItem:(UIView *)lItem rightItem:(UIView *)rItem
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg@2x.png"]];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = title;
        [self addSubview:_titleLabel];
        
        _leftItem = [lItem retain];
        _rightItem = [rItem retain];
        
        [self layoutViews];
    }
    return self;
}

- (void)layoutViews
{
    float x = 0.0;
    float y = 0.0;
    CGRect lItemFrame;
    if (_leftItem) {
        lItemFrame = _leftItem.frame;
        x = 10;
        y = (44 - lItemFrame.size.height)/2;
        lItemFrame.origin.x = x;
        lItemFrame.origin.y = y;
        _leftItem.frame = lItemFrame;
        [self addSubview:_leftItem];
    }
    
    
    
}

@end
