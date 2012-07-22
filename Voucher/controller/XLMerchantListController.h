//
//  XLMerchantListController.h
//  Voucher
//
//  Created by xie liang on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "XLMerchantCell.h"
#import "XLOptionSelectorView.h"

@interface XLMerchantListController : UIViewController
<UITableViewDataSource,UITableViewDelegate,XLOptionSelectorDelegate,CLLocationManagerDelegate>
{
    NSString *_merchantType;
    NSString *_distance;
    NSString *_area;
    
    NSArray *_dataArray;
    
    CLLocationManager *locationManager;
    
    double latitude;
    double longitude;
    NSInteger start;
    NSInteger limit;
    
}

@property (nonatomic,retain) IBOutlet UIButton *merchantTypeBtn;
@property (nonatomic,retain) IBOutlet UIButton *distanceBtn;
@property (nonatomic,retain) IBOutlet UIButton *areaBtn;

- (IBAction)displayOptions:(UIButton *)sender;

@end
