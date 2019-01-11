//
//  UIImageView+KZWCache.m
//  kongzhongfinancial
//
//  Created by ouyang on 2017/12/27.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import "UIImageView+KZWCache.h"

@implementation UIImageView (KZWCache)

- (void)zy_setImageWithURL:(NSString *)urlString withImage:(UIImage *)placeholderImage {

    [[ZYImageCacheManager sharedImageCacheManager] getImageWithUrl:urlString complete:^(UIImage *image) {
        //使用图片
        if (image == NULL) {
            self.image = [placeholderImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        } else {
            self.image = [self scaleImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] toScale:0.33];
        }
    }];
}

- (void)zy_setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage {
    self.image = [placeholderImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self zy_setImageWithURL:urlString withImage:placeholderImage];
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize), NO, 0);
    [image drawInRect:CGRectIntegral(CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize))];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [scaledImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
