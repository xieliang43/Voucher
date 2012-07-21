//
//  XLCityCell.m
//  Voucher
//
//  Created by xie liang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XLCityCell.h"

@implementation XLCityCell

@synthesize cityLabel = _cityLabel;
@synthesize selectedView = _selectedView;

- (void)dealloc
{
    [_cityLabel release];
    [_selectedView release];
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
