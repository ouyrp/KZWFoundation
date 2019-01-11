//
//  LPDRequestObject.m
//  LPDCrowdsource
//
//  Created by sq on 15/11/4.
//  Copyright © 2015年 elm. All rights reserved.
//

#import "LPDBRequestObject.h"
#import "ELMKeychainUtil.h"
#import "KZWConstants.h"
#import "KZWDebugService.h"
#import "NSError+LPDErrorMessage.h"
#import "NSObject+Dictionary.h"
#import "UIApplication+ELMFoundation.h"
#import <Mantle/MTLJSONAdapter.h>

@interface LPDBRequestObject ()
@property (nonatomic, copy) LPDBRequestComplete complete;
@end

@implementation LPDBRequestObject

- (void)startRequestComplete:(LPDBRequestComplete)complete
                    progress:(nullable void (^)(NSProgress *_Nonnull uploadProgress))progress {
    self.complete = complete;
    switch (self.method) {
        case LPDHTTPMethodGet: {
            _task = [LPDBHttpManager GET:self.path
                              parameters:self.params
                       completionHandler:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject, NSError *_Nonnull error) {
                           [self handleInMainThread:task responseObject:responseObject error:error];
                       }];
        } break;
        case LPDHTTPMethodPut: {
            _task = [LPDBHttpManager PUT:self.path
                              parameters:self.params
                       completionHandler:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject, NSError *_Nonnull error) {
                           [self handleInMainThread:task responseObject:responseObject error:error];
                       }];
        } break;
        case LPDHTTPMethodPost: {
            _task = [LPDBHttpManager POST:self.path parameters:self.params completionHandler:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject, NSError *_Nonnull error) {
                [self handleInMainThread:task responseObject:responseObject error:error];
            }];
        } break;
        case LPDHTTPMethodDelete: {
            _task = [LPDBHttpManager DELETE:self.path
                                 parameters:self.params
                          completionHandler:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject, NSError *_Nonnull error) {
                              [self handleInMainThread:task responseObject:responseObject error:error];
                          }];
        } break;
        case LPDHTTPMethodImage: {
            if (self.images) {
                _task = [LPDBHttpManager POST:self.path
                    parameters:self.params
                    images:self.images
                    completionHandler:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject, NSError *_Nonnull error) {
                        [self handleInMainThread:task responseObject:responseObject error:error];
                    }
                    progress:^(NSProgress *_Nonnull uploadProgress) {
                        if (progress) {
                            progress(uploadProgress);
                        }
                    }];
            } else if (self.image) {
                _task = [LPDBHttpManager POST:self.path parameters:self.params image:self.image imageName:self.imageName completionHandler:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject, NSError *_Nonnull error) {
                    [self handleInMainThread:task responseObject:responseObject error:error];
                } progress:^(NSProgress *_Nonnull uploadProgress) {
                    if (progress) {
                        progress(uploadProgress);
                    }
                }];
            }

        } break;
        default:
            break;
    }
}

- (void)startRequestComplete:(LPDBRequestComplete)complete {
    [self startRequestComplete:complete progress:nil];
}

- (void)cancel {
    [_task cancel];
}

- (NSDictionary *)params {
    NSMutableDictionary *propertyParams = [NSMutableDictionary dictionaryWithDictionary:[self propertyDictionary]];
    if ([self mapKey].allKeys.count != 0) {
        for (NSString *key in [self mapKey].allKeys) {
            if (propertyParams[key]) {
                [propertyParams setObject:propertyParams[key] forKey:[self mapKey][key]];
                [propertyParams removeObjectForKey:key];
            }
        }
    }

    return propertyParams.count == 0 ? nil : [propertyParams copy];
}

- (NSDictionary *)mapKey {
    return nil;
}

- (NSString *)className {
    return _className;
}

- (NSDictionary *)paramDic {
    return [self params];
}

- (void)handleInMainThread:(NSURLSessionDataTask *)task responseObject:(id)responseObject error:(NSError *)error {
    if ([[NSThread currentThread] isMainThread]) {
        [self handleRespondse:task responseObject:responseObject error:error];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self handleRespondse:task responseObject:responseObject error:error];
        });
    }
}

- (void)handleRespondse:(NSURLSessionDataTask *)response responseObject:(id)responseObject error:(NSError *)error {
#if DEBUG
    [KZWDebugService setCurrentDebug:responseObject];
    [KZWDebugService saveDebug];
#endif
    if (self.complete) {
        if (error) {
            self.complete(nil, error);
            return;
        }
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            id code = ((NSDictionary *)responseObject)[@"code"];
            if ([code isKindOfClass:[NSString class]]) {
                if ([code integerValue] == 0) {
                    NSError *parseError = nil;
                    if (!self.className) {
                        self.complete(responseObject[@"data"], nil);
                        return;
                    }

                    if ([responseObject[@"data"] isKindOfClass:[NSArray class]]) {

                        if (!self.className) {
                            self.complete(responseObject, nil);
                            return;
                        }

                        NSError *parseError = nil;
                        NSArray *object = [MTLJSONAdapter modelsOfClass:NSClassFromString(self.className)
                                                          fromJSONArray:responseObject[@"data"]
                                                                  error:&parseError];
                        if (parseError) {
                            self.complete(nil, [NSError errorWithDomain:LPDBNetworkErrorDomain
                                                                   code:LPDBNeteworkBusinessError
                                                               userInfo:@{
                                                                   LPDBNetworkUserMessage : @"后台数据格式不正确"
                                                               }]);
                            return;
                        }
                        self.complete(object, nil);
                        return;
                    }

                    id object = [MTLJSONAdapter modelOfClass:NSClassFromString(self.className)
                                          fromJSONDictionary:responseObject[@"data"]
                                                       error:&parseError];
                    if (parseError) {
                        self.complete(nil, [NSError errorWithDomain:LPDBNetworkErrorDomain
                                                               code:LPDBNeteworkBusinessError
                                                           userInfo:@{
                                                               LPDBNetworkUserMessage : @"后台数据格式不正确"
                                                           }]);
                        ;
                        return;
                    }
                    self.complete(object, nil);
                    return;
                }

                NSString *message = ((NSDictionary *)responseObject)[@"msg"] ? ((NSDictionary *)responseObject)[@"msg"] : @"未知错误";

                if ([code integerValue] == 20000) {
                    [ELMKeychainUtil deleteAllInfoInKeyChain];
                }

                NSError *logicError = [NSError errorWithDomain:LPDBNetworkErrorDomain
                                                          code:LPDBNeteworkBusinessError
                                                      userInfo:@{
                                                          LPDBNetworkUserMessage : message,
                                                          LPDBNetworkBusinessErrorCode : code ? code : @"unknow"
                                                      }];
                self.complete(nil, logicError);
                return;
            }
            NSError *dataError = [NSError errorWithDomain:LPDBNetworkErrorDomain
                                                     code:LPDBNeteworkBusinessError
                                                 userInfo:@{
                                                     LPDBNetworkUserMessage : @"数据格式不正确"
                                                 }];
            self.complete(nil, dataError);
            return;
        } else if ([responseObject isKindOfClass:[NSArray class]]) {
            if (!self.className) {
                self.complete(responseObject, nil);
                return;
            }
            NSError *parseError = nil;
            NSArray *object =
                [MTLJSONAdapter modelsOfClass:NSClassFromString(self.className) fromJSONArray:responseObject[@"data"] error:&parseError];
            if (parseError) {
                self.complete(nil, [NSError errorWithDomain:LPDBNetworkErrorDomain
                                                       code:LPDBNeteworkBusinessError
                                                   userInfo:@{
                                                       LPDBNetworkUserMessage : @"后台数据格式不正确"
                                                   }]);
                return;
            }
            self.complete(object, nil);
        }
    }
}

@end
