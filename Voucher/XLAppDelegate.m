//
//  XLAppDelegate.m
//  Voucher
//
//  Created by xie liang on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XLAppDelegate.h"

@implementation XLAppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (void)setLoginAsRoot
{
    XLUserLoginController *loginController = [[XLUserLoginController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginController];
    navController.navigationBarHidden = YES;
    
    self.window.rootViewController = navController;
    [loginController release];
    [navController release];
}

- (void)setTabBarAsRoot
{
    XLPocketController *pocketController = [[XLPocketController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *pocketNavi = [[UINavigationController alloc] initWithRootViewController:pocketController];
    pocketNavi.navigationBarHidden = YES;
    
    XLMerchantListController *merController = [[XLMerchantListController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *merNavi = [[UINavigationController alloc] initWithRootViewController:merController];
    merNavi.navigationBarHidden = YES;
    
    XLMoreController *moreController = [[XLMoreController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *moreNavi = [[UINavigationController alloc] initWithRootViewController:moreController];
    moreNavi.navigationBarHidden = YES;
    
    NSArray *controllers = [NSArray arrayWithObjects:pocketNavi,merNavi,moreNavi,nil];
    
    XLTabBarController *tabBarController = [[XLTabBarController alloc] initWithNibName:nil bundle:nil];
    tabBarController.controllers = controllers;
    _window.rootViewController = tabBarController;
    
    [pocketController release];
    [merController release];
    [moreController release];
    
    [pocketNavi release];
    [merNavi release];
    [moreNavi release];
    
    [tabBarController release];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    if ([XLTools isLogin]) {
        [self setTabBarAsRoot];
    }else {
        [self setLoginAsRoot];
    }
    
    //获取地域列表
    NSString *urlStr = [XLTools getInterfaceByKey:@"merchant_type"];
    ASIFormDataRequest *req1 = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    req1.requestMethod = @"POST";
    req1.delegate = self;
    req1.tag = 1000;
    [req1 startAsynchronous];
    
    //获取距离列表
    urlStr = [XLTools getInterfaceByKey:@"distance_type"];
    ASIFormDataRequest *req2 = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    req2.requestMethod = @"POST";
    req2.delegate = self;
    req2.tag = 1001;
    [req2 startAsynchronous];
    
    //获取区域列表
    urlStr = [XLTools getInterfaceByKey:@"area_type"];
    ASIFormDataRequest *req3 = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    req3.requestMethod = @"POST";
    req3.delegate = self;
    req3.tag = 1002;
    [req3 startAsynchronous];

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    Debug(@"%@",request.responseString);
    if (request.responseStatusCode == 200) {
        NSDictionary *dic = [request.responseString JSONValue];
        if ([[dic objectForKey:@"resultCode"] intValue] == 1) {
            switch (request.tag) {
                case 1000:
                {
                    [XLTools writeMerchantTypeToFile:[dic objectForKey:@"info"]];
                    break;
                }
                case 1001:
                {
                    [XLTools writeDistanceTypeToFile:[dic objectForKey:@"info"]];
                    break;
                }
                case 1002:
                {
                    [XLTools writeAreaTypeToFile:[dic objectForKey:@"info"]];
                    break;
                }
                default:
                    break;
            }
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}

@end
