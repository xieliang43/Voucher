//
//  XLMerchantDetailController.h
//  Voucher
//
//  Created by xie liang on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLMerchantInfoCell.h"
#import "XLVoucherCell.h"

@interface XLMerchantDetailController : UIViewController
<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataArray;
}

@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain) NSDictionary *merchantInfo;

@end
