//
//  KZWBaseTextView.h
//  kongzhongfinancial
//
//  Created by ouy on 2017/8/5.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KZWBaseTextView : UIView

- (instancetype)initWithFrame:(CGRect)frame font:(CGFloat)font;

@property (strong, nonatomic) UITextView *textView;

@property (copy, nonatomic) NSString *text;
- (void)setText:(NSString *)text;

@end
