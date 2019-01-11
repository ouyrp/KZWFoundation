//
//  KZWTosatView.m
//  kongzhongfinancial
//
//  Created by ouy on 2017/8/2.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import "KZWTosatView.h"
#import "KZWConstants.h"
#import "UIColor+KZWColor.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation KZWTosatView

+ (void)showToastWithMessage:(NSString *)message view:(UIView *)view {
    MBProgressHUD *messagehud = [MBProgressHUD showHUDAddedTo:view ?: [UIApplication sharedApplication].keyWindow animated:YES];
    messagehud.contentColor = [UIColor colorWithHexString:FontColor333333];
    messagehud.mode = MBProgressHUDModeText;
    messagehud.detailsLabel.text = ([message isEqual:[NSNull null]]) ? @"服务异常" : message;
    [messagehud hideAnimated:YES afterDelay:2];
}

@end
