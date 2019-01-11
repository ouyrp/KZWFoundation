//
//  KZWProGressView.h
//  ProgressBar
//
//  Created by Apple on 2017/4/12.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZWProGressView : UIView

/**
    进度值
 */
@property (nonatomic, copy) NSString *progressValue;

/**
    进度条的颜色
 */
@property (nonatomic, strong) UIColor *progressColor;

/**
    进度条的背景色
 */
@property (nonatomic, strong) UIColor *bottomColor;

/**
    进度条的速度
 */
@property (nonatomic, assign) float time;


@end
