//
//  UITabBarItem+WebCache.m
//
//  Created by ouyang on 15/7/24.
//

#import "UITabBarItem+WebCache.h"

@implementation UITabBarItem (WebCache)

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

- (void)zy_setSelectImageWithURL:(NSString *)urlString withImage:(UIImage *)placeholderImage {
    [[ZYImageCacheManager sharedImageCacheManager] getImageWithUrl:urlString complete:^(UIImage *image) {
        //使用图片
        if (image == NULL) {
            self.selectedImage = [placeholderImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        } else {
            self.selectedImage = [self scaleImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] toScale:0.33];
        }
    }];
}

- (void)zy_setSelectImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage {
    self.selectedImage = [placeholderImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self zy_setSelectImageWithURL:urlString withImage:placeholderImage];
}

- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize), NO, 0);
    [image drawInRect:CGRectIntegral(CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize))];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [scaledImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
