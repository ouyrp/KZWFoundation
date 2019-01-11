//
//  UILabel+KZWLineSpace.m
//  kongzhongfinancial
//
//  Created by ouyang on 2018/5/3.
//  Copyright © 2018年 ouy. All rights reserved.
//

#import "UILabel+KZWLineSpace.h"

@implementation UILabel (KZWLineSpace)

- (void)setLineSpace:(CGFloat)lineSpace withText:(NSString *)text {
    if (!text || !self) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; //设置行间距
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    self.attributedText = attributedString;
}

@end
