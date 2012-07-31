//
//  XLSinaAuthorizeController.h
//  CTCouponProject
//
//  Created by xie liang on 7/17/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@class XLSinaEngine;

@protocol XLSinaAuthorizeDelegate <NSObject>

- (void)didAuthorizeSina;
- (void)didFialdAuthorizeSina;

@end

@interface XLSinaAuthorizeController : UIViewController<UIWebViewDelegate>
{
    XLSinaEngine *_engine;
    id<XLSinaAuthorizeDelegate> _delegate;
}

@property (nonatomic,retain) XLSinaEngine *engine;
@property (nonatomic,assign) id<XLSinaAuthorizeDelegate> delegate;

@end

