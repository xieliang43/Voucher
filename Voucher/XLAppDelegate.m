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
    [locationManager release];
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
    [XLTools createCacheDir];
    
    if ([XLTools isLogin]) {
        [self setTabBarAsRoot];
    }else {
        [self setLoginAsRoot];
    }

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
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;//设定为最佳精度  
        locationManager.distanceFilter = 100.0f;//响应位置变化的最小距离(m)  
        [locationManager startUpdatingLocation];  
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    double longt = newLocation.coordinate.longitude;
    double lati = newLocation.coordinate.latitude;
    if (abs(longt) < 0.00000001 && abs(lati) < 0.00000001) {
        return;
    }
    
    NSString *longitude = [NSString stringWithFormat:@"%.7f",oldLocation.coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%.7f",oldLocation.coordinate.latitude];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:longitude,@"longitude",latitude,@"latitude",nil];
    [XLTools saveUserLocation:dic];
}

@end
