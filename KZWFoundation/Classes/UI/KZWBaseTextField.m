//
//  KZWBaseTextField.m
//  kongzhongfinancial
//
//  Created by ouy on 2017/8/2.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import "KZWBaseTextField.h"
#import "KZWConstants.h"
#import "UIButton+KZWButton.h"
#import "UIColor+KZWColor.h"
#import "UILabel+KZWLabel.h"

@interface KZWBaseTextField () <UITextFieldDelegate>

@property (assign, nonatomic) KZWTextFieldType type;
@property (strong, nonatomic) UIToolbar *toolbar;

@end

@implementation KZWBaseTextField

- (instancetype)initWithFrame:(CGRect)frame font:(CGFloat)font keyboardType:(UIKeyboardType)keyboardType placeholder:(NSString *)placeholder KZWTextFieldType:(KZWTextFieldType)type {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.textField];
        self.textField.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.textField.font = [UIFont systemFontOfSize:font];
        self.textField.keyboardType = keyboardType;
        self.textField.placeholder = placeholder;
        self.type = type;
    }
    return self;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.textColor = [UIColor colorWithHexString:FontColor333333];
        _textField.inputAccessoryView = self.toolbar;
        _textField.delegate = self;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UIToolbar *)toolbar {
    if (!_toolbar) {
        CGRect tempFrame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        _toolbar = [[UIToolbar alloc] initWithFrame:tempFrame];
        UIBarButtonItem *bgItem = [[UIBarButtonItem alloc] initWithCustomView:({
            UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(8, 0, 200, 40)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 150, 40) textColor:[UIColor colorWithHexString:FontColor999999] font:FontSize24];
            label.text = @"易起盈安全键盘";
            [bgview addSubview:label];
            bgview;
        })];
        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *endItem = [[UIBarButtonItem alloc] initWithCustomView:({
            UIButton *end = [[UIButton alloc] initWithType:KZWButtonTypeDefault normalTitle:@"完成" titleFont:FontSize28 cornerRadius:0];
            [end addTarget:self action:@selector(end:) forControlEvents:UIControlEventTouchUpInside];
            end.backgroundColor = [UIColor clearColor];
            end.frame = CGRectMake(0, 0, 40, 40);
            end;
        })];
        _toolbar.items = @[ bgItem, spaceItem, endItem ];
    }
    return _toolbar;
}

- (void)end:(id)sender {
    [self.textField resignFirstResponder];
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSString *toBeString = textField.text;
    toBeString = [self filterCharactor:textField.text withRegex:@"[^a-zA-Z0-9\u4e00-\u9fa5]"];
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            textField.text = [self lengthLimit:toBeString];
        } else {
        }
    } else {
        textField.text = [self lengthLimit:toBeString];
    }
}

- (NSString *)lengthLimit:(NSString *)toBeString {
    switch (self.type) {
        case KZWTextFieldIdCard: {
            if (toBeString.length > 18) {
                return [toBeString substringToIndex:18];
            }
        } break;
        case KZWTextFieldPhone: {
            if (toBeString.length > 11) {
                return [toBeString substringToIndex:11];
            }
        } break;
        case KZWTextFieldPWD: {
            if (toBeString.length > 16) {
                return [toBeString substringToIndex:16];
            }
        } break;
        case KZWTextFieldCode: {
            if (toBeString.length > 6) {
                return [toBeString substringToIndex:6];
            }
        } break;
        case KZWTextFieldDefault: {
            if (toBeString.length > 50) {
                return [toBeString substringToIndex:50];
            }
        } break;
        case KZWTextFieldMoney: {
            if (toBeString.length > 8) {
                return [toBeString substringToIndex:8];
            }
        } break;
        default:
            break;
    }
    return toBeString;
}

- (NSString *)text {
    return self.textField.text;
}

- (void)setText:(NSString *)text {
    self.textField.text = text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr {
    NSString *filterText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:filterText options:NSMatchingReportCompletion range:NSMakeRange(0, filterText.length) withTemplate:@""];
    return result;
}

@end
