//
//  XLFindPasswordController.h
//  Voucher
//
//  Created by xie liang on 12-8-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLFindPasswordController : UIViewController
{
    NSString *_verifyCodeStr;
}

@property (nonatomic,retain) IBOutlet UITextField *phoneField;
@property (nonatomic,retain) IBOutlet UITextField *verifyField;
@property (nonatomic,retain) IBOutlet UITextField *nPassword;
@property (nonatomic,retain) IBOutlet UITextField *rPassword;

@property (nonatomic,retain) NSString *verifyCodeStr;

- (IBAction)fetchVerifyCode:(id)sender;
- (IBAction)setNewPassword:(id)sender;

@end
