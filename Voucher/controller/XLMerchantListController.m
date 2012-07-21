//
//  XLMerchantListController.m
//  Voucher
//
//  Created by xie liang on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XLMerchantListController.h"

@interface XLMerchantListController ()

@end

@implementation XLMerchantListController

- (void)setNavigationBar
{
    UIView *naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    naviBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navi_bg.png"]];
    [self.view addSubview:naviBar];
    [naviBar release];
    
    UIImageView *searchBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 300, 28)];
    searchBg.image = [UIImage imageNamed:@"search_bg.png"];
    [naviBar addSubview:searchBg];
    [searchBg release];
    
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 14, 15)];
    searchIcon.image = [UIImage imageNamed:@"search_icon.png"];
    [naviBar addSubview:searchIcon];
    [searchIcon release];
    
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, 270, 44)];
    searchField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchField.font = [UIFont systemFontOfSize:16];
    searchField.returnKeyType = UIReturnKeySearch;
    [searchField addTarget:self action:@selector(doSearch:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [naviBar addSubview:searchField];
    [searchField release];
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

#pragma mark -
- (IBAction)displayOptions:(id)sender
{
    XLOptionSelectorView *selector = [[XLOptionSelectorView alloc] initWithFrame:CGRectMake(0, 44, 320, 416-44)];
    [self.view addSubview:selector];
    [selector release];
}

- (void)doSearch:(UITextField *)feild
{
    Debug(@"%@",feild.text);
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
//datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *cellId = @"CELLID";
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell= (XLMerchantCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"XLMerchantCell" owner:self options:nil]  lastObject];
    }
    if (indexPath.row%2 == 0) {
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_list_selected.png"]];
    }else {
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_list_nor.png"]];
    }
    
    return cell;
}

//delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
