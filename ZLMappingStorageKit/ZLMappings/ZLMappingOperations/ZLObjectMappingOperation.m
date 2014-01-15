//
//  ZLObjectMappingOperation.m
//  ZLMappingStorageKit
//
//  Created by Lee on 13-11-21.
//  Copyright (c) 2013年 ZhuochengLee. All rights reserved.
//

#import "ZLObjectMappingOperation.h"

#import "ZLPropertyMapping.h"
#import "ZLMappingOperationFactory.h"
#import "ZLRunTimeUtility.h"

@interface ZLObjectMappingOperation ()

@property (nonatomic, strong) id<ZLMappingRuleProtocol> mappingRule;

@end

@implementation ZLObjectMappingOperation

+ (ZLObjectMappingOperation *)mappingWithMappingRule:(id<ZLMappingRuleProtocol>)mappingRule
{
    ZLObjectMappingOperation *mapping = [[ZLObjectMappingOperation alloc] init];
    mapping.mappingRule = mappingRule;

    return mapping;
}

- (id)processNetworkResult:(NSDictionary *)networkResult
{
    id result = networkResult;

    if ([self.mappingRule respondsToSelector:@selector(responsePath)] &&
        (0 < [self.mappingRule responsePath].length)) {
        result = [networkResult objectForKey:[self.mappingRule responsePath]];
    }

    id mappingResult = [self processByResponsePath:result];

    return mappingResult;
}

- (id)processByResponsePath:(id)data
{
    if (!data) {
        return data;
    }

    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray *mappingResult = [NSMutableArray array];

        for (id perData in data) {
            id object = [self processByResponsePath:perData];
            if (object) {
                [mappingResult addObject:object];
            }
        }
        return mappingResult;

    } else if ([data isKindOfClass:[NSDictionary class]]) {

        if ([self.mappingRule respondsToSelector:@selector(correctionNetworkResult:)]) {
            data = [self.mappingRule correctionNetworkResult:data];
        }

        id object = [self processDictionary:data];

        if ([self.mappingRule respondsToSelector:@selector(correctionMappingResult:)]) {
            object = [self.mappingRule correctionMappingResult:object];
        }

        return object;

    } else {
        NSAssert(NO, @"ZLObjectMapping processNetworkResult: Unsupported networkResult type!");
    }

    return data;
}

- (id)processDictionary:(NSDictionary *)result
{
    Class objectClass = NSClassFromString([self.mappingRule reponseClassName]);
    if (![objectClass isKindOfClass:[NSObject class]]) {
        return result;
    }
    id object = [[objectClass alloc] init];

    for (NSString *key in [[self.mappingRule reponseMapping] allKeys]) {
        NSString *propertyKey = [[self.mappingRule reponseMapping] objectForKey:key];
        id propertyValue = [result objectForKey:key];
        if (!propertyValue && ![object isKindOfClass:[NSDictionary class]]) {
            propertyValue = [ZLRunTimeUtility defaultValueForObject:object withPropertyName:propertyKey];
        }
        [object setValue:propertyValue forKey:propertyKey];
    }

    if ([self.mappingRule respondsToSelector:@selector(propertyMappings)]) {
        for (ZLPropertyMapping *propertyMapping in self.mappingRule.propertyMappings) {

            id <ZLMappingOperationProtocol> mapping = [ZLMappingOperationFactory mappingWithRule:propertyMapping.mappingRule];
            id propertyValue = [mapping processNetworkResult:[result objectForKey:propertyMapping.responseKey]];
            [object setValue:propertyValue forKey:propertyMapping.propertyKey];
        }
    }
    return object;
}

@end