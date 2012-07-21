//
//  XLMerchantListController.h
//  Voucher
//
//  Created by xie liang on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLMerchantCell.h"
#import "XLOptionSelectorView.h"

@interface XLMerchantListController : UIViewController
<UITableViewDataSource,UITableViewDelegate>

- (IBAction)displayOptions:(id)sender;

@end
