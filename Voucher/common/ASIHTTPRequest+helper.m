//
//  ASIHTTPRequest+helper.m
//  Voucher
//
//  Created by xie liang on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ASIHTTPRequest+helper.h"

@implementation ASIHTTPRequest (helper)

- (void)addDefaultHeader
{
    [self addRequestHeader:@"userId" value:@""];
    [self addRequestHeader:@"token" value:@""];
    [self addRequestHeader:@"uuid" value:@""];
    [self addRequestHeader:@"deviceType" value:@"1"];
}

@end
