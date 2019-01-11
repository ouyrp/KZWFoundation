//
//  KZWNetStateView.h
//  kongzhongfinancial
//
//  Created by ouy on 2017/4/2.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol netStatueViewDelegate <NSObject>

- (void)netStateViewWithAction:(SEL)action;

@end

@interface KZWNetStateView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (strong, nonatomic) UIImageView *netImage;

@property (strong, nonatomic) UILabel *netLabel;

@property (strong, nonatomic) UIButton *button;

@property (nonatomic, weak) id<netStatueViewDelegate> delegate;

- (void)showLoadFailedNoticeWithAction:(SEL)action isWeb:(BOOL)isWeb;

@end
