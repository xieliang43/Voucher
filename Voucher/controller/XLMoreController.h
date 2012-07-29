//
//  XLMoreController.h
//  Voucher
//
//  Created by xie liang on 7/13/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLTools.h"
#import "XLAppDelegate.h"
#import "XLCityTableController.h"
#import "XLPublishController.h"
#import "XLAdviseController.h"
#import "XLAboutMeController.h"

@class XLTabController;

@interface XLMoreController : UIViewController
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) XLTabController *tabController;
@property (nonatomic,retain) IBOutlet UITableView *tableView;

@end
