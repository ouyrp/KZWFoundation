//
//  UIImageView+KZWCache.h
//  kongzhongfinancial
//
//  Created by ouyang on 2017/12/27.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import "ZYImageCacheManager.h"
#import <UIKit/UIKit.h>

@interface UIImageView (KZWCache)

- (void)zy_setImageWithURL:(NSString *)urlString withImage:(UIImage *)placeholderImage;

//从网址下载图片，没下载完毕前，显示占位图片
- (void)zy_setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage;

@end
