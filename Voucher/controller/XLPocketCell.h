//
//  XLPocketCell.h
//  Voucher
//
//  Created by xie liang on 12-7-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLPocketCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel *merchantLabel;
@property (nonatomic,retain) IBOutlet UILabel *priceLabel;
@property (nonatomic,retain) IBOutlet UILabel *noLabel;
@property (nonatomic,retain) IBOutlet UILabel *dateLabel;
@property (nonatomic,retain) IBOutlet UIImageView *flagView;

@end
