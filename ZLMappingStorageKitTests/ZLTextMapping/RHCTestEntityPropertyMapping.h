//
//  RHCTestEntityPropertyMapping.h
//  ZLMappingStorageKit
//
//  Created by Lee on 13-11-26.
//  Copyright (c) 2013年 ZhuochengLee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZLMappingProtocol.h"

@interface RHCTestEntityPropertyMapping : NSObject <ZLEntityMappingRuleProtocol>

@property (nonatomic, assign) ZLMappingTypeEnum mappingType;

@end