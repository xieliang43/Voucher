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

- (void)dealloc
{
    [_dataArray release];
    [_merchantType release];
    [_area release];
    [_distance release];
    
    [_merchantTypeBtn release];
    [_areaBtn release];
    [_distanceBtn release];
    [locationManager release];
    
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
    [searchField addTarget:self action:@selector(doSearch:) forControlEvents:UIControlEventEditingDidEndOnExit];
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
    
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;//设定为最佳精度  
        locationManager.distanceFilter = 100.0f;//响应位置变化的最小距离(m)  
        [locationManager startUpdatingLocation];  
    }else {
        [self doSearch:nil];
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

- (void)doSearch:(UITextField *)feild
{
    Debug(@"%@",feild.text);
    NSString *urlStr = [XLTools getInterfaceByKey:@"get_shops"];
    Debug(@"%@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:url];
    req.delegate = self;
    [req setDidFinishSelector:@selector(didFinishGetShops:)];
    [req setDidFailSelector:@selector(didFailGetShops:)];
    req.requestMethod = @"POST";
    [req setPostValue:_area forKey:@"area"];
    [req setPostValue:_distance forKey:@"distance"];
    [req setPostValue:_merchantType forKey:@"shopType"];
    [req setPostValue:[NSNumber numberWithInt:start] forKey:@"start"];
    [req setPostValue:[NSNumber numberWithInt:limit] forKey:@"limit"];
    [req setPostValue:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
    [req setPostValue:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
    [req setPostValue:feild.text forKey:@"keyword"];
    [req setPostValue:[[XLTools getCityInfo] objectForKey:@"id"] forKey:@"cityId"];
    [req startAsynchronous];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    latitude = newLocation.coordinate.latitude;
    longitude = newLocation.coordinate.longitude;
    [self doSearch:nil];
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
    if (request.responseStatusCode == 200) {
        NSDictionary *dic = [request.responseString JSONValue];
        if ([[dic objectForKey:@"resultCode"] intValue] == 1) {
            if (_dataArray) {
                [_dataArray release];
                _dataArray = nil;
            }
            _dataArray = [[dic objectForKey:@"info"] retain];
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
        _merchantType = [[NSString stringWithFormat:@"%d,oid"] retain];
        [_merchantTypeBtn setTitle:obj forState:UIControlStateNormal];
    }
}

@end
