//
//  KZWConstants.h
//  KZWfinancial
//
//  Created by ouy on 2017/3/2.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - key

extern NSString *const YQYFINANCIALLOGINTOKEN;

#pragma mark 宏定义

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

// iPhone X
#define  KZW_iPhoneX (SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f ? YES : NO)

// Status bar height.
#define  KZW_StatusBarHeight      (KZW_iPhoneX ? 44.f : 20.f)

#define  KZW_PersonrHeight      (KZW_iPhoneX ? 44.f : 30.f)


// Navigation bar height.
#define  KZW_NavigationBarHeight  44.f

// Tabbar height.
#define  KZW_TabbarHeight         (KZW_iPhoneX ? (49.f+34.f) : 49.f)

// Tabbar safe bottom margin.
#define  KZW_TabbarSafeBottomMargin         (KZW_iPhoneX ? 34.f : 0.f)

// Status bar & navigation bar height.
#define  KZW_StatusBarAndNavigationBarHeight  (KZW_iPhoneX ? 88.f : 64.f)

#define KZW_ViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})

#define BoundingRectWithSize(text, size, font)                                                                         \
[text boundingRectWithSize:size                                                                                      \
options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading                    \
attributes:@{NSFontAttributeName:font}                                                              \
context:nil]

#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f

#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;
#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;

#define SuppressPerformSelectorLeakWarning(Stuff)                                                                      \
do {                                                                                                                 \
_Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") Stuff;        \
_Pragma("clang diagnostic pop")                                                                                    \
} while (0)

#pragma mark colors

static NSString *FontColorff6600 = @"ff6600";

static NSString *FontColor333333 = @"#333333";

static NSString *FontColor666666 = @"#666666";

static NSString *FontColor999999 = @"#999999";

static NSString *FontColorcccccc = @"#cccccc";

static NSString *BGColorf5f5f5 = @"#f0f0f0";

static NSString *BGColorffffff = @"#ffffff";

#pragma mark fonts

static CGFloat FontSize72 = 36;

static CGFloat FontSize60 = 30;

static CGFloat FontSize48 = 24;

static CGFloat FontSize36 = 18;

static CGFloat FontSize34 = 17;

static CGFloat FontSize32 = 16;

static CGFloat FontSize30 = 15;

static CGFloat FontSize28 = 14;

static CGFloat FontSize26 = 13;

static CGFloat FontSize24 = 12;

static CGFloat FontSize22 = 11;

static CGFloat FontSize20 = 10;

static CGFloat FontSize18 = 9;

#pragma mark cornerRadius

static CGFloat Cornerradius30 = 15;




