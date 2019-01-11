//
//  LPDBModel.h
//  LPDCrowdsource
//
//  Created by sq on 15/11/6.
//  Copyright © 2015年 elm. All rights reserved.
//
#import "MTLModel.h"
#import <Foundation/Foundation.h>
#import <Mantle/MTLJSONAdapter.h>

@interface LPDBModel : MTLModel <MTLJSONSerializing>
/**
 *  json key 值映射
 *  属性名与json key
 *  @return
 */
+ (NSDictionary *)mapKey;

/**
 *  过滤掉不参加映射的属性值
 *
 *  @return
 */
+ (NSArray *)filter;
@end
