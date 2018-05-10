//
//  KZWViewController.m
//  KZWfinancial
//
//  Created by ouy on 2017/3/2.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import "KZWViewController.h"
#import "KZWNetStateView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <objc/runtime.h>
#import "UIColor+KZWColor.h"
#import "KZWConstants.h"
#import "UIViewController+ELMRouter.h"

@interface KZWViewController ()<netStatueViewDelegate>

@property (strong, nonatomic) UIImageView *navBarHairlineImageView;
@property (strong, nonatomic) KZWNetStateView *netStatueView;
@property (strong,nonatomic) MBProgressHUD *hud;

@end

@implementation KZWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:[UIColor baseColor]];
    self.navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    
    // 1.把返回文字的标题设置为空字符串(A和B都是UIViewController)
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:self.navigationHidden animated:animated];
    if (self.navigationHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    self.navBarHairlineImageView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navBarHairlineImageView.hidden = YES;
}

- (void)showProgress {
    MBProgressHUD *progress= objc_getAssociatedObject(self,@"lpd_progress");
    if (!progress) {
        progress = [[MBProgressHUD alloc]initWithView:self.view];
        objc_setAssociatedObject(self, @"lpd_progress", progress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.view addSubview:progress];
    }
    progress.frame = self.view.bounds;
    progress.contentColor = [UIColor colorWithHexString:FontColor333333];
    [progress showAnimated:YES];
}

- (void)hideProgess {
    MBProgressHUD *progress= objc_getAssociatedObject(self,@"lpd_progress");
    [progress hideAnimated:NO];
}

- (void)showLoadFailedNoticeWithAction:(SEL)action frame:(CGRect)frame isWeb:(BOOL)isWeb {
    if (!self.netStatueView) {
        self.netStatueView = [[KZWNetStateView alloc] initWithFrame:frame];
        self.netStatueView.delegate = self;
        [self.view addSubview:self.netStatueView];
    }
    [self.hud hideAnimated:YES];
    [self.netStatueView showLoadFailedNoticeWithAction:action isWeb:isWeb];
}

- (void)netStateViewWithAction:(SEL)action {
    self.hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    SuppressPerformSelectorLeakWarning([self performSelector:action withObject:nil];);
}

- (void)hidenLoadFailedNoticeView {
    [self.hud hideAnimated:YES];
    self.netStatueView.hidden = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if DEBUG
    NSLog(@"%@ release", NSStringFromClass([self class]));
#endif
}

@end
