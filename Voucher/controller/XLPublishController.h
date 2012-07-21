//
//  XLPublishController.h
//  Voucher
//
//  Created by xie liang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLPublishController : UIViewController

@property (nonatomic,retain) IBOutlet UITextView *contentView;
@property (nonatomic,retain) IBOutlet UITextField *phoneField;

- (IBAction)sendPublish:(id)sender;

@end
