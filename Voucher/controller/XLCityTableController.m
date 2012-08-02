//
//  XLCityTableController.m
//  Voucher
//
//  Created by xie liang on 7/16/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import "XLCityTableController.h"

@interface XLCityTableController ()

@end

@implementation XLCityTableController

@synthesize tableView = _tableView;
@synthesize currentCityLabel = _currentCityLabel;
@synthesize type = _type;

- (void)dealloc
{
    [_dataDic release];
    [_indexArray release];
    [_tableView release];
    [_currentCityLabel release];
    [areaInfo release];
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
    titleLabel.text = @"更改城市";
    [naviBar addSubview:titleLabel];
    [titleLabel release];
    
    if (_type == 0) {
        UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
        leftItem.frame = CGRectMake(10, 6, 51, 32);
        [leftItem setBackgroundImage:[UIImage imageNamed:@"red_btn.png"] forState:UIControlStateNormal];
        [leftItem setTitle:@"取消" forState:UIControlStateNormal];
        leftItem.titleLabel.font = [UIFont systemFontOfSize:16];
        [leftItem addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [naviBar addSubview:leftItem];
    }else {
        UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
        leftItem.frame = CGRectMake(10, 6, 51, 32);
        [leftItem setBackgroundImage:[UIImage imageNamed:@"go_back.png"] forState:UIControlStateNormal];
        [leftItem setTitle:@"返回" forState:UIControlStateNormal];
        leftItem.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
        leftItem.titleLabel.font = [UIFont systemFontOfSize:16];
        [leftItem addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
        [naviBar addSubview:leftItem];
    }
    
    UIButton *rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(320-10-51, 6, 51, 32);
    [rightItem setBackgroundImage:[UIImage imageNamed:@"red_btn.png"] forState:UIControlStateNormal];
    [rightItem setTitle:@"确定" forState:UIControlStateNormal];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightItem addTarget:self action:@selector(saveCity:) forControlEvents:UIControlEventTouchUpInside];
    [naviBar addSubview:rightItem];
}

- (void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)saveCity:(id)sender
{
    [XLTools saveCityInfo:areaInfo];
    if (_type == 0) {
        [self cancel:nil];
    }else {
        [self goBack:nil];
    }
    if ([XLTools isLogin]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CITY_INFO_CHANGE" object:nil userInfo:nil];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(NSInteger)type
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavigationBar];
    
    if (areaInfo) {
        [areaInfo release];
        areaInfo = nil;
    }
    areaInfo = [[XLTools getCityInfo] retain];
    _currentCityLabel.text = [areaInfo objectForKey:@"name"];
    
    _dataDic = [[NSMutableDictionary dictionary] retain];
    
    NSString *urlStr = [XLTools getInterfaceByKey:@"get_citys"];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:url];
    req.requestMethod = @"POST";
    req.delegate = self;
    [req startAsynchronous];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    Debug(@"%@",request.responseString);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (request.responseStatusCode == 200) {
        NSDictionary *dic = [request.responseString JSONValue];
        if ([[dic objectForKey:@"resultCode"] intValue] == 1) {
            _dataDic = [[dic objectForKey:@"info"] retain];
            _indexArray = [[_dataDic allKeys] retain];
            NSSortDescriptor* sortor = [[NSSortDescriptor alloc] initWithKey:@"" ascending:YES];
            NSArray* sortedDes = [[NSArray alloc] initWithObjects:&sortor count:1];
            _indexArray = [[_indexArray sortedArrayUsingDescriptors:sortedDes] retain];
            [sortor release];
            [sortedDes release];
            [_tableView reloadData];
        }else {
            Debug(@"%@",[dic objectForKey:@"resultInfo"]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"获取城市列表失败！"
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

#pragma mark - UITableViewDelegate & UITableViewDataSource
//datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_indexArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataDic objectForKey:[_indexArray objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_indexArray objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _indexArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLCityCell *cell = nil;
    static NSString *cellId = @"SETTING_CELL";
    cell = (XLCityCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = (XLCityCell *)[[[NSBundle mainBundle] loadNibNamed:@"XLCityCell" owner:self options:nil] lastObject];
    }
    NSDictionary *dic = [[_dataDic objectForKey:[_indexArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    if ([[[dic objectForKey:@"id"] stringValue] isEqualToString:[areaInfo objectForKey:@"id"]]) {
        cell.selectedView.hidden = NO;
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    cell.cityLabel.text = [dic objectForKey:@"name"];
    return cell;
}

//delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLCityCell *cell = (XLCityCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectedView.hidden = NO;
    
    NSDictionary *dic = [[_dataDic objectForKey:[_indexArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    if (areaInfo) {
        [areaInfo release];
        areaInfo = nil;
    }
    areaInfo = [dic retain];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLCityCell *cell = (XLCityCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectedView.hidden = YES;
}

@end
