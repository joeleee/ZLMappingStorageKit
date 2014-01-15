//
//  ZLMappingOperationFactory.m
//  ZLMappingStorageKit
//
//  Created by Lee on 13-11-21.
//  Copyright (c) 2013年 ZhuochengLee. All rights reserved.
//

#import "ZLMappingOperationFactory.h"

#import "ZLObjectMappingOperation.h"
#import "ZLEntityMappingOperation.h"

@implementation ZLMappingOperationFactory

+ (id <ZLMappingOperationProtocol>)mappingWithRule:(id <ZLMappingRuleProtocol>)mappingRule
{
    id <ZLMappingOperationProtocol> mapping = nil;

    if ([mappingRule respondsToSelector:@selector(mappingType)]) {
        switch (mappingRule.mappingType) {
            case ZLMappingTypeEnumObject: {
                break;
            }
            case ZLMappingTypeEnumEntity: {
                break;
            }
            default: {
                mapping = nil;
                break;
            }
        }
    } else if ([mappingRule conformsToProtocol:@protocol(ZLEntityMappingRuleProtocol)]) {
        mapping = [ZLEntityMappingOperation mappingWithMappingRule:mappingRule];
    } else if ([mappingRule conformsToProtocol:@protocol(ZLMappingRuleProtocol)]) {
        mapping = [ZLObjectMappingOperation mappingWithMappingRule:mappingRule];
    }

    return mapping;
}

@end