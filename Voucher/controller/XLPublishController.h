//
//  XLPublishController.h
//  Voucher
//
//  Created by xie liang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface XLPublishController : UIViewController<MFMailComposeViewControllerDelegate>

- (IBAction)phonePublish:(id)sender;
- (IBAction)mailPublish:(id)sender;

@end
