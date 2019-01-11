//
//  KZWBdgeButton.m
//  kongzhongfinancial
//
//  Created by ouyang on 2018/3/26.
//  Copyright © 2018年 ouy. All rights reserved.
//

#import "KZWBdgeButton.h"
#import <Masonry/Masonry.h>

@interface KZWBdgeButton ()

@property (nonatomic, strong) UILabel *badgeLabel;

@end

@implementation KZWBdgeButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // button属性设置
        self.clipsToBounds = NO;
        [self.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        //------- 角标label -------//
        self.badgeLabel = [[UILabel alloc] init];
        [self addSubview:self.badgeLabel];
        self.badgeLabel.backgroundColor = [UIColor redColor];
        self.badgeLabel.font = [UIFont systemFontOfSize:9];
        self.badgeLabel.textColor = [UIColor whiteColor];
        self.badgeLabel.layer.cornerRadius = 6;
        self.badgeLabel.clipsToBounds = YES;

        //------- 建立角标label的约束 -------//
        [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageView.mas_right).mas_offset(-6);
            make.bottom.mas_equalTo(self.imageView.mas_top).mas_offset(6);
            make.height.mas_equalTo(12);
        }];
    }
    return self;
}

- (void)setKzwbdgeNumber:(NSInteger)kzwbdgeNumber {
    if (_kzwbdgeNumber == kzwbdgeNumber) {
        return;
    }
    _kzwbdgeNumber = kzwbdgeNumber;
    if (kzwbdgeNumber > 0 && kzwbdgeNumber < 99) {
        self.badgeLabel.hidden = NO;
        self.badgeLabel.text = [NSString stringWithFormat:@" %ld ", (long)kzwbdgeNumber];
    } else if (kzwbdgeNumber >= 99) {
        self.badgeLabel.hidden = NO;
        self.badgeLabel.text = @" 99+ ";
    } else {
        self.badgeLabel.hidden = YES;
    }
}

@end
