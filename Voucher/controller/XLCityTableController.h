//
//  XLCityTableController.h
//  Voucher
//
//  Created by xie liang on 7/16/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLCityCell.h"

@interface XLCityTableController : UIViewController
<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary *_dataDic;
    NSArray *_indexArray;
    NSDictionary *areaInfo;
    NSInteger _type;
}

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UILabel *currentCityLabel;
@property (nonatomic,assign) NSInteger type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(NSInteger)type;

@end
