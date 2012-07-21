//
//  XLMoreController.m
//  Voucher
//
//  Created by xie liang on 7/13/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import "XLMoreController.h"
#import "XLTabBarController.h"

@interface XLMoreController ()

@end

@implementation XLMoreController

@synthesize tabController = _tabController;
@synthesize tableView = _tableView;

- (void)dealloc
{
    [_tableView release];
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
    titleLabel.text = @"更多";
    [naviBar addSubview:titleLabel];
    [titleLabel release];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:path];
    cell.detailTextLabel.text = [[XLTools getCityInfo] objectForKey:@"name"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
//datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else {
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *cellId = @"CELLID";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.imageView.frame = CGRectMake(14, 14, 16, 16);
        cell.textLabel.frame = CGRectMake(44, 0, 180, 44);
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.textLabel.textColor = [UIColor blackColor];
        
        cell.detailTextLabel.frame = CGRectMake(220, 0, 100, 44);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:17];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:242/255.0 green:88/255.0 blue:49/255.0 alpha:1];
    }
    
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"more_city.png"];
        cell.textLabel.text = @"切换城市";
        cell.detailTextLabel.text = [[XLTools getCityInfo] objectForKey:@"name"];
    }else {
        switch (indexPath.row) {
            case 0:
            {
                cell.imageView.image = [UIImage imageNamed:@"more_fabu.png"];
                cell.textLabel.text = @"我要发布";
                break;
            }
            case 1:
            {
                cell.imageView.image = [UIImage imageNamed:@"more_yijiandakui.png"];
                cell.textLabel.text = @"意见反馈";
                break;
            }
            case 2:
            {
                cell.imageView.image = [UIImage imageNamed:@"more_clean.png"];
                cell.textLabel.text = @"清空缓存";
                break;
            }
            case 3:
            {
                cell.imageView.image = [UIImage imageNamed:@"more_about.png"];
                cell.textLabel.text = @"关于我们";
                break;
            }
            case 4:
            {
                cell.imageView.image = [UIImage imageNamed:@"more_exit.png"];
                cell.textLabel.text = @"退出登陆";
                break;
            }
            default:
                break;
        }
    }
    
    return cell;
}

//delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        //city select
        XLCityTableController *cityController = [[XLCityTableController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:cityController animated:YES];
        [cityController release];
    }else {
        switch (indexPath.row) {
            case 0:
            {
                XLPublishController *publishController = [[XLPublishController alloc] initWithNibName:nil bundle:nil];
                [self.navigationController pushViewController:publishController animated:YES];
                [publishController release];
                break;
            }
            case 1:
            {
                XLAdviseController *adviseController = [[XLAdviseController alloc] initWithNibName:nil bundle:nil];
                [self.navigationController pushViewController:adviseController animated:YES];
                [adviseController release];
                break;
            }
            case 2:
            {
                
                break;
            }
            case 3:
            {
                
                break;
            }
            case 4:
            {
                [XLTools deleteUserInfo];
                [(XLAppDelegate *)[UIApplication sharedApplication].delegate setLoginAsRoot];
                break;
            }
            default:
                break;
        }
    }
}

@end
