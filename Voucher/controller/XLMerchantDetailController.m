//
//  XLMerchantDetailController.m
//  Voucher
//
//  Created by xie liang on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XLMerchantDetailController.h"

@interface XLMerchantDetailController ()

@end

@implementation XLMerchantDetailController

@synthesize tableView = _tableView;
@synthesize merchantInfo = _merchantInfo;

- (void)dealloc
{
    [_tableView release];
    [_merchantInfo release];
    [_dataArray release];
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
    titleLabel.text = @"商家详情";
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

#pragma mark - UITableViewDelegate & UITableViewDataSource
//datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 2;
    }else {
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *cellId = @"DETAIL_CELL";
    
    switch (indexPath.section) {
        case 0:
        {
            XLMerchantInfoCell *infoCell = nil;
            infoCell = (XLMerchantInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
            if (!infoCell) {
                infoCell = [[[NSBundle mainBundle] loadNibNamed:@"XLMerchantInfoCell" owner:self options:nil] lastObject];
            }
            cell = infoCell;
            break;
        }
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId] autorelease];
            }
            if (indexPath.row == 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"电话：%@",@"123123123"];
            }else {
                cell.textLabel.text = @"商家简介";
            }
            break;
        }
        case 2:
        {
            XLVoucherCell *voucherCell = nil;
            voucherCell = (XLVoucherCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
            if (!voucherCell) {
                voucherCell = [[[NSBundle mainBundle] loadNibNamed:@"XLVoucherCell" owner:self options:nil] lastObject];
            }
            cell = voucherCell;
            break;
        }
        default:
            break;
    }
    return cell;
}

//delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 75;
    }else if (indexPath.section == 1) {
        return 44;
    }else {
        return 88;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
