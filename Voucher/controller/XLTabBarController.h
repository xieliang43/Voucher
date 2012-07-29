//
//  XLTabController.h
//  Voucher
//
//  Created by xie liang on 7/13/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTabBarItem.h"
#import "XLMoreController.h"

@interface XLTabController : UIViewController<XLTabBarItemDelegate>
{
    NSArray *_controllers;
    UIView *_tabBar;
    UIImageView *_itemBgView;
    UIView *_containerView;
    
    XLTabBarItem *_packageItem;
    XLTabBarItem *_homeItem;
    XLTabBarItem *_moreItem;
    
    NSInteger selectedIndex;
}

@property (nonatomic,retain,setter = setControllers:) NSArray *controllers;

- (void)hideMyTabBar;
- (void)displayMyTabBar;

@end
