//
//  LPDBHttpManager.h
//  LPDCrowdsource
//
//  Created by eMr.Wang on 15/10/30.
//  Copyright © 2015年 elm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPDBHttpManager : NSObject

+ (AFHTTPSessionManager *)sharedRequestOperationManager;

+ (NSURLSessionDataTask *)GET:(NSString *_Nonnull)path
         parameters:(nullable id)parameters
  completionHandler:(nullable void (^)(NSURLSessionDataTask *__unused task, id responseObject, NSError *error))complete;

+ (NSURLSessionDataTask *)POST:(NSString *_Nonnull)path
                    parameters:(nullable id)parameters
                        images:(NSArray *_Nullable)images
             completionHandler:(nullable void (^)(NSURLSessionDataTask *__unused task, id responseObject, NSError *error))complete
                      progress:(nullable void (^)(NSProgress * _Nonnull uploadProgress)) progress;

+ (NSURLSessionDataTask *)POST:(NSString *_Nonnull)path
                    parameters:(nullable id)parameters
             completionHandler:(nullable void (^)(NSURLSessionDataTask *__unused task, id responseObject, NSError *error))complete;

+ (NSURLSessionDataTask *)PUT:(NSString *_Nonnull)path
         parameters:(nullable id)parameters
  completionHandler:(nullable void (^)(NSURLSessionDataTask *__unused task, id responseObject, NSError *error))complete;

+ (NSURLSessionDataTask *)DELETE:(NSString *_Nonnull)path
         parameters:(nullable id)parameters
  completionHandler:(nullable void (^)(NSURLSessionDataTask *__unused task, id responseObject, NSError *error))complete;

@end
NS_ASSUME_NONNULL_END
