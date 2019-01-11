//
//  KZWBaseTextField.h
//  kongzhongfinancial
//
//  Created by ouy on 2017/8/2.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, KZWTextFieldType) {
    KZWTextFieldPhone,
    KZWTextFieldCode,
    KZWTextFieldPWD,
    KZWTextFieldIdCard,
    KZWTextFieldMoney,
    KZWTextFieldDefault
};

@interface KZWBaseTextField : UIView

- (instancetype)initWithFrame:(CGRect)frame font:(CGFloat)font keyboardType:(UIKeyboardType)keyboardType placeholder:(NSString *)placeholder KZWTextFieldType:(KZWTextFieldType)type;

@property (strong, nonatomic) UITextField *textField;

@property (copy, nonatomic) NSString *text;
- (void)setText:(NSString *)text;

@end
