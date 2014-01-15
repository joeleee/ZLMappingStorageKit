//
//  RHCTestEntityMappingRule.h
//  ZLMappingStorageKit
//
//  Created by Lee on 13-11-26.
//  Copyright (c) 2013年 ZhuochengLee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZLMappingProtocol.h"

@interface RHCTestEntityMappingRule : NSObject <ZLEntityMappingRuleProtocol>

@property (nonatomic, assign) ZLMappingTypeEnum mappingType;
@property (nonatomic, strong) NSArray *propertyMappings;
@property (nonatomic, strong) NSArray *filterKeys;

@end