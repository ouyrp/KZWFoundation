//
//  CQPointHUD.h
//  弹窗哈哈哈
//
//  Created by 蔡强 on 2017/6/7.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KZWVersionModel.h"

@interface CQHUD : UIView

+ (CQHUD *)sharedCQHUD;

#pragma mark - 带网络图片与block回调的弹窗
/** 带网络图片与block回调的弹窗 */
- (void)showAlertWithImageURL:(NSString *)imageURL ButtonClickedBlock:(void(^)())buttonClickedBlock;

- (void)showVersionUpdate:(KZWVersionModel *)model;

@end
