//
//  XLUserLoginController.h
//  Voucher
//
//  Created by xie liang on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XLRegisterController.h"
#import "XLTabBarController.h"
#import "XLAppDelegate.h"

#import "XLMerchantListController.h"
#import "XLPocketController.h"
#import "XLMoreController.h"
#import "XLCityTableController.h"

#import "XLFindPasswordController.h"

@interface XLUserLoginController : UIViewController

@property (nonatomic,retain) IBOutlet UITextField *usernameField;
@property (nonatomic,retain) IBOutlet UITextField *passwordField;

- (IBAction)doRegist:(id)sender;
- (IBAction)doLogin:(id)sender;
- (IBAction)hideKeyboard:(id)sender;
- (IBAction)processReturnKey:(UITextField *)sender;
- (IBAction)findPassword:(id)sender;

@end
