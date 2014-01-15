//
//  RHCTestEntityPropertyMapping.m
//  ZLMappingStorageKit
//
//  Created by Lee on 13-11-26.
//  Copyright (c) 2013年 ZhuochengLee. All rights reserved.
//

#import "RHCTestEntityPropertyMapping.h"

@implementation RHCTestEntityPropertyMapping

- (id)init
{
    if (self = [super init]) {
        self.mappingType = ZLMappingTypeEnumEntity;
    }

    return self;
}

- (NSManagedObjectContext *)entityMOC
{
    return nil;
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