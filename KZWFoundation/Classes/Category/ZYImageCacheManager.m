//
//  ZYImageCacheManager.m
//  米庄理财
//
//  Created by aicai on 15/7/24.
//  Copyright (c) 2015年 aicai. All rights reserved.
//

#import "ZYImageCacheManager.h"
#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)

//返回一个当前字符串md5加密后的结果...
- (NSString *)md5;

@end

@implementation NSString (MD5)

- (NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5(cStr, (CC_LONG) strlen(cStr), digest); // This is the md5 call
    
    NSString *s = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                                             digest[0], digest[1],
                                             digest[2], digest[3],
                                             digest[4], digest[5],
                                             digest[6], digest[7],
                                             digest[8], digest[9],
                                             digest[10], digest[11],
                                             digest[12], digest[13],
                                             digest[14], digest[15]];
    return s;
}

@end

@interface ZYImageCacheManager () {
    NSMutableDictionary *_imageCache; //使用这个字典保存使用过的图片，既加载到内存中的图片
}

@end

@implementation ZYImageCacheManager

+ (instancetype)sharedImageCacheManager {
    static ZYImageCacheManager *imageCacheManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCacheManager = [[ZYImageCacheManager alloc] init];
    });
    return imageCacheManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _imageCache = [[NSMutableDictionary alloc] initWithCapacity:0];

        //接受一下内存警告
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearImageCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (UIImage *)imageFromDictionary:(NSString *)key {
    return [_imageCache objectForKey:key];
}

- (UIImage *)imageFromLocal:(NSString *)urlString {
    //对网址进行md5加密作为图片名
    NSString *imageName = [urlString md5];

    //把图片保存在沙盒中的Library/Caches文件夹下
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImageCache"];

    //完整的图片路径
    NSString *imagePath = [path stringByAppendingPathComponent:imageName];

    //从本地读一张图片
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];

    return image;
}

- (void)imageFromNetwork:(NSString *)urlString complete:(complete)complete {
    //异步下载图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //从网络获取数据
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];

        //从二进制生成图片
        UIImage *image = [UIImage imageWithData:data];
        //切回主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(image);
            }
        });
        
        if (image != NULL && image) {
            //加载到内存
            [self setImage:image withURL:urlString];
            
            //加载到本地
            [self saveImage:image withURL:urlString];
        }
    });
}

// 从网络或者缓存中获取图片
- (void)getImageWithUrl:(NSString *)urlString complete:(complete)complete {
    //1.从内存中加载图片
    UIImage *image = [[ZYImageCacheManager sharedImageCacheManager] imageFromDictionary:urlString];
    
    if (image) {
        complete(image);
    } else {
        //内存没有图片，就从本地读区图片
        image = [[ZYImageCacheManager sharedImageCacheManager] imageFromLocal:urlString];
        if (image) {
            complete(image);
        } else {
            //从本地没有读取到图片，从网络下载
            [self imageFromNetwork:urlString complete:^(UIImage *image) {
                complete(image);
            }];
        }
    }
}


- (void)setImage:(UIImage *)image withURL:(NSString *)urlString {
    [_imageCache setValue:image forKey:urlString];
}

- (void)saveImage:(UIImage *)image withURL:(NSString *)urlString {
    //对网址进行md5加密作为图片名
    NSString *imageName = [urlString md5];

    //把图片保存在沙盒中的Library/Caches文件夹下
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImageCache"];

    NSString *imagePath = [path stringByAppendingPathComponent:imageName];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![fileManager fileExistsAtPath:imagePath]) {
        //把文件写入本地
        [fileManager createFileAtPath:imagePath contents:UIImagePNGRepresentation(image) attributes:nil];
    }
}

- (void)clearImageCache {
    //清空缓存释放内存
    [_imageCache removeAllObjects];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImageCache"];

    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

- (long long)imageCacheSize {
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/ImageCache"];
    NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    long long size = [[dict objectForKey:NSFileSize] longLongValue];
    return size;
}

- (void)clearImageCaches {
    //...
}

@end
