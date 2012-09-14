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
#import "WZRefreshTableHeaderView.h"
#import "WZLoadMoreTableFooterView.h"
#import "CTLoadImageOperation.h"
#import "XLMerchantDetailController.h"

@interface XLMerchantListController : UIViewController
<UITableViewDataSource,UITableViewDelegate,
XLOptionSelectorDelegate,WZRefreshTableHeaderDelegate,WZLoadMoreTableFooterDelegate>
{
    NSString *_merchantType;
    NSString *_distance;
    NSString *_area;
    
    NSMutableArray *_dataArray;
    
    NSInteger start;
    NSInteger limit;
    
    WZRefreshTableHeaderView *_refreshHeaderView;
    WZLoadMoreTableFooterView *_loadMoreFooterView;
    
    BOOL _reloading;
    
    NSOperationQueue *_queue;
    
    NSInteger _total;
    
    NSString *_keyWord;
    
    UITextField *searchField;
    UIButton *maskBtn;
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UIButton *merchantTypeBtn;
@property (nonatomic,retain) IBOutlet UIButton *distanceBtn;
@property (nonatomic,retain) IBOutlet UIButton *areaBtn;

- (IBAction)displayOptions:(UIButton *)sender;

@end
