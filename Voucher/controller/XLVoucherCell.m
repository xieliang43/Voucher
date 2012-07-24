//
//  XLVoucherCell.m
//  Voucher
//
//  Created by xie liang on 7/24/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import "XLVoucherCell.h"

@implementation XLVoucherCell

@synthesize priceLabel = _priceLabel;
@synthesize noLabel = _noLabel;
@synthesize dateLabel = _dateLabel;
@synthesize purchaseBtn = _purchaseBtn;

- (void)dealloc
{
    [_priceLabel release];
    [_noLabel release];
    [_dateLabel release];
    [_purchaseBtn release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
