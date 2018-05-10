//
//  LPDBRequestObject.h
//  LPDCrowdsource
//
//  Created by sq on 15/11/4.
//  Copyright © 2015年 elm. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <Mantle/MTLModel.h>
#import "LPDBHttpManager.h"

typedef NS_ENUM(NSUInteger, LPDHTTPMethod) {
  LPDHTTPMethodGet,
  LPDHTTPMethodPost,
  LPDHTTPMethodPut,
  LPDHTTPMethodDelete,
};

typedef void (^LPDBRequestComplete)(id object, NSError *error);

@interface LPDBRequestObject : MTLModel


@property (nonatomic, strong) NSString *path;

@property (nonatomic, assign) BOOL isFormData;

/**
 *  json 解析成的对象类名 当josn是数组时 表示数组对象的类名
 */
@property (nonatomic, strong) NSString *className;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) NSDictionary *paramDic;

@property (nonatomic, assign) LPDHTTPMethod method;

@property (nonatomic, readonly) NSURLSessionDataTask *task;

- (void)startRequestComplete:(LPDBRequestComplete)complete;

- (void)startRequestComplete:(LPDBRequestComplete)complete progress:(void (^)(NSProgress * uploadProgress)) progress;

- (void)cancel;

@end
