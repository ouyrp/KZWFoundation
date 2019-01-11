//
//  UIScrollView+KZWRefresh.h
//  kongzhongfinancial
//
//  Created by ouy on 2017/3/23.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (KZWRefresh)

- (void)addHeaderRefreshWithCallback:(nullable void (^)())callback;

- (void)addFooterRefreshWithCallback:(nullable void (^)())callback;

- (void)headerBeginRefreshing;

- (void)footerBeginRefreshing;

- (void)headerEndRefreshing;

- (void)footerEndRefreshing;

@end
