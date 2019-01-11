//
//  KZWJavascripModel.m
//  kongzhongfinancial
//
//  Created by ouyang on 2018/5/16.
//  Copyright © 2018年 ouy. All rights reserved.
//

#import "KZWJavascripModel.h"
#import <Mantle/Mantle.h>

@implementation KZWJavascripModel

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([key isEqualToString:@"shareContent"]) {
        return [MTLJSONAdapter dictionaryTransformerWithModelClass:[KZWShareModel class]];
    }
    return nil;
}

@end

@implementation KZWShareModel

@end

@implementation KZWWebControllerModel

@end
