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

- (void)dealloc
{
    [_dataDic release];
    [_indexArray release];
    [_tableView release];
    [_currentCityLabel release];
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
    
    if (areaCode) {
        [areaCode release];
        areaCode = nil;
    }
    areaCode = [[[[XLTools getCityInfo] objectForKey:@"id"] stringValue] retain];
    _currentCityLabel.text = [[XLTools getCityInfo] objectForKey:@"name"];
    
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
            NSArray *dataArray = [[dic objectForKey:@"info"] retain];
            NSSet *set = [NSSet setWithArray:[dataArray valueForKey:@"cityPrefix"]];
            NSMutableArray *tmpArray = [NSMutableArray array];
            for (NSString *key in set) {
                NSMutableArray *tmpArr = [NSMutableArray array];
                [_dataDic setValue:tmpArr forKey:key];
                [tmpArray addObject:key];
            }
            for (NSDictionary *dic in dataArray) {
                NSMutableArray *tmpArr = [_dataDic objectForKey:[dic objectForKey:@"cityPrefix"]];
                [tmpArr addObject:dic];
            }
            NSSortDescriptor* sortor = [[NSSortDescriptor alloc] initWithKey:@"" ascending:YES];
            NSArray* sortedDes = [[NSArray alloc] initWithObjects:&sortor count:1];
            _indexArray = [[tmpArray sortedArrayUsingDescriptors:sortedDes] retain];
            [sortor release];
            [sortedDes release];
            [_tableView reloadData];
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
    if ([[[dic objectForKey:@"id"] stringValue] isEqualToString:areaCode]) {
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
    if (areaCode) {
        [areaCode release];
        areaCode = nil;
    }
    areaCode = [[[dic objectForKey:@"id"] stringValue] retain];
    _currentCityLabel.text = [dic objectForKey:@"name"];
    [XLTools saveCityInfo:dic];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLCityCell *cell = (XLCityCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectedView.hidden = YES;
}

@end
