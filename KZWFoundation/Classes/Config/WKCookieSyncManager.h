//
//  WKCookieSyncManager.h
//  shoes
//
//  Created by 奉强 on 16/4/5.
//  Copyright © 2016年 saygogo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface WKCookieSyncManager : NSObject

@property (nonatomic, strong) WKProcessPool *processPool;

- (void)setCookie;

+ (instancetype)sharedWKCookieSyncManager;

@end
