//
//  XLAdviseController.m
//  Voucher
//
//  Created by xie liang on 12-7-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XLAdviseController.h"

@interface XLAdviseController ()

@end

@implementation XLAdviseController

@synthesize contentView = _contentView;

- (void)dealloc
{
    [_contentView release];
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
    titleLabel.text = @"意见反馈";
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

- (IBAction)sendAdvise:(id)sender
{
    
}

@end
