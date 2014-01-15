//
//  RHCTestObjectPropertyMapping.m
//  ZLMappingStorageKit
//
//  Created by Lee on 13-11-25.
//  Copyright (c) 2013年 ZhuochengLee. All rights reserved.
//

#import "RHCTestObjectPropertyMapping.h"

@implementation RHCTestObjectPropertyMapping

- (id)init
{
    if (self = [super init]) {
        self.mappingType = ZLMappingTypeEnumObject;
    }

    return self;
}

- (NSString *)requestPath
{
    return nil;
}

- (NSString *)responsePath
{
    return nil;
}

- (NSString *)reponseClassName
{
    return nil;
}

- (NSDictionary *)reponseMapping
{
    return @{@"picture_display_order":@"displayIndex",
             @"picture_name":@"pictureName",
             @"picture_thumbnail":@"pictureUrl"};
}

@end