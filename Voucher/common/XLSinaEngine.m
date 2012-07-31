//
//  XLSinaEngine.m
//  CTCouponProject
//
//  Created by xie liang on 7/17/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import "XLSinaEngine.h"

@implementation XLSinaEngine

@synthesize uid = _uid;
@synthesize access_token = _access_token;
@synthesize expires = _expires;
@synthesize delegate = _delegate;
@synthesize rootViewController = _rootViewController;

- (void)dealloc
{
    [_uid release];
    [_access_token release];
    [super dealloc];
}

#pragma mark - 
- (void)saveSinaInfo:(NSDictionary *)info
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:info forKey:@"sina_info"];
    [def synchronize];
}

- (void)getSinaInfo
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [def objectForKey:@"sina_info"];
    _uid = [[dic objectForKey:@"uid"] retain];
    _access_token = [[dic objectForKey:@"access_token"] retain];
    _expires = [[dic objectForKey:@"expires"] doubleValue];
}

- (void)deleteSinaInfo
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:@"sina_info"];
    [def synchronize];
}

- (BOOL)isLogin
{
    [self getSinaInfo];
    return _uid && _access_token && ((_expires - [[NSDate date] timeIntervalSince1970]) > 0);
}

- (void)loginSina
{
    if ([self isLogin]) {
        if ([_delegate respondsToSelector:@selector(didLoginSina)]) {
            [_delegate didLoginSina];
        }
    }else {
        XLSinaAuthorizeController *authController = [[XLSinaAuthorizeController alloc] initWithNibName:nil bundle:nil];
        authController.engine = self;
        authController.delegate = self;
        [_rootViewController.navigationController pushViewController:authController animated:YES];
        [authController release];
    }
}

- (void)logoutSina
{
    [self deleteSinaInfo];
}

#pragma mark - XLSinaAuthorizeDelegate
- (void)didAuthorizeSina
{
    Debug(@"sina授权成功！");
    [self getSinaInfo];
    if ([_delegate respondsToSelector:@selector(didLoginSina)]) {
        [_delegate didLoginSina];
    }
}

- (void)didFialdAuthorizeSina
{
    Debug(@"sina授权失败！");
    if ([_delegate respondsToSelector:@selector(didFialdLoginSina)]) {
        [_delegate didFialdLoginSina];
    }
}

#pragma mark - sina api
- (void)sendStatus:(NSString *)status
{
    NSString *urlStr = @"https://api.weibo.com/2/statuses/update.json";
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:url];
    req.requestMethod = @"POST";
    req.delegate = self;
    [req setPostValue:_access_token forKey:@"access_token"];
    [req setPostValue:[status stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"status"];
    req.didFinishSelector = @selector(didFinishSendStatus:);
    req.didFailSelector = @selector(didFailSendStatus:);
    [req startAsynchronous];
}

- (void)didFinishSendStatus:(ASIHTTPRequest *)request
{
    Debug(@"%@",request.responseString);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"分享到新浪微博成功！"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)didFailSendStatus:(ASIHTTPRequest *)request
{
    Debug(@"%@",request.responseString);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"分享到新浪微博成功！"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}


@end
