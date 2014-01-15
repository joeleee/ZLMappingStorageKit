//
//  ZLMappingProtocol.h
//  ZLMappingStorageKit
//
//  Created by Lee on 13-11-21.
//  Copyright (c) 2013年 ZhuochengLee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZLMappingRuleProtocol;

typedef enum {
    ZLMappingTypeEnumObject = 1,
    ZLMappingTypeEnumEntity = 2
} ZLMappingTypeEnum;

typedef enum {
    ZLMappingConflictCoexist = 0, // default
    ZLMappingConflictAbandon = 1,
    ZLMappingConflictCover = 2,
    ZLMappingConflictMerge = 3
} ZLMappingConflictResolutionEnum;

#pragma mark - mapping base
@protocol ZLMappingOperationProtocol <NSObject>

@required
@property (readonly, nonatomic, strong) id <ZLMappingRuleProtocol> mappingRule;
+ (id <ZLMappingOperationProtocol> )mappingWithMappingRule:(id <ZLMappingRuleProtocol> )mappingRule;
- (id)processNetworkResult:(NSDictionary *)networkResult;

@end

#pragma mark - mapping rule
@protocol ZLMappingRuleProtocol <NSObject>

@required
- (NSString *)requestPath;
- (NSString *)reponseClassName;
- (NSDictionary *)reponseMapping;

@optional
@property (nonatomic, assign, readonly) ZLMappingTypeEnum mappingType;
@property (nonatomic, strong, readonly) NSArray *propertyMappings;
- (NSDictionary *)requestQuery;
- (NSString *)responsePath;
- (NSDictionary *)correctionNetworkResult:(NSDictionary *)result;
- (id)correctionMappingResult:(id)mappingResult;

@end

#pragma mark - entity mapping rule
@protocol ZLEntityMappingRuleProtocol <ZLMappingRuleProtocol>

@required
- (NSManagedObjectContext *)entityMOC;

@optional
@property (nonatomic, strong, readonly) NSArray *filterKeys;
@property (nonatomic, assign, readonly) ZLMappingConflictResolutionEnum objectConflictResolution;
- (BOOL)isValueEqualWithKey:(NSString *)key
                     value1:(id)value1
                     value2:(id)value2;
- (NSManagedObject *)mergeObject:(NSManagedObject *)newObject
                      tempObject:(NSManagedObject *)tempObject;

@end