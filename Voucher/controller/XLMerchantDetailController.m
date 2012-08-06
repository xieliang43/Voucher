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
@synthesize logoView = _logoView;
@synthesize nameLabel = _nameLabel;
@synthesize addressLabel = _addressLabel;
@synthesize numButton = _numButton;

- (void)dealloc
{
    [_tableView release];
    [_merchantInfo release];
    [_dataArray release];
    [_logoView release];
    [_nameLabel release];
    [_addressLabel release];
    [_numButton release];
    
    [_queue release];
    
    [_sinaEngine release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:2];
        
        _sinaEngine = [[XLSinaEngine alloc] init];
        _sinaEngine.delegate = self;
        _sinaEngine.rootViewController = self;
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
    
    _nameLabel.text = [_merchantInfo objectForKey:@"shopName"];
    _addressLabel.text = [_merchantInfo objectForKey:@"shopAddress"];
    NSString *str = [NSString stringWithFormat:@"电话：%@",[_merchantInfo objectForKey:@"telNo"]];
    [_numButton setTitle:str forState:UIControlStateNormal];
    
    NSString *imageUrlStr = [_merchantInfo objectForKey:@"image"];
    UIImage *image = [UIImage imageWithData:[XLTools readFileToCache:[XLTools md5:imageUrlStr]]];
    if (image) {
        _logoView.image = image;
    } else {
        NSURL *url = [NSURL URLWithString:imageUrlStr];
        CTLoadImageOperation *operation = [[CTLoadImageOperation alloc] initWithUrl:url
                                                                             target:self
                                                                             action:@selector(didLoadImage:) 
                                                                          indexPath:nil];
        [_queue addOperation:operation];
        [operation release];
    }
    
    NSString *urlStr = [XLTools getInterfaceByKey:@"get_vouchers"];
    Debug(@"%@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:url];
    req.delegate = self;
    req.requestMethod = @"POST";
    [req setPostValue:[_merchantInfo objectForKey:@"id"] forKey:@"shopId"];
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

- (IBAction)shareToSina:(id)sender
{
    [_sinaEngine loginSina];
}

- (IBAction)makeCall:(id)sender
{
    Debug(@"call label");
    NSString *urlStr = [NSString stringWithFormat:@"tel:%@",[_merchantInfo objectForKey:@"telNo"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}

- (IBAction)displayDescription:(id)sender
{
    Debug(@"role");
    XLRoleViewController *roleController = [[XLRoleViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:roleController animated:YES];
    [roleController release];
}

#pragma mark - NSOperation 回调
- (void)didLoadImage:(NSDictionary *)info
{
    if ([info objectForKey:@"image"]) {
        _logoView.image = [info objectForKey:@"image"];
        NSData *data = UIImageJPEGRepresentation([info objectForKey:@"image"], 1.0);
        NSString *path = [_merchantInfo objectForKey:@"image"];
        [XLTools saveFileToCache:data withName:[XLTools md5:path]];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
//delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLVoucherCell *cell = nil;
    static NSString *cellId = @"XLVoucherCell";
    
    cell = (XLVoucherCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XLVoucherCell" owner:self options:nil] lastObject];
    }
    NSDictionary *infoDic = [_dataArray objectAtIndex:indexPath.row];
    cell.priceLabel.text = [[infoDic objectForKey:@"price"] stringValue];
    cell.noLabel.text = [infoDic objectForKey:@"vchNo"];
    cell.dateLabel.text = [infoDic objectForKey:@"endDate"];
    cell.index = indexPath.row;
    [cell setBought:[[infoDic objectForKey:@"isBought"] intValue]];
    cell.delegate = self;
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
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    Debug(@"%@",request.responseString);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (request.responseStatusCode == 200) {
        NSDictionary *dic = [request.responseString JSONValue];
        if ([[dic objectForKey:@"resultCode"] intValue] == 1) {
            NSDictionary *dataDic = [dic objectForKey:@"info"];
            //int total = [[dataDic objectForKey:@"total"] intValue];
            //int rest = [[dataDic objectForKey:@"rest"] intValue];
            //_numLabel.text = [NSString stringWithFormat:@"剩%d张/共%d张",rest,total];
            _dataArray = [[dataDic objectForKey:@"vouchers"] retain];
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
        Debug(@"%d",request.responseStatusCode);
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

#pragma mark - XLVoucherCellDelegate
- (void)didPressPurchase:(XLVoucherCell *)cell
{
    NSIndexPath *path = [_tableView indexPathForCell:cell];
    NSDictionary *infoDic = [_dataArray objectAtIndex:path.row];
    
    NSString *urlStr = [XLTools getInterfaceByKey:@"purchase"];
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:url];
    req.delegate = self;
    req.requestMethod = @"POST";
    req.userInfo = [NSDictionary dictionaryWithObject:path forKey:@"indexPath"];
    [req setDidFinishSelector:@selector(didRequestFinish:)];
    [req setDidFailSelector:@selector(didRequestFail:)];
    [req setPostValue:[infoDic objectForKey:@"viId"] forKey:@"viId"];
    [req addDefaultPostValue];
    [req startAsynchronous];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didRequestFinish:(ASIHTTPRequest *)request
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *infoDic = [request.responseString JSONValue];
    NSIndexPath *path = (NSIndexPath *)[request.userInfo objectForKey:@"indexPath"];
    XLVoucherCell *cell = (XLVoucherCell *)[_tableView cellForRowAtIndexPath:path];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:[infoDic objectForKey:@"resultInfo"]
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    if ([[infoDic objectForKey:@"info"] intValue] == 1) {
        [cell setBought:1];
    }
    if ([[infoDic objectForKey:@"info"] intValue] == 0) {
        [cell setBought:0];
    }
}

- (void)didRequestFail:(ASIHTTPRequest *)request
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

#pragma mark - XLSinaEngineDelegate
- (void)didLoginSina
{
    [_sinaEngine sendStatus:@"aaaaaaaaaaaaaaaaa"];
}

- (void)didFialdLoginSina
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"登陆新浪微博失败！"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end
