//
//  KZWViewController.m
//  KZWfinancial
//
//  Created by ouy on 2017/3/2.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import "KZWViewController.h"
#import "KZWConstants.h"
#import "KZWDebugService.h"
#import "KZWHUD.h"
#import "KZWNetStateView.h"
#import "UIColor+KZWColor.h"
#import "UIViewController+ELMRouter.h"
#import <AudioToolbox/AudioToolbox.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <objc/runtime.h>

@interface KZWViewController () <netStatueViewDelegate>

@property (strong, nonatomic) UIImageView *navBarHairlineImageView;
@property (strong, nonatomic) KZWNetStateView *netStatueView;
@property (strong, nonatomic) MBProgressHUD *hud;

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
#if DEBUG
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
#endif
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
    MBProgressHUD *progress = objc_getAssociatedObject(self, @"lpd_progress");
    if (!progress) {
        progress = [[MBProgressHUD alloc] initWithView:self.view];
        objc_setAssociatedObject(self, @"lpd_progress", progress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.view addSubview:progress];
    }
    progress.frame = self.view.bounds;
    progress.contentColor = [UIColor colorWithHexString:FontColor333333];
    [progress showAnimated:YES];
}

- (void)hideProgess {
    MBProgressHUD *progress = objc_getAssociatedObject(self, @"lpd_progress");
    [progress hideAnimated:NO];
}

- (void)showLoadFailedNoticeWithAction:(SEL)action frame:(CGRect)frame isWeb:(BOOL)isWeb {
    if (!self.netStatueView) {
        self.netStatueView = [[KZWNetStateView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
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

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    //检测到摇动开始
    if (motion == UIEventSubtypeMotionShake) {
        // your code
        NSLog(@"检测到摇动开始");
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    //摇动取消KZWDebugService
    NSLog(@"摇动取消");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    //摇动结束
    if (event.subtype == UIEventSubtypeMotionShake) {
        // your code
        NSLog(@"摇动结束");
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); //振动效果 需要#import <AudioToolbox/AudioToolbox.h>

        NSString *message = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[KZWDebugService currentDebug] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]; //对展示进行格式化处理
        [[KZWHUD sharedKZWHUD] showDebug:message];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if DEBUG
    NSLog(@"%@ release", NSStringFromClass([self class]));
#endif
}

@end
