//
//  KZWBdgeImage.m
//  kongzhongfinancial
//
//  Created by ouyang on 2018/3/30.
//  Copyright © 2018年 ouy. All rights reserved.
//

#import "KZWBdgeImage.h"
#import "UIView+KZWCore.h"
#import <Masonry/Masonry.h>

@interface KZWBdgeImage ()

@property (nonatomic, strong) UILabel *badgeLabel;

@end

@implementation KZWBdgeImage

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.badgeLabel = [[UILabel alloc] init];
        [self addSubview:self.badgeLabel];
        self.badgeLabel.backgroundColor = [UIColor redColor];
        self.badgeLabel.font = [UIFont systemFontOfSize:7];
        self.badgeLabel.textColor = [UIColor whiteColor];
        [self.badgeLabel addRoundedCorners:UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(5.0, 5.0) viewRect:CGRectMake(0, 0, 25, 10)];

        //------- 建立角标label的约束 -------//
        [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_right).mas_offset(-10);
            make.bottom.mas_equalTo(self.mas_top).mas_offset(10);
            make.height.mas_equalTo(10);
        }];
    }
    return self;
}

- (void)setKzwbdgeNumber:(NSString *)kzwbdgeNumber {
    if (_kzwbdgeNumber == kzwbdgeNumber) {
        return;
    }
    _kzwbdgeNumber = kzwbdgeNumber;
    if (kzwbdgeNumber) {
        self.badgeLabel.text = [NSString stringWithFormat:@" %@ ", kzwbdgeNumber];
    }
}

@end
