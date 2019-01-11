//
//  UITabBarItem+WebCache.h
//
//  Created by ouyang on 15/7/24.
//

#import "ZYImageCacheManager.h"
#import <UIKit/UIKit.h>
@interface UITabBarItem (WebCache)
//从网址加载图片
- (void)zy_setImageWithURL:(NSString *)urlString withImage:(UIImage *)placeholderImage;

//从网址下载图片，没下载完毕前，显示占位图片
- (void)zy_setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage;
- (void)zy_setSelectImageWithURL:(NSString *)urlString withImage:(UIImage *)placeholderImage;

- (void)zy_setSelectImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage;

@end
