//
//  XLRegisterController.h
//  Voucher
//
//  Created by xie liang on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLAppDelegate.h"

@interface XLRegisterController : UIViewController

@property (nonatomic,retain) IBOutlet UITextField *phoneField;
@property (nonatomic,retain) IBOutlet UITextField *verifyField;
@property (nonatomic,retain) IBOutlet UITextField *passwordField;
@property (nonatomic,retain) NSString *verifyCodeStr;

- (IBAction)fetchVerifyCode:(id)sender;
- (IBAction)doRegister:(id)sender;
- (IBAction)processReturnKey:(UITextField *)sender;

@end
