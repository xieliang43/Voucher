//
//  XLVoucherCell.h
//  Voucher
//
//  Created by xie liang on 7/24/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XLVoucherCellDelegate;

@interface XLVoucherCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel *priceLabel;
@property (nonatomic,retain) IBOutlet UILabel *noLabel;
@property (nonatomic,retain) IBOutlet UILabel *dateLabel;
@property (nonatomic,retain) IBOutlet UIButton *purchaseBtn;
@property (nonatomic,assign) int index;

@property (nonatomic,assign) id<XLVoucherCellDelegate> delegate;

- (IBAction)pressPurchaseBtn:(id)sender;
- (void)setBought:(int)bought;

@end

@protocol XLVoucherCellDelegate <NSObject>

- (void)didPressPurchase:(XLVoucherCell *)cell;

@end
