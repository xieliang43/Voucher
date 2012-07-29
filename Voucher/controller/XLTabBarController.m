//
//  XLTabController.m
//  Voucher
//
//  Created by xie liang on 7/13/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import "XLTabBarController.h"

@interface XLTabController ()

@end

@implementation XLTabController

@synthesize controllers = _controllers;

- (void)dealloc
{
    [_tabBar release];
    [_controllers release];
    [_containerView release];
    [_itemBgView release];
    
    [_packageItem release];
    [_homeItem release];
    [_moreItem release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CGRect f = [[UIScreen mainScreen] applicationFrame];
        _tabBar = [[UIView alloc] initWithFrame:CGRectMake(0, f.size.height - 44, 320, 44)];
        _tabBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_bg.png"]];
        [self.view addSubview:_tabBar];
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, f.size.height - 44)];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.clipsToBounds = YES;
        [self.view addSubview:_containerView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
	// Do any additional setup after loading the view.
    
    selectedIndex = 1;

    _itemBgView = [[UIImageView alloc] initWithFrame:CGRectMake(121, 0, 78, 44)];
    _itemBgView.image = [UIImage imageNamed:@"tab_sel_bg.png"];
    [_tabBar addSubview:_itemBgView];
    
    _packageItem = [[XLTabBarItem alloc] initWithFrame:CGRectMake(43, 0, 78, 44)];
    _packageItem.itemLabel.text = @"钱包";
    _packageItem.itemImageView.image = [UIImage imageNamed:@"poket_tab_item.png"];
    _packageItem.tag = 0;
    _packageItem.delegate = self;
    [_tabBar addSubview:_packageItem];
    
    _homeItem = [[XLTabBarItem alloc] initWithFrame:CGRectMake(121, 0, 78, 44)];
    _homeItem.itemLabel.text = @"首页";
    _homeItem.itemImageView.image = [UIImage imageNamed:@"home_tab_item.png"];
    _homeItem.tag = 1;
    _homeItem.delegate = self;
    [_tabBar addSubview:_homeItem];
    
    _moreItem = [[XLTabBarItem alloc] initWithFrame:CGRectMake(199, 0, 78, 44)];
    _moreItem.itemLabel.text = @"更多";
    _moreItem.itemImageView.image = [UIImage imageNamed:@"set_tab_item.png"];
    _moreItem.tag = 2;
    _moreItem.delegate = self;
    [_tabBar addSubview:_moreItem];
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

- (void)setControllers:(NSArray *)controllers
{
    if (controllers != _controllers) {
        [_controllers release];
        _controllers = nil;
    }
    
    _controllers = [controllers retain];
    
    UIView *v = ((UIViewController *)[_controllers objectAtIndex:selectedIndex]).view;
    v.frame = _containerView.bounds;
    [_containerView addSubview:v];
}

#pragma mark - XLTabBarItemDelegate
- (void)didSelectItem:(XLTabBarItem *)item
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.2];
    _itemBgView.frame = item.frame;
    [UIView commitAnimations];
    
    UIViewController *controller = [_controllers objectAtIndex:selectedIndex];
    [controller.view removeFromSuperview];
    selectedIndex = item.tag;
    controller = (UIViewController *)[_controllers objectAtIndex:selectedIndex];
    if ([controller isKindOfClass:[XLMoreController class]]) {
        ((XLMoreController *)controller).tabController = self;
    }
    UIView *v = controller.view;
    v.frame = _containerView.bounds;
    [_containerView addSubview:v];
}

- (void)hideMyTabBar
{
    CGRect frame = _containerView.frame;
    frame.size.height = 460;
    _containerView.frame = frame;
    [UIView beginAnimations:@"HIDE_TABBAR" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.2];
    _tabBar.hidden = YES;
    [UIView commitAnimations];
}

- (void)displayMyTabBar
{
    CGRect frame = _containerView.frame;
    frame.size.height = 416;
    _containerView.frame = frame;
    [UIView beginAnimations:@"DISPLAY_TABBAR" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.2];
    _tabBar.hidden = NO;
    [UIView commitAnimations];
}

@end
