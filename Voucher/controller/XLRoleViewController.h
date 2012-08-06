//
//  XLRoleViewController.h
//  Voucher
//
//  Created by xie liang on 8/6/12.
//
//

#import <UIKit/UIKit.h>

@interface XLRoleViewController : UIViewController

@property (nonatomic,retain) NSString *nameStr;
@property (nonatomic,retain) NSString *descStr;

@property (nonatomic,retain) IBOutlet UILabel *nameLabel;
@property (nonatomic,retain) IBOutlet UITextView *descView;

@end
