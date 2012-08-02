//
//  XLPocketController.h
//  Voucher
//
//  Created by xie liang on 7/13/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLSuperController.h"
#import "XLPocketCell.h"
#import "XLUseVoucherController.h"
#import "CTLoadImageOperation.h"

@interface XLPocketController : XLSuperController
<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataArray;
    NSOperationQueue *_queue;
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;

@end
