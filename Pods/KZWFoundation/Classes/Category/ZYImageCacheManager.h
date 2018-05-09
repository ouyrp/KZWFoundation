//
//  ZYImageCacheManager.h
//  米庄理财
//
//  Created by aicai on 15/7/24.
//  Copyright (c) 2015年 aicai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^complete)(UIImage* image);//处理图片下载完成后的操作

//用这个单例类管理我们缓存的图片
@interface ZYImageCacheManager : NSObject

//单例类的入口
+ (instancetype)sharedImageCacheManager;

//从内存中加载图片
- (UIImage* )imageFromDictionary:(NSString* )key;

//从本地加载图片
- (UIImage* )imageFromLocal:(NSString* )urlString;

//从网络加载图片，因为是异步下载，方法结束的时候图片还没有下载完成，我们没有数据返回
- (void)imageFromNetwork:(NSString* )urlString complete:(complete)complete;

// 从网络或者缓存中获取图片
- (void)getImageWithUrl:(NSString *)urlString complete:(complete)complete;

//保存图片到内存中
- (void)setImage:(UIImage* )image withURL:(NSString* )urlString;

//保存图片到本地
- (void)saveImage:(UIImage* )image withURL:(NSString* )urlString;

//返回本地缓存的图片总大小，单位是M
- (long long)imageCacheSize;

//清楚本地的图片缓存
- (void)clearImageCaches;

@end
