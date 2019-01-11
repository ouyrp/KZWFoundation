//
//  UITableView+KZWTableView.m
//  KZWFoundation
//
//  Created by ouyang on 2018/5/9.
//  Copyright © 2018年 ouyang. All rights reserved.
//

#import "UITableView+KZWTableView.h"
#import "KZWConstants.h"
#import "KZWNetStateView.h"
#import "UIColor+KZWColor.h"

@implementation UITableView (KZWTableView)

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle automatic:(BOOL)automatic {
    if (self = [self initWithFrame:frame style:style]) {
        self.estimatedSectionFooterHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.separatorStyle = separatorStyle;
        self.backgroundColor = [UIColor colorWithHexString:BGColorf5f5f5];
        self.tableHeaderView = self.tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.01, 0.01)];
            view;
        });
        self.showsVerticalScrollIndicator = NO;
        self.estimatedRowHeight = 44;
        if (automatic) {
            self.rowHeight = UITableViewAutomaticDimension;
        }
    }
    return self;
}

- (void)showNoDataView:(NSArray *)array {
    NSString *bundlePath = [[NSBundle bundleForClass:[KZWNetStateView class]].resourcePath
        stringByAppendingPathComponent:@"/KZWFundation.bundle"];
    NSBundle *resource_bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *image = [UIImage imageNamed:@"bg_nodata.png"
                                inBundle:resource_bundle
           compatibleWithTraitCollection:nil];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 150) / 2, (SCREEN_HEIGHT - 150) / 2, 150, 150)];
    imageview.center = self.center;
    imageview.image = image;

    self.backgroundView = imageview;
    if (array.count > 0) {
        self.backgroundView.hidden = YES;
    } else {
        self.backgroundView.hidden = NO;
    }
}

@end
