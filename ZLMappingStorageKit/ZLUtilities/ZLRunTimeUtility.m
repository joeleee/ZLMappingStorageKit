//
//  ZLRunTimeUtility.m
//  ZLMappingStorageKit
//
//  Created by Lee on 13-12-13.
//  Copyright (c) 2013年 ZhuochengLee. All rights reserved.
//

#import "ZLRunTimeUtility.h"

#import <objc/runtime.h>

@implementation ZLRunTimeUtility

+ (id)defaultValueForObject:(id)object withPropertyName:(NSString *)propertyName
{
    objc_property_t property = class_getProperty([object class], [propertyName UTF8String]);
    NSString *attrs = [NSString stringWithUTF8String:property_getAttributes(property)];
    NSArray *attrParts = [attrs componentsSeparatedByString:@","];

    id value = nil;
    if ([attrs rangeOfString:@",R,"].location != NSNotFound) {
        return value;
    }

    NSString *name = [attrParts[0] substringFromIndex:1];
    if ([self isAtomType:name] || [self isNumberType:name]) {
        value = @0;
    } else if ([self isDateType:name]) {
        value = [NSDate date];
    } else if ([self isStringType:name]) {
        value = @"";
    } else {
        value = nil;
    }

    return value;
}

+ (BOOL)isAtomType:(NSString *)type
{
    static NSArray *atomTypeList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        atomTypeList = @[@"c", @"i", @"s", @"l", @"q", @"C", @"I", @"S", @"L", @"Q", @"f", @"d", @"B"];
    });

    if ([atomTypeList containsObject:type]) {
        return YES;
    }

    return NO;
}

+ (BOOL)isStringType:(NSString *)type
{
    if ([type isEqualToString:@"@\"NSString\""]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isNumberType:(NSString *)type
{
    if ([type isEqualToString:@"@\"NSNumber\""]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isDateType:(NSString *)type
{
    if ([type isEqualToString:@"@\"NSDate\""]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isIDType:(NSString *)type
{
    if ([type isEqualToString:@"@"]) {
        return YES;
    }
    return NO;
}

@end