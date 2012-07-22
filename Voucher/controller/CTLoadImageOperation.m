//
//  CTLoadImageOperation.m
//  CTCouponProject
//
//  Created by xie liang on 7/3/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import "CTLoadImageOperation.h"

@implementation CTLoadImageOperation

- (void)dealloc
{
    [_url release];
    [_indexPath release];
    [super dealloc];
}

- (id)initWithUrl:(NSURL *)url target:(id)theTarget action:(SEL)theAction indexPath:(NSIndexPath *)theIndexPath
{
    self = [super init]; //在老帖里面解释过为什么需要这么做了
    if (self) {
        _url = [url retain]; // 拷贝进对象，并retain（为什么？请查老帖）
        _target = theTarget;
        _action = theAction;
        _indexPath = [theIndexPath retain];
    }
    return self;
}

- (void)main
{
    // 同时载入图片
    NSData *data = [NSData dataWithContentsOfURL:_url];
    UIImage *image = [UIImage imageWithData:data];
    
    // 打包返回给初始类对象，然后执行其指定的操作
    NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:image,@"image",_indexPath,@"indexPath", nil];
    [_target performSelectorOnMainThread:_action withObject:result waitUntilDone:NO];
}

@end
