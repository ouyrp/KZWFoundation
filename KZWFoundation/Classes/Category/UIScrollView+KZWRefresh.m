//
//  UIScrollView+KZWRefresh.m
//  kongzhongfinancial
//
//  Created by ouy on 2017/3/23.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import "UIScrollView+KZWRefresh.h"
#import "KZWConstants.h"
#import "UIColor+KZWColor.h"
#import <MJRefresh/MJRefresh.h>

@implementation UIScrollView (KZWRefresh)

- (void)addHeaderRefreshWithCallback:(nullable void (^)())callback {
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:callback];
    [refreshHeader setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [refreshHeader setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [refreshHeader setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
    refreshHeader.stateLabel.font = [UIFont systemFontOfSize:12];
    refreshHeader.labelLeftInset = 15;
    refreshHeader.stateLabel.textColor = [UIColor colorWithHexString:@"8d8d8d"];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    self.mj_header = refreshHeader;
}

- (void)addFooterRefreshWithCallback:(nullable void (^)())callback {
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:callback];
    [refreshFooter setTitle:@"" forState:MJRefreshStateIdle];
    [refreshFooter setTitle:@"" forState:MJRefreshStateRefreshing];
    [refreshFooter setTitle:@"" forState:MJRefreshStateNoMoreData];
    refreshFooter.refreshingTitleHidden = YES;
    refreshFooter.triggerAutomaticallyRefreshPercent = 0.2;
    self.mj_footer = refreshFooter;
}


- (void)headerBeginRefreshing {
    [self.mj_header beginRefreshing];
}

- (void)footerBeginRefreshing {
    [self.mj_footer beginRefreshing];
}

- (void)headerEndRefreshing {
    [self.mj_header endRefreshing];
}

- (void)footerEndRefreshing {
    [self.mj_footer endRefreshing];
}

@end
