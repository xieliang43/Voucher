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

@synthesize merchantTypeBtn = _merchantTypeBtn;
@synthesize areaBtn = _areaBtn;
@synthesize distanceBtn = _distanceBtn;
@synthesize tableView = _tableView;

- (void)dealloc
{
    [_dataArray release];
    [_merchantType release];
    [_area release];
    [_distance release];
    
    [_merchantTypeBtn release];
    [_areaBtn release];
    [_distanceBtn release];
    [_tableView release];
    
    [_queue release];
    
    [_refreshHeaderView release];
    [_loadMoreFooterView release];
    
    [_keyWord release];
    
    [super dealloc];
}

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
    [searchField addTarget:self action:@selector(willSearch:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [naviBar addSubview:searchField];
    [searchField release];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        start = 0;
        limit = 15;
        
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:2];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigationBar];
    
    //获取地域列表
    NSString *urlStr = [XLTools getInterfaceByKey:@"merchant_type"];
    Debug(@"%@",urlStr);
    ASIFormDataRequest *req1 = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    req1.requestMethod = @"POST";
    req1.delegate = self;
    req1.tag = 1000;
    [req1 startAsynchronous];
    
    //获取距离列表
    urlStr = [XLTools getInterfaceByKey:@"distance_type"];
    Debug(@"%@",urlStr);
    ASIFormDataRequest *req2 = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    req2.requestMethod = @"POST";
    req2.delegate = self;
    req2.tag = 1001;
    [req2 startAsynchronous];
    
    //获取区域列表
    urlStr = [XLTools getInterfaceByKey:@"area_type"];
    Debug(@"%@",urlStr);
    ASIFormDataRequest *req3 = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlStr]];
    req3.requestMethod = @"POST";
    req3.delegate = self;
    req3.tag = 1002;
    [req3 setPostValue:[[XLTools getCityInfo] objectForKey:@"id"] forKey:@"cityId"];
    [req3 startAsynchronous];
    
    _dataArray = [[NSMutableArray array] retain];
    [self doSearch]; 
    
    if (_refreshHeaderView == nil) {
		_refreshHeaderView = [[WZRefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		_refreshHeaderView.delegate = self;
		[self.tableView addSubview:_refreshHeaderView];
	}
	[_refreshHeaderView refreshLastUpdatedDate];
    
}

- (void)showLoadMoreFooterView
{
    if (_total > [_dataArray count]) {
        if (_loadMoreFooterView == nil) {
            _loadMoreFooterView = [[WZLoadMoreTableFooterView alloc] init];
            _loadMoreFooterView.delegate = self;
            [self.tableView addSubview:_loadMoreFooterView];
        }
        _loadMoreFooterView.frame = CGRectMake(0.0f, self.tableView.contentSize.height, self.view.frame.size.width, self.tableView.bounds.size.height);
        [_loadMoreFooterView loadmoreLastUpdatedDate];
    }else {
        if (_loadMoreFooterView) {
            [_loadMoreFooterView removeFromSuperview];
            [_loadMoreFooterView release];
            _loadMoreFooterView = nil;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
- (IBAction)displayOptions:(UIButton *)sender
{
    Debug(@"%d",sender.tag);
    XLOptionSelectorView *selector = [[XLOptionSelectorView alloc] initWithFrame:CGRectMake(0, 44, 320, 416-44)];
    selector.delegate = self;
    if (sender.tag == 300) {
        selector.titleLabel.text = @"地域";
        selector.optionType = AREA_TYPE;
        selector.optionArray = [XLTools readAreaType];
    }
    if (sender.tag == 301) {
        selector.titleLabel.text = @"距离";
        selector.optionType = DISTANCE_TYPE;
        selector.optionArray = [XLTools readDistanceType];
    }
    if (sender.tag == 302) {
        selector.titleLabel.text = @"类别";
        selector.optionType = MERCHANT_TYPE;
        selector.optionArray = [XLTools readMerchantType];
    }
    [selector loadData];
    [self.view addSubview:selector];
    [selector release];
}

- (void)willSearch:(UITextField *)feild
{
    start = 0;
    _keyWord = [feild.text retain];
    [self doSearch];
}

- (void)doSearch
{
    NSString *urlStr = [XLTools getInterfaceByKey:@"get_shops"];
    Debug(@"%@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:url];
    req.delegate = self;
    [req setDidFinishSelector:@selector(didFinishGetShops:)];
    [req setDidFailSelector:@selector(didFailGetShops:)];
    req.requestMethod = @"POST";
    [req setPostValue:_area forKey:@"areaId"];
    [req setPostValue:_distance forKey:@"distance"];
    [req setPostValue:_merchantType forKey:@"shopTypeId"];
    [req setPostValue:[NSString stringWithFormat:@"%d",start] forKey:@"start"];
    [req setPostValue:[NSString stringWithFormat:@"%d",limit] forKey:@"limit"];
    [req setPostValue:[[XLTools userLocation] objectForKey:@"longitude"] forKey:@"longitude"];
    Debug(@"%@",[[XLTools userLocation] objectForKey:@"longitude"]);
    [req setPostValue:[[XLTools userLocation] objectForKey:@"latitude"] forKey:@"latitude"];
    Debug(@"%@",[[XLTools userLocation] objectForKey:@"latitude"]);
    [req setPostValue:_keyWord forKey:@"keyword"];
    [req setPostValue:[[XLTools getCityInfo] objectForKey:@"id"] forKey:@"cityId"];
    [req startAsynchronous];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
//datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLMerchantCell *cell = nil;
    static NSString *cellId = @"CELLID";
    cell = (XLMerchantCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell= (XLMerchantCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"XLMerchantCell" owner:self options:nil]  lastObject];
    }
    
    if (indexPath.row%2 == 0) {
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_list_selected.png"]];
    }else {
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_list_nor.png"]];
    }
    
    NSDictionary *tmpDic = [_dataArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = [tmpDic objectForKey:@"shopName"];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm",[[tmpDic objectForKey:@"distance"] intValue]/1000.0];
    cell.addressLabel.text = [tmpDic objectForKey:@"shopAddress"];
    
    NSString *imageUrlStr = [tmpDic objectForKey:@"image"];
    UIImage *image = [UIImage imageWithData:[XLTools readFileToCache:[XLTools md5:imageUrlStr]]];
    if (image) {
        cell.logoView.image = image;
    } else {
        NSURL *url = [NSURL URLWithString:imageUrlStr];
        CTLoadImageOperation *operation = [[CTLoadImageOperation alloc] initWithUrl:url
                                                                             target:self
                                                                             action:@selector(didLoadImage:) 
                                                                          indexPath:indexPath];
        [_queue addOperation:operation];
        [operation release];
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
    XLMerchantDetailController *detailCon = [[XLMerchantDetailController alloc] initWithNibName:nil bundle:nil];
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    detailCon.merchantInfo = dic;
    [self.navigationController pushViewController:detailCon animated:YES];
    [detailCon release];
}

#pragma mark - NSOperation 回调
- (void)didLoadImage:(NSDictionary *)info
{
    NSIndexPath *indexPath = [info objectForKey:@"indexPath"];
    XLMerchantCell *cell = (XLMerchantCell *)[_tableView cellForRowAtIndexPath:indexPath];
    if ([info objectForKey:@"image"]) {
        cell.logoView.image = [info objectForKey:@"image"];
        NSData *data = UIImageJPEGRepresentation([info objectForKey:@"image"], 1.0);
        NSString *path = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"image"];
        [XLTools saveFileToCache:data withName:[XLTools md5:path]];
    }
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    Debug(@"%@",request.responseString);
    if (request.responseStatusCode == 200) {
        NSDictionary *dic = [request.responseString JSONValue];
        if ([[dic objectForKey:@"resultCode"] intValue] == 1) {
            switch (request.tag) {
                case 1000:
                {
                    [XLTools writeMerchantTypeToFile:[dic objectForKey:@"info"]];
                    break;
                }
                case 1001:
                {
                    [XLTools writeDistanceTypeToFile:[dic objectForKey:@"info"]];
                    break;
                }
                case 1002:
                {
                    [XLTools writeAreaTypeToFile:[dic objectForKey:@"info"]];
                    break;
                }
                default:
                    break;
            }
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}

- (void)didFinishGetShops:(ASIFormDataRequest *)request
{
    Debug(@"%@",request.responseString);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self doneLoadingTableViewData];
    [self doneLoadMoreTableViewData];
    if (request.responseStatusCode == 200) {
        NSDictionary *dic = [request.responseString JSONValue];
        if ([[dic objectForKey:@"resultCode"] intValue] == 1) {
            NSArray *tmpArray = [[dic objectForKey:@"info"] objectForKey:@"shops"];
            if (start == 0) {
                [_dataArray removeAllObjects];
            }
            [_dataArray addObjectsFromArray:tmpArray];
            [_tableView reloadData];
            _total = [[[dic objectForKey:@"info"] objectForKey:@"total"] intValue];
            [self showLoadMoreFooterView];
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

- (void)didFailGetShops:(ASIFormDataRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self doneLoadingTableViewData];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"请检查网络链接或联系管理员！" 
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark - XLOptionSelectorDelegate
- (void)didSelect:(NSInteger)oid value:(NSString *)obj type:(OptionType)oType
{
    if (oType == AREA_TYPE) {
        _area = [[NSString stringWithFormat:@"%d",oid] retain];
        [_areaBtn setTitle:obj forState:UIControlStateNormal];
    }else if (oType == DISTANCE_TYPE) {
        _distance = [obj retain];
        NSString *disString = [NSString stringWithFormat:@"%@米",obj];
        [_distanceBtn setTitle:disString forState:UIControlStateNormal];
    }else {
        _merchantType = [[NSString stringWithFormat:@"%d",oid] retain];
        [_merchantTypeBtn setTitle:obj forState:UIControlStateNormal];
    }
    start = 0;
    [self doSearch];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView wzRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}

- (void)loadMoreTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

- (void)doneLoadMoreTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_loadMoreFooterView wzLoadMoreScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView wzRefreshScrollViewDidScroll:scrollView];
    [_loadMoreFooterView wzLoadMoreScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView wzRefreshScrollViewDidEndDragging:scrollView];
	[_loadMoreFooterView wzLoadMoreScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)wzRefreshTableHeaderDidTriggerRefresh:(WZRefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    start = 0;
	[self doSearch];
}

- (BOOL)wzRefreshTableHeaderDataSourceIsLoading:(WZRefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)wzRefreshTableHeaderDataSourceLastUpdated:(WZRefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark -
#pragma mark WZLoadMoreTableFooterDelegate Methods
- (void)wzLoadMoreTableHeaderDidTriggerRefresh:(WZLoadMoreTableFooterView*)view {
    
	[self loadMoreTableViewDataSource];
	start += 1;
    [self doSearch];
}

- (BOOL)wzLoadMoreTableHeaderDataSourceIsLoading:(WZLoadMoreTableFooterView*)view {
    return _reloading;
}

- (NSDate*)wzLoadMoreTableHeaderDataSourceLastUpdated:(WZLoadMoreTableFooterView*)view {
    return [NSDate date]; // should return date data source was last changed
}

@end
