//
//  XLUseVoucherController.m
//  Voucher
//
//  Created by xie liang on 12-7-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XLUseVoucherController.h"

@interface XLUseVoucherController ()

@end

@implementation XLUseVoucherController

@synthesize voucher = _voucher;
@synthesize imageView = _imageView;
@synthesize descView = _descView;

- (void)dealloc
{
    [_imageView release];
    [_descView release];
    [_voucher release];
    [_usePassField release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _usePassField = [[UITextField alloc] initWithFrame:CGRectMake(20, 50, 245, 37)];
        _usePassField.secureTextEntry = YES;
        _usePassField.placeholder = @"请输入4为数字使用密码";
        _usePassField.borderStyle = UITextBorderStyleRoundedRect;
        _usePassField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _usePassField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return self;
}

- (void)setNavigationBar
{
    UIView *naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    naviBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg.png"]];
    [self.view addSubview:naviBar];
    [naviBar release];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:naviBar.bounds];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:19];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"使用代金券";
    [naviBar addSubview:titleLabel];
    [titleLabel release];
    
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(10, 6, 51, 32);
    [leftItem setBackgroundImage:[UIImage imageNamed:@"go_back.png"] forState:UIControlStateNormal];
    [leftItem setTitle:@"返回" forState:UIControlStateNormal];
    leftItem.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    leftItem.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftItem addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:leftItem];
}

- (void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBar];
    NSString *imageUrlStr = [_voucher objectForKey:@"image"];
    _imageView.image = [UIImage imageWithData:[XLTools readFileToCache:[XLTools md5:imageUrlStr]]];
    _descView.text = [_voucher objectForKey:@"useRule"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doUseVoucher:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入使用密码" 
                                                    message:@"\n\n" 
                                                   delegate:self 
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert addSubview:_usePassField];
    [_usePassField becomeFirstResponder];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [_usePassField resignFirstResponder];
    if (buttonIndex == 1) {
        NSString *urlStr = [XLTools getInterfaceByKey:@"useVoucher"];
        Debug(@"%@",urlStr);
        NSURL *url = [NSURL URLWithString:urlStr];
        ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:url];
        req.delegate = self;
        req.requestMethod = @"POST";
        [req addDefaultPostValue];
        [req setPostValue:[_voucher objectForKey:@"viId"] forKey:@"uvId"];
        [req setPostValue:_usePassField.text forKey:@"expensePassword"];
        [req startAsynchronous];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    Debug(@"%@",request.responseString);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (request.responseStatusCode == 200) {
        NSDictionary *dic = [request.responseString JSONValue];
        Debug(@"%@",[dic objectForKey:@"resultInfo"]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:[dic objectForKey:@"resultInfo"] 
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else {
        Debug(@"%@",request.responseStatusCode);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"服务器内部异常！" 
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    Debug(@"网络链接或服务器问题！");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"请检查网络链接或联系管理员！" 
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}


@end
