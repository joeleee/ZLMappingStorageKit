//
//  ZLObjectMappingOperation.h
//  ZLMappingStorageKit
//
//  Created by Lee on 13-11-21.
//  Copyright (c) 2013年 ZhuochengLee. All rights reserved.
//

#import "ZLMappingProtocol.h"

@interface ZLObjectMappingOperation : NSObject <ZLMappingOperationProtocol>

@property (readonly, nonatomic, strong) id<ZLMappingRuleProtocol> mappingRule;

@end