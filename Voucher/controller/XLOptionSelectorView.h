//
//  XLOptionSelectorView.h
//  Voucher
//
//  Created by xie liang on 7/13/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLOptionSelectorView : UIView
<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_titleLabel;
    NSArray *_optionArray;
    UITableView *_optionTable;
}

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) NSArray *optionArray;

@end
