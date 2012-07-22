//
//  CTLoadImageOperation.h
//  CTCouponProject
//
//  Created by xie liang on 7/3/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTLoadImageOperation : NSOperation
{
    NSURL *_url;
    id _target;
    SEL _action;
    NSIndexPath *_indexPath;
}

- (id)initWithUrl:(NSURL *)url target:(id)theTarget action:(SEL)theAction indexPath:(NSIndexPath *)theIndexPath;
@end
