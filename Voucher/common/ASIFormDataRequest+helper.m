//
//  ASIHTTPRequest+helper.m
//  Voucher
//
//  Created by xie liang on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ASIFormDataRequest+helper.h"

@implementation ASIFormDataRequest (helper)

- (void)addDefaultPostValue
{
    NSDictionary *info = [XLTools getUserInfo];
    if (info) {
        [self setPostValue:[[info objectForKey:@"id"] stringValue] forKey:@"userId"];
        [self setPostValue:[info objectForKey:@"token"] forKey:@"token"];
    }
    NSDictionary *cityInfo = [XLTools getCityInfo];
    if (cityInfo) {
        [self setPostValue:[[cityInfo objectForKey:@"id"] stringValue] forKey:@"cityId"];
    }
    [self setPostValue:@"" forKey:@"uuid"];
    [self setPostValue:@"1" forKey:@"deviceType"];
}

@end
