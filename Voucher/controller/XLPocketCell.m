//
//  XLPocketCell.m
//  Voucher
//
//  Created by xie liang on 12-7-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XLPocketCell.h"

@implementation XLPocketCell

@synthesize priceLabel = _priceLabel;
@synthesize noLabel = _noLabel;
@synthesize dateLabel = _dateLabel;
@synthesize flagView = _flagView;

- (void)dealloc
{
    [_flagView release];
    [_priceLabel release];
    [_noLabel release];
    [_dateLabel release];
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
