//
//  XLOptionSelectorView.h
//  Voucher
//
//  Created by xie liang on 7/13/12.
//  Copyright (c) 2012 pretang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    AREA_TYPE = 1,
    DISTANCE_TYPE = 2,
    CLASS_TYPE = 3
}OptionType;

@protocol XLOptionSelectorDelegate <NSObject>

- (void)didSelectIndex:(NSInteger)index type:(OptionType)oType;

@end

@interface XLOptionSelectorView : UIView
<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *_titleLabel;
    NSArray *_optionArray;
    UITableView *_optionTable;
    OptionType _optionType;
    id<XLOptionSelectorDelegate> _delegate;
}

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) NSArray *optionArray;
@property (nonatomic,assign) OptionType optionType;
@property (nonatomic,assign) id<XLOptionSelectorDelegate> delegate;

@end
