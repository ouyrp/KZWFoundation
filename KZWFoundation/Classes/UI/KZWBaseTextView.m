//
//  KZWBaseTextView.m
//  kongzhongfinancial
//
//  Created by ouy on 2017/8/5.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import "KZWBaseTextView.h"
#import "KZWConstants.h"
#import "UIButton+KZWButton.h"
#import "UIColor+KZWColor.h"
#import "UILabel+KZWLabel.h"

@interface KZWBaseTextView () <UITextViewDelegate>

@property (strong, nonatomic) UIToolbar *toolbar;

@end

@implementation KZWBaseTextView

- (instancetype)initWithFrame:(CGRect)frame font:(CGFloat)font {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.textView];
        self.textView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.textView.font = [UIFont systemFontOfSize:font];
    }
    return self;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView.delegate = self;
        _textView.textColor = [UIColor colorWithHexString:@"FontColor333333"];
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.textAlignment = NSTextAlignmentRight;
        _textView.inputAccessoryView = self.toolbar;
        _textView.layer.cornerRadius = 6;
        _textView.layer.borderColor = [UIColor colorWithHexString:FontColorcccccc].CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.layer.masksToBounds = YES;
    }
    return _textView;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
    [self.textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *toBeString = textView.text;
    toBeString = [self filterCharactor:textView.text withRegex:@"[^a-zA-Z0-9\u4e00-\u9fa5]"];
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (toBeString.length > 50) {
                textView.text = [toBeString substringToIndex:50];
            } else {
                textView.text = toBeString;
            }
        } else {
        }
    } else {
        if (toBeString.length > 50) {
            textView.text = [toBeString substringToIndex:50];
        } else {
            textView.text = toBeString;
        }
    }
}

- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr {
    NSString *filterText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:filterText options:NSMatchingReportCompletion range:NSMakeRange(0, filterText.length) withTemplate:@""];
    return result;
}

- (NSString *)text {
    return self.textView.text;
}

- (void)setText:(NSString *)text {
    self.textView.text = text;
}

@end
