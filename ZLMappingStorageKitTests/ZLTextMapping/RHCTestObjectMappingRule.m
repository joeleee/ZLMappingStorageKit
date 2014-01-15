//
//  RHCTestMapping.m
//  ZLMappingStorageKit
//
//  Created by Lee on 13-11-25.
//  Copyright (c) 2013年 ZhuochengLee. All rights reserved.
//

#import "RHCTestObjectMappingRule.h"

#import "ZLPropertyMapping.h"
#import "RHCTestObjectPropertyMapping.h"

@implementation RHCTestObjectMappingRule

- (id)init
{
    if (self = [super init]) {
        ZLPropertyMapping *m = [[ZLPropertyMapping alloc] init];
        m.mappingRule = [[RHCTestObjectPropertyMapping alloc] init];
        m.responseKey = @"picture_list";
        m.propertyKey = @"pictureList";
        self.propertyMappings = @[m];
        self.mappingType = ZLMappingTypeEnumObject;
    }

    return self;
}

- (NSString *)requestPath
{
    return @"game/getGameDetail";
}

- (NSString *)responsePath
{
    return @"";
}

- (NSString *)reponseClassName
{
    return nil;
}

- (NSDictionary *)reponseMapping
{
    return @{@"app_description":@"appDescription",
             @"app_id":@"appID",
             @"app_size":@"appSize",
             @"app_content":@"appContent",
             @"app_name":@"appName",
             @"icon":@"appIcon",
             @"app_ziduan":@"myRanking",
             @"create_time":@"appCreateTime"};
}

@end