//
//  XLPocketController.h
//  Voucher
//
//  Created by xie liang on 7/13/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPocketCell.h"

@interface XLPocketController : UIViewController
<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataArray;
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;

@end
