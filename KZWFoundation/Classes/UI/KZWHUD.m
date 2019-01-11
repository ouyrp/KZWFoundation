//
//  CQPointHUD.m
//  弹窗哈哈哈
//
//  Created by 蔡强 on 2017/6/7.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

#import "KZWHUD.h"
#import "KZWConstants.h"
#import "UIButton+KZWButton.h"
#import "UIColor+KZWColor.h"
#import "UIControl+Block.h"
#import "UILabel+KZWLabel.h"
#import "UILabel+KZWLabel.h"
#import "UILabel+KZWLineSpace.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <Masonry/Masonry.h>

@interface KZWHUD ()

@property (strong, nonatomic) UIView *bgView;

@end

@implementation KZWHUD

+ (KZWHUD *)sharedKZWHUD {
    static dispatch_once_t predicate;
    static KZWHUD *sharedKZWHUD;
    dispatch_once(&predicate, ^{
        sharedKZWHUD = [[KZWHUD alloc] init];
    });
    return sharedKZWHUD;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
}

- (void)showAlertWithImageURL:(NSString *)imageURL ButtonClickedBlock:(void (^)(void))buttonClickedBlock {
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
    self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];

    UIImageView *goodsImageView = [[UIImageView alloc] init];
    goodsImageView.layer.cornerRadius = 8;
    goodsImageView.layer.masksToBounds = YES;
    [goodsImageView setImageWithURL:[NSURL URLWithString:imageURL]];
    [self.bgView addSubview:goodsImageView];

    UIButton *conversionButton = [[UIButton alloc] init];
    [self.bgView addSubview:conversionButton];

    UIButton *cancelButton = [[UIButton alloc] init];
    [self.bgView addSubview:cancelButton];

    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath
        stringByAppendingPathComponent:@"/KZWFundation.bundle"];
    NSBundle *resource_bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *cancelimage = [UIImage imageNamed:@"cancelimage.png"
                                      inBundle:resource_bundle
                 compatibleWithTraitCollection:nil];
    [cancelButton setImage:cancelimage forState:UIControlStateNormal];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    [goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.centerY.mas_equalTo(self.bgView).mas_offset(-24);
        make.size.mas_equalTo(CGSizeMake(0.875 * SCREEN_WIDTH, 0.875 / 0.8 * SCREEN_WIDTH));
    }];

    [conversionButton touchUpInside:^{
        [self.bgView removeFromSuperview];
        self.bgView = nil;
        buttonClickedBlock();
    }];

    [conversionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgView);
        make.centerY.mas_equalTo(self.bgView).mas_offset(-24);
        make.width.height.mas_equalTo(goodsImageView);
    }];

    // 取消按钮
    [cancelButton touchUpInside:^{
        [self.bgView removeFromSuperview];
        self.bgView = nil;
    }];

    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(goodsImageView).mas_offset(15);
        make.bottom.mas_equalTo(goodsImageView.mas_top).mas_offset(-20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)showVersionUpdate:(KZWVersionModel *)model {
    [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
    self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];

    UIView *contenView = [[UIView alloc] init];
    contenView.layer.cornerRadius = 15 / 2;
    contenView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:contenView];

    UIImageView *bgImage = [[UIImageView alloc] init];

    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath
        stringByAppendingPathComponent:@"/KZWFundation.bundle"];
    NSBundle *resource_bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *bgimage = [UIImage imageNamed:@"update_bg.png"
                                  inBundle:resource_bundle
             compatibleWithTraitCollection:nil];
    bgImage.image = bgimage;
    [contenView addSubview:bgImage];

    UIImageView *headIMage = [[UIImageView alloc] init];
    UIImage *headimage = [UIImage imageNamed:@"update_head.png"
                                    inBundle:resource_bundle
               compatibleWithTraitCollection:nil];
    headIMage.image = headimage;
    [contenView addSubview:headIMage];
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 17, 120, 15) textColor:[UIColor colorWithHexString:@"3366cc"] font:FontSize34];
    headLabel.text = @"发现新版本";
    [contenView addSubview:headLabel];

    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 48, 100, 15) textColor:[UIColor colorWithHexString:@"333366"] font:FontSize36];
    versionLabel.text = model.appVersion;
    [contenView addSubview:versionLabel];

    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = [UIColor colorWithHexString:FontColor333333];
    contentLabel.font = [UIFont systemFontOfSize:13];
    [contentLabel setLineSpace:8.0 withText:model.updateDesc];
    contentLabel.numberOfLines = 0;
    [contenView addSubview:contentLabel];

    UIButton *cancel = [[UIButton alloc] initWithType:KZWButtonTypeLine normalTitle:@"以后再说" titleFont:FontSize30 cornerRadius:75 / 4];
    [contenView addSubview:cancel];

    UIButton *sure = [[UIButton alloc] initWithType:KZWButtonTypeBG normalTitle:@"立即升级" titleFont:FontSize30 cornerRadius:75 / 4];
    [contenView addSubview:sure];

    UIButton *fault = [[UIButton alloc] initWithType:KZWButtonTypeBG normalTitle:@"立即升级" titleFont:FontSize30 cornerRadius:75 / 4];
    [contenView addSubview:fault];
    if ([model.updateType isEqualToString:@"FORCED"]) {
        fault.hidden = NO;
        cancel.hidden = YES;
        sure.hidden = YES;
    } else if ([model.updateType isEqualToString:@"SUGGEST"]) {
        fault.hidden = YES;
        cancel.hidden = NO;
        sure.hidden = NO;
    }

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    [contenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.bgView.superview);
        make.width.mas_equalTo(@290);
    }];

    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(contenView);
        make.size.mas_equalTo(CGSizeMake(228, 85));
    }];

    [headIMage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(contenView);
        make.top.mas_equalTo(contenView).mas_offset(-38);
        make.size.mas_equalTo(CGSizeMake(161, 123));
    }];

    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contenView).mas_offset(120);
        make.right.left.mas_equalTo(contenView).mas_offset(25);
        make.bottom.mas_equalTo(contenView).mas_offset(-88);
    }];

    [fault mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contenView).mas_offset(25);
        make.top.mas_equalTo(contentLabel.mas_bottom).mas_offset(25);
        make.size.mas_equalTo(CGSizeMake(240, 37.5));
    }];

    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contenView).mas_offset(25);
        make.top.mas_equalTo(contentLabel.mas_bottom).mas_offset(25);
        make.size.mas_equalTo(CGSizeMake(115, 37.5));
    }];

    [sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(contenView).mas_offset(-25);
        make.top.mas_equalTo(contentLabel.mas_bottom).mas_offset(25);
        make.size.mas_equalTo(CGSizeMake(115, 37.5));
    }];

    [cancel touchUpInside:^{
        [self.bgView removeFromSuperview];
        self.bgView = nil;
    }];

    [sure touchUpInside:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.packageDownloadUrl]];
        [self.bgView removeFromSuperview];
        self.bgView = nil;
    }];

    [fault touchUpInside:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.packageDownloadUrl]];
        [self.bgView removeFromSuperview];
        self.bgView = nil;
    }];
}

- (void)showDebug:(NSString *)message {
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.bgView];
    self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];


    UIScrollView *scrollerview = [[UIScrollView alloc] initWithFrame:CGRectMake(10, KZW_StatusBarAndNavigationBarHeight, SCREEN_WIDTH - 20, SCREEN_HEIGHT - KZW_StatusBarAndNavigationBarHeight - KZW_TabbarHeight)];
    scrollerview.backgroundColor = [UIColor whiteColor];


    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, SCREEN_HEIGHT - KZW_StatusBarAndNavigationBarHeight - KZW_TabbarHeight) textColor:[UIColor colorWithHexString:FontColor333333] font:FontSize26];
    label.text = message;
    [label sizeToFit];
    [scrollerview addSubview:label];
    scrollerview.contentSize = CGSizeMake(SCREEN_WIDTH - 20, label.frame.size.height);
    [self.bgView addSubview:scrollerview];

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - 20, KZW_iPhoneX ? 44 : 20, 30, 30)];
    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath
        stringByAppendingPathComponent:@"/KZWFundation.bundle"];
    NSBundle *resource_bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *cancelimage = [UIImage imageNamed:@"cancelimage.png"
                                      inBundle:resource_bundle
                 compatibleWithTraitCollection:nil];
    [backButton setImage:cancelimage forState:UIControlStateNormal];
    [self.bgView addSubview:backButton];

    @WeakObj(self)
        [backButton touchUpInside:^{
            @StrongObj(self)
                [self.bgView removeFromSuperview];
            self.bgView = nil;
        }];
}

@end
