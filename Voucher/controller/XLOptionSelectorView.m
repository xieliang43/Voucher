//
//  XLOptionSelectorView.m
//  Voucher
//
//  Created by xie liang on 7/13/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import "XLOptionSelectorView.h"

@implementation XLOptionSelectorView

@synthesize titleLabel = _titleLabel;
@synthesize optionArray = _optionArray;

- (void)dealloc
{
    [_titleLabel release];
    [_optionArray release];
    [_optionTable release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *maskView = [[UIView alloc] initWithFrame:self.bounds];
        maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
        [self addSubview:maskView];
        [maskView release];
        
        float x = (frame.size.width - 264)/2;
        float y = (frame.size.height - 337)/2;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(x, y, 264, 337)];
        bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"option_bg.png"]];
        [self addSubview:bgView];
        [bgView release];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(x+242, y-7, 29, 29);
        [closeBtn setImage:[UIImage imageNamed:@"optionClose.png"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeOption:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        
        self.clipsToBounds = YES;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 5, 250, 43)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.text = @"地域";
        [bgView addSubview:_titleLabel];
        
        
        _optionTable = [[UITableView alloc] initWithFrame:CGRectMake(6, 48, 250, 320-48)];
        _optionTable.backgroundColor = [UIColor clearColor];
        _optionTable.delegate = self;
        _optionTable.dataSource = self;
        _optionTable.separatorColor = [UIColor grayColor];
        [bgView addSubview:_optionTable];
    }
    return self;
}

- (void)closeOption:(id)sender
{
    [self removeFromSuperview];
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
        cell= [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId] autorelease];
    }
    
    return cell;
}

//delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
