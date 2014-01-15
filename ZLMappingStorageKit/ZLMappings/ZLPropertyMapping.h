//
//  ZLPropertyMapping.h
//  ZLMappingStorageKit
//
//  Created by Lee on 13-11-21.
//  Copyright (c) 2013年 ZhuochengLee. All rights reserved.
//

#import "ZLMappingProtocol.h"

@interface ZLPropertyMapping : NSObject

@property (nonatomic, strong) id<ZLMappingRuleProtocol> mappingRule;
@property (nonatomic, copy) NSString *propertyKey;
@property (nonatomic, copy) NSString *responseKey;

@end