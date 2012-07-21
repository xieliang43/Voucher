//
//  XLTabBarItem.m
//  Voucher
//
//  Created by xie liang on 7/13/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import "XLTabBarItem.h"

@implementation XLTabBarItem

@synthesize itemImageView = _itemImageView;
@synthesize itemLabel = _itemLabel;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [_itemImageView release];
    [_itemLabel release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(26, 4, 26, 26)];
        [self addSubview:_itemImageView];
        
        _itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, 78, 10)];
        _itemLabel.textAlignment = UITextAlignmentCenter;
        _itemLabel.backgroundColor = [UIColor clearColor];
        _itemLabel.textColor = [UIColor whiteColor];
        _itemLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_itemLabel];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_delegate respondsToSelector:@selector(didSelectItem:)]) {
        [_delegate didSelectItem:self];
    }
}

@end
