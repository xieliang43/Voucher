//
//  XLTouchLabel.h
//  Voucher
//
//  Created by xie liang on 8/1/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLTouchLabel : UILabel
{
    SEL _action;
    id _target;
}

- (void)addTarget:(id)target action:(SEL)action;

@end
