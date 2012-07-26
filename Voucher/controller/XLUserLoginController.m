//
//  XLUserLoginController.m
//  Voucher
//
//  Created by xie liang on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XLUserLoginController.h"

@interface XLUserLoginController ()

@end

@implementation XLUserLoginController

@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;

- (void)dealloc
{
    [_usernameField release];
    [_passwordField release];
    [super dealloc];
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
    titleLabel.text = @"登陆";
    [naviBar addSubview:titleLabel];
    [titleLabel release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(didDisplayKeyboard:) 
                                                     name:UIKeyboardDidShowNotification 
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didHideKeyboard:) 
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
    }
    return self;
}

- (void)didDisplayKeyboard:(NSNotification *)sender
{
    
}

- (void)didHideKeyboard:(NSNotification *)sender
{
    
}

- (IBAction)hideKeyboard:(id)sender
{
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![XLTools getCityInfo]) {
        XLCityTableController *cityController = [[XLCityTableController alloc] initWithNibName:nil bundle:nil type:0];
        [self presentModalViewController:cityController animated:YES];
        [cityController release];
    }
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

- (IBAction)processReturnKey:(UITextField *)sender
{
    [_passwordField resignFirstResponder];
}

#pragma mark - login and regist
- (IBAction)doRegist:(id)sender
{
    XLRegisterController *registerController = [[XLRegisterController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:registerController animated:YES];
    [registerController release];
}

- (IBAction)doLogin:(id)sender
{
    NSString *urlStr = [XLTools getInterfaceByKey:@"user_login"];
    Debug(@"%@",urlStr);
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    req.requestMethod = @"POST";
    req.delegate = self;
    [req addPostValue:_usernameField.text forKey:@"phoneNo"];
    [req addPostValue:_passwordField.text forKey:@"password"];
    [req addDefaultPostValue];
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
            [XLTools saveUserInfo:[dic objectForKey:@"info"]];
            [((XLAppDelegate *)[UIApplication sharedApplication].delegate) setTabBarAsRoot];
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
