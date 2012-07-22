//
//  EGORefreshTableHeaderViewEX.h
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	EGOOPullRefreshPullingEX = 0,
	EGOOPullRefreshNormalEX,
	EGOOPullRefreshLoadingEX,	
} EGOPullRefreshStateEX;

@protocol EGORefreshTableHeaderDelegateEX;
@interface EGORefreshTableHeaderViewEX : UIView {
	
	id _delegate;
	EGOPullRefreshStateEX _state;

	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
	

}

@property(nonatomic,assign) id <EGORefreshTableHeaderDelegateEX> delegate;

- (void)refreshLastUpdatedDateEX;
- (void)egoRefreshScrollViewDidScrollEX:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDraggingEX:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoadingEX:(UIScrollView *)scrollView;

@end
@protocol EGORefreshTableHeaderDelegateEX
- (void)egoRefreshTableHeaderDidTriggerRefreshEX:(EGORefreshTableHeaderViewEX*)view;
- (BOOL)egoRefreshTableHeaderDataSourceIsLoadingEX:(EGORefreshTableHeaderViewEX*)view;
@optional
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdatedEX:(EGORefreshTableHeaderViewEX*)view;
@end
