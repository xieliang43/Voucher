//
//  XLPocketController.m
//  Voucher
//
//  Created by xie liang on 7/13/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import "XLPocketController.h"

@interface XLPocketController ()

@end

@implementation XLPocketController

@synthesize tableView = _tableView;

- (void)dealloc
{
    [_tableView release];
    [_dataArray release];
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
    titleLabel.text = @"钱包";
    [naviBar addSubview:titleLabel];
    [titleLabel release];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.myTabController displayMyTabBar];
    
    NSString *urlStr = [XLTools getInterfaceByKey:@"getWallet"];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:url];
    req.delegate = self;
    req.requestMethod = @"POST";
    [req addDefaultPostValue];
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

#pragma mark - UITableViewDelegate & UITableViewDataSource
//datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLPocketCell *cell = nil;
    static NSString *cellId = @"CELLID";
    cell = (XLPocketCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = (XLPocketCell *)[[[NSBundle mainBundle] loadNibNamed:@"XLPocketCell" 
                                                              owner:self options:nil] lastObject];
    }
    NSDictionary *infoDic = [_dataArray objectAtIndex:indexPath.row];
    cell.priceLabel.text = [[infoDic objectForKey:@"price"] stringValue];
    cell.noLabel.text = [infoDic objectForKey:@"vchNo"];
    cell.dateLabel.text = [infoDic objectForKey:@"endDate"];
    cell.merchantLabel.text = [infoDic objectForKey:@"name"];
    if ([[infoDic objectForKey:@"isUsed"] intValue] == 1) {
        cell.flagView.image = [UIImage imageNamed:@"poket_uesed.png"];
    }else if ([[infoDic objectForKey:@"isActive"] intValue] == 0) {
        cell.flagView.image = [UIImage imageNamed:@"poket_guoqi.png"];
    }else {
        cell.flagView.image = [UIImage imageNamed:@"poket_ues.png"];
    }
    NSString *imageUrlStr = [infoDic objectForKey:@"image"];
    UIImage *image = [UIImage imageWithData:[XLTools readFileToCache:[XLTools md5:imageUrlStr]]];
    if (!image) {
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
    return 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d",indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *infoDic = [_dataArray objectAtIndex:indexPath.row];
    if ([[infoDic objectForKey:@"isUsed"] intValue] == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"该代金券已经被使用！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if ([[infoDic objectForKey:@"isActive"] intValue] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"该代金券已经过期！"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else {
        [self.myTabController hideMyTabBar];
        XLUseVoucherController *useVoucher = [[XLUseVoucherController alloc] initWithNibName:nil bundle:nil];
        useVoucher.voucher = infoDic;
        [self.navigationController pushViewController:useVoucher animated:YES];
        [useVoucher release];
    }
}

#pragma mark - NSOperation 回调
- (void)didLoadImage:(NSDictionary *)info
{
    NSIndexPath *indexPath = [info objectForKey:@"indexPath"];
    if ([info objectForKey:@"image"]) {
        NSData *data = UIImageJPEGRepresentation([info objectForKey:@"image"], 1.0);
        NSString *path = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"image"];
        [XLTools saveFileToCache:data withName:[XLTools md5:path]];
    }
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    Debug(@"%@",request.responseString);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (request.responseStatusCode == 200) {
        NSDictionary *dic = [request.responseString JSONValue];
        if ([[dic objectForKey:@"resultCode"] intValue] == 1) {
            _dataArray = [[dic objectForKey:@"info"] retain];
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

@end
