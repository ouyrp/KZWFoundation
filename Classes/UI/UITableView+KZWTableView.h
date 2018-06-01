//
//  UITableView+KZWTableView.h
//  KZWFoundation
//
//  Created by ouyang on 2018/5/9.
//  Copyright © 2018年 ouyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (KZWTableView)

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle automatic:(BOOL)automatic;

- (void)showNoDataView:(NSArray *)array;

@end
