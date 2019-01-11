//
//  KZWTextField.m
//  kongzhongfinancial
//
//  Created by ouy on 2017/5/26.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import "KZWNoPasteTextField.h"

@implementation KZWNoPasteTextField

- (instancetype)initWithFrame:(CGRect)frame font:(CGFloat)font keyboardType:(UIKeyboardType)keyboardType placeholder:(NSString *)placeholder {
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:font];
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentLeft;
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.keyboardType = keyboardType;
        self.placeholder = placeholder;
        self.textColor = [UIColor whiteColor];
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(paste:)) //禁止粘贴
        return NO;
    if (action == @selector(select:)) // 禁止选择
        return NO;
    if (action == @selector(selectAll:)) // 禁止全选
        return NO;
    return [super canPerformAction:action withSender:sender];
}

@end
