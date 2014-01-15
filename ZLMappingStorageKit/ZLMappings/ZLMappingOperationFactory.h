//
//  ZLMappingOperationFactory.h
//  ZLMappingStorageKit
//
//  Created by Lee on 13-11-21.
//  Copyright (c) 2013年 ZhuochengLee. All rights reserved.
//

#import "ZLMappingProtocol.h"

@interface ZLMappingOperationFactory : NSObject

+ (id <ZLMappingOperationProtocol>)mappingWithRule:(id <ZLMappingRuleProtocol>)mappingRule;

@end