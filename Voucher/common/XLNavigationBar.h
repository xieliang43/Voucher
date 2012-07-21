//
//  XLNavigationBar.h
//  Voucher
//
//  Created by xie liang on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLNavigationBar : UIView
{
    UIView *_leftItem;
    UIView *_rightItem;
    UILabel *_titleLabel;
}

@property (nonatomic,retain) UIView *leftItem;
@property (nonatomic,retain) UIView *rightItem;

- (id)initWithTitle:(NSString *)title leftItem:(UIView *)lItem rightItem:(UIView *)rItem;

@end
