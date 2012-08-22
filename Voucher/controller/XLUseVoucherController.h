//
//  XLUseVoucherController.h
//  Voucher
//
//  Created by xie liang on 12-7-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLUseVoucherController : UIViewController
{
    UITextField *_usePassField;
}

@property (nonatomic,retain) NSDictionary *voucher;
@property (nonatomic,retain) IBOutlet UIImageView *imageView;
@property (nonatomic,retain) IBOutlet UITextView *descView;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *indicator;

- (IBAction)doUseVoucher:(id)sender;

@end
