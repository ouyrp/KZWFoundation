//
//  KZWViewController.h
//  KZWfinancial
//
//  Created by ouy on 2017/3/2.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZWViewController : UIViewController

@property (assign, nonatomic) BOOL navigationHidden;

- (void)showProgress;
- (void)hideProgess;

- (void)showLoadFailedNoticeWithAction:(SEL)action frame:(CGRect)frame isWeb:(BOOL)isWeb;
- (void)hidenLoadFailedNoticeView;

@end
