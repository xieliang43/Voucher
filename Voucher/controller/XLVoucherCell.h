//
//  XLVoucherCell.h
//  Voucher
//
//  Created by xie liang on 7/24/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLVoucherCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel *priceLabel;
@property (nonatomic,retain) IBOutlet UILabel *noLabel;
@property (nonatomic,retain) IBOutlet UILabel *dateLabel;
@property (nonatomic,retain) IBOutlet UIButton *purchaseBtn;

@end
