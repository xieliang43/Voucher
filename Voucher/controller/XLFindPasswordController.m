//
//  XLFindPasswordController.m
//  Voucher
//
//  Created by xie liang on 12-8-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XLFindPasswordController.h"

@interface XLFindPasswordController ()

@end

@implementation XLFindPasswordController

@synthesize phoneField = _phoneField;
@synthesize verifyField = _verifyField;
@synthesize nPassword = _nPassword;
@synthesize rPassword = _rPassword;

@synthesize verifyCodeStr = _verifyCodeStr;

- (void)dealloc
{
    [_phoneField release];
    [_verifyField release];
    [_nPassword release];
    [_rPassword release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    titleLabel.text = @"找回密码";
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
    
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(320-10-51, 6, 51, 32);
    [rightItem setBackgroundImage:[UIImage imageNamed:@"red_btn.png"] forState:UIControlStateNormal];
    [rightItem setTitle:@"完成" forState:UIControlStateNormal];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightItem addTarget:self action:@selector(setNewPassword:) forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:rightItem];
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

#pragma mark - 
- (IBAction)fetchVerifyCode:(id)sender
{
    NSString *urlStr = [XLTools getInterfaceByKey:@"fetchResetCode"];
    Debug(@"%@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:url];
    req.requestMethod = @"POST";
    [req addPostValue:_phoneField.text forKey:@"phoneNo"];
    req.delegate = self;
    req.tag = 100;
    [req startAsynchronous];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (IBAction)setNewPassword:(id)sender
{
    if (_phoneField.text) {
        //验证手机号
    }
    
    if (![_verifyCodeStr isEqualToString:_verifyField.text]) {
        //验证验证码
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"验证码无效！" 
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    if (_nPassword.text) {
        //验证密码
    }
    
    NSString *urlStr = [XLTools getInterfaceByKey:@"setPassword"];
    Debug(@"%@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:url];
    req.requestMethod = @"POST";
    [req addPostValue:_phoneField.text forKey:@"phoneNo"];
    [req addPostValue:_nPassword.text forKey:@"password"];
    req.delegate = self;
    req.tag = 101;
    [req startAsynchronous];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    Debug(@"%@",request.responseString);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (request.responseStatusCode == 200) {
        NSDictionary *dic = [request.responseString JSONValue];
        if ([[dic objectForKey:@"resultCode"] intValue] == 1) {
            if (request.tag == 100) {
                self.verifyCodeStr = [dic objectForKey:@"info"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请求发送成功，注意查收验证码短信！" 
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"设置密码成功！" 
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
        }else {
            Debug(@"%@",[dic objectForKey:@"resultInfo"]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:[dic objectForKey:@"resultInfo"] 
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
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
