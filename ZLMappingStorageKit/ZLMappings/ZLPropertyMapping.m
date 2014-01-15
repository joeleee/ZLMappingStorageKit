//
//  ZLPropertyMapping.m
//  ZLMappingStorageKit
//
//  Created by Lee on 13-11-21.
//  Copyright (c) 2013年 ZhuochengLee. All rights reserved.
//

#import "ZLPropertyMapping.h"

@implementation ZLPropertyMapping

+ (ZLPropertyMapping *)propertyMappingWithPropertyKey:(NSString *)propertyKey
                                          responseKey:(NSString *)responseKey
                                                 rule:(id<ZLMappingRuleProtocol>)mappingRule
{
    ZLPropertyMapping *propertyMapping = [[ZLPropertyMapping alloc] init];
    propertyMapping.propertyKey = propertyKey;
    propertyMapping.responseKey = responseKey;
    propertyMapping.mappingRule = mappingRule;

    return propertyMapping;
}

@end