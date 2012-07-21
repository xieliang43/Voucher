//
//  XLTabBarItem.h
//  Voucher
//
//  Created by xie liang on 7/13/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLTabBarItemDelegate;

@interface XLTabBarItem : UIView
{
    UIImageView *_itemImageView;
    UILabel *_itemLabel;
    id<XLTabBarItemDelegate> _delegate;
}

@property (nonatomic,retain,readonly) UIImageView *itemImageView;
@property (nonatomic,retain,readonly) UILabel *itemLabel;
@property (nonatomic,assign) id<XLTabBarItemDelegate> delegate;

@end

@protocol XLTabBarItemDelegate <NSObject>

- (void)didSelectItem:(XLTabBarItem *)item;

@end