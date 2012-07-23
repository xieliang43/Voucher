//
//  XLMerchantCell.h
//  Voucher
//
//  Created by xie liang on 7/13/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLMerchantCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UIImageView *logoView;
@property (nonatomic,retain) IBOutlet UILabel *nameLabel;
@property (nonatomic,retain) IBOutlet UILabel *distanceLabel;
@property (nonatomic,retain) IBOutlet UILabel *addressLabel;

@end
