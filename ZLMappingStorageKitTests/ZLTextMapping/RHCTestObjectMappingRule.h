//
//  RHCTestMapping.h
//  ZLMappingStorageKit
//
//  Created by Lee on 13-11-25.
//  Copyright (c) 2013年 ZhuochengLee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZLMappingProtocol.h"

@interface RHCTestObjectMappingRule : NSObject <ZLMappingRuleProtocol>

@property (nonatomic, assign) ZLMappingTypeEnum mappingType;
@property (nonatomic, strong) NSArray *propertyMappings;

@end