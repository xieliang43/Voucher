//
//  XLMerchantCell.m
//  Voucher
//
//  Created by xie liang on 7/13/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import "XLMerchantCell.h"

@implementation XLMerchantCell

@synthesize logoView = _logoView;
@synthesize nameLabel = _nameLabel;
@synthesize distanceLabel = _distanceLabel;
@synthesize addressLabel = _addressLabel;

- (void)dealloc
{
    [_logoView release];
    [_nameLabel release];
    [_distanceLabel release];
    [_addressLabel release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
