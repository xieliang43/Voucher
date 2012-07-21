//
//  XLAppDelegate.h
//  Voucher
//
//  Created by xie liang on 12-6-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLUserLoginController.h"
#import "ASIFormDataRequest.h"
#import "NSObject+SBJSON.h"

@interface XLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)setLoginAsRoot;
- (void)setTabBarAsRoot;

@end
