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

@property(nonatomic,retain) IBOutlet UITableView *tableView;

@end
