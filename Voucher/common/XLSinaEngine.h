//
//  XLSinaEngine.h
//  CTCouponProject
//
//  Created by xie liang on 7/17/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLSinaAuthorizeController.h"
#import "NSObject+SBJson.h"
#import "ASIFormDataRequest.h"

#define SINA_APP_KEY @"1709926226"
#define SINA_APP_SECRET @"9665da7700da52423aac7fdf701e4d6a"
#define SINA_REDIRECT_URI @"http://www.naryou.com"
#define SINA_AUTHORIZE_URL @"https://api.weibo.com/oauth2/authorize"
#define SINA_ACCESS_TOKEN_URL @"https://api.weibo.com/oauth2/access_token"

@protocol XLSinaEngineDelegate;

@interface XLSinaEngine : NSObject<XLSinaAuthorizeDelegate>
{
    NSString *_uid;
    NSString *_access_token;
    double _expires;
    
    id<XLSinaEngineDelegate> _delegate;
    
    UIViewController *_rootViewController;
}

@property (nonatomic,retain,readonly) NSString *uid;
@property (nonatomic,retain,readonly) NSString *access_token;
@property (nonatomic,assign,readonly) double expires;
@property (nonatomic,assign) id<XLSinaEngineDelegate> delegate;
@property (nonatomic,assign) UIViewController *rootViewController;

- (void)saveSinaInfo:(NSDictionary *)info;
- (BOOL)isLogin;
- (void)loginSina;
- (void)logoutSina;

#pragma mark - sina api
- (void)sendStatus:(NSString *)status;

@end

@protocol XLSinaEngineDelegate <NSObject>

- (void)didLoginSina;
- (void)didFialdLoginSina;

@end
