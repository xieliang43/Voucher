//
//  XLAppDelegate.h
//  Voucher
//
//  Created by xie liang on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "XLUserLoginController.h"
#import "ASIFormDataRequest.h"
#import "NSObject+SBJSON.h"

@interface XLAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) UIWindow *window;

- (void)setLoginAsRoot;
- (void)setTabBarAsRoot;

@end
