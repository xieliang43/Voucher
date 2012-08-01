//
//  XLSinaAuthorizeController.m
//  CTCouponProject
//
//  Created by xie liang on 7/17/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import "XLSinaAuthorizeController.h"
#import "XLSinaEngine.h"

@interface XLSinaAuthorizeController ()

@end

@implementation XLSinaAuthorizeController

@synthesize engine = _engine;
@synthesize delegate = _delegate;

- (void)dealloc
{
    [_engine release];
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
    titleLabel.text = @"分享到新浪";
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

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setNavigationBar];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 416)];
    webView.delegate = self;
    [self.view addSubview:webView];
    [webView release];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?client_id=%@&response_type=code&redirect_uri=%@&display=mobile",SINA_AUTHORIZE_URL,SINA_APP_KEY,SINA_REDIRECT_URI];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request 
 navigationType:(UIWebViewNavigationType)navigationType
{
    NSRange range = [request.URL.absoluteString rangeOfString:@"code="];
    
    if (range.location != NSNotFound)
    {
        NSString *code = [request.URL.absoluteString substringFromIndex:range.location + range.length];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@?client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",SINA_ACCESS_TOKEN_URL,SINA_APP_KEY,SINA_APP_SECRET,SINA_REDIRECT_URI,code];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
        [req setHTTPMethod:@"POST"];
        NSURLConnection *con = [NSURLConnection connectionWithRequest:req delegate:self];
        [con start];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        return NO;
    }else {
        return YES;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *resultStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSDictionary *tempDic = [resultStr JSONValue];
    NSString *uid = [[tempDic objectForKey:@"uid"] retain];
    NSString *access_token = [[tempDic objectForKey:@"access_token"] retain];
    double expires = [[tempDic objectForKey:@"expires_in"] doubleValue]+[[NSDate date] timeIntervalSince1970];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:uid forKey:@"uid"];
    [dic setObject:access_token forKey:@"access_token"];
    [dic setObject:[NSNumber numberWithDouble:expires] forKey:@"expires"];
    [_engine saveSinaInfo:dic];
    
    if ([_delegate respondsToSelector:@selector(didAuthorizeSina)]) {
        [_delegate didAuthorizeSina];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([_delegate respondsToSelector:@selector(didFialdAuthorizeSina)]) {
        [_delegate didFialdAuthorizeSina];
    }
}

@end
