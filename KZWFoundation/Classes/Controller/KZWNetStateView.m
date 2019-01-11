//
//  KZWNetStateView.m
//  kongzhongfinancial
//
//  Created by ouy on 2017/4/2.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import "KZWNetStateView.h"
#import "KZWConstants.h"
#import "KZWRequestServerstatus.h"
#import "LPDBRequestObject.h"
#import "UIButton+KZWButton.h"
#import "UIColor+KZWColor.h"
#import "UILabel+KZWLabel.h"
#import <AFNetworking/AFNetworking.h>

@interface KZWNetStateView ()

@property (assign, nonatomic) SEL action;
@property (strong, nonatomic) UIImage *bgImage;

@end

@implementation KZWNetStateView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
        NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath
            stringByAppendingPathComponent:@"/KZWFundation.bundle"];
        NSBundle *resource_bundle = [NSBundle bundleWithPath:bundlePath];
        self.bgImage = [UIImage imageNamed:@"bg_server.png"
                                  inBundle:resource_bundle
             compatibleWithTraitCollection:nil];
        [self addSubview:self.netImage];
        [self addSubview:self.netLabel];
        [self addSubview:self.button];
    }
    return self;
}

- (UIImageView *)netImage {
    if (!_netImage) {
        _netImage = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 266 / 2) / 2, 150, 266 / 2, 204 / 2)];
        _netImage.image = self.bgImage;
    }
    return _netImage;
}

- (UILabel *)netLabel {
    if (!_netLabel) {
        _netLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.netImage.frame), SCREEN_WIDTH, 40)];
        _netLabel.textColor = [UIColor colorWithHexString:@"b1b1b1"];
        _netLabel.numberOfLines = 0;
        _netLabel.font = [UIFont systemFontOfSize:14];
        _netLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _netLabel;
}

- (UIButton *)button {
    if (!_button) {
        _button = [[UIButton alloc] initWithType:KZWButtonTypeLine normalTitle:@"刷新" titleFont:16 cornerRadius:75 / 4];
        _button.frame = CGRectMake(SCREEN_WIDTH / 2 - 280 / 4, CGRectGetMaxY(self.netImage.frame) + 40, 280 / 2, 75 / 2);
        [_button addTarget:self action:@selector(removeNotice) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (void)addTouchAction {
    UITapGestureRecognizer *singleTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeNotice)];
    [self addGestureRecognizer:singleTap];
    singleTap.cancelsTouchesInView = NO;
}

- (void)netState {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    switch (manager.networkReachabilityStatus) {
        case AFNetworkReachabilityStatusUnknown: {
            NSLog(@"未知网络");
            self.hidden = NO;
            self.netImage.image = self.bgImage;
            self.netLabel.text = @"网络似乎断了，请刷新重试";
        } break;
        case AFNetworkReachabilityStatusNotReachable: {
            NSLog(@"没有网络");
            self.hidden = NO;
            self.netImage.image = self.bgImage;
            self.netLabel.text = @"网络似乎断了，请刷新重试";
        } break;
        case AFNetworkReachabilityStatusReachableViaWWAN: {
            NSLog(@"手机自带网络");
            self.netImage.image = self.bgImage;
            self.netLabel.text = @"网络似乎断了，请刷新重试";
            [self serverStatus];
        } break;
        case AFNetworkReachabilityStatusReachableViaWiFi: {
            NSLog(@"WIFI");
            self.netImage.image = self.bgImage;
            self.netLabel.text = @"网络似乎断了，请刷新重试";
            [self serverStatus];
        } break;
    }
}

- (void)serverStatus {
    KZWRequestServerstatus *requestServerstatus = [KZWRequestServerstatus new];
    [requestServerstatus startRequestComplete:^(id object, NSError *error) {
        if (error.code == 500) {
            self.netImage.image = self.bgImage;
            self.netLabel.text = @"服务器维护中，请刷新重试";
            self.hidden = NO;
        }
    }];
}

- (void)showLoadFailedNoticeWithAction:(SEL)action isWeb:(BOOL)isWeb {
    _action = action;
    if (isWeb) {
        [self netState];
    } else {
        [self netState];
        self.hidden = NO;
    }
}

- (void)removeNotice {
    if (self.action) {
        if ([self.delegate respondsToSelector:@selector(netStateViewWithAction:)]) {
            [self.delegate netStateViewWithAction:self.action];
        }
        self.action = nil;
    }
}

@end
