//
//  ZLEntityMappingOperation.m
//  ZLMappingStorageKit
//
//  Created by Lee on 13-11-21.
//  Copyright (c) 2013年 ZhuochengLee. All rights reserved.
//

#import "ZLEntityMappingOperation.h"

#import "ZLPropertyMapping.h"
#import "ZLMappingOperationFactory.h"
#import "NSManagedObjectContext+ZLAdditions.h"
#import "ZLRunTimeUtility.h"

@interface ZLEntityMappingOperation ()

@property (nonatomic, strong) id <ZLEntityMappingRuleProtocol> mappingRule;

@end

@implementation ZLEntityMappingOperation

+ (ZLEntityMappingOperation *)mappingWithMappingRule:(id <ZLEntityMappingRuleProtocol> )mappingRule
{
    ZLEntityMappingOperation *mapping = [[ZLEntityMappingOperation alloc] init];

    mapping.mappingRule = mappingRule;

    return mapping;
}

- (id)processNetworkResult:(NSDictionary *)networkResult
{
    id result = networkResult;

    if ([self.mappingRule respondsToSelector:@selector(responsePath)] &&
        (0 < [self.mappingRule responsePath].length)) {
        result = [networkResult objectForKey:[self.mappingRule responsePath]];
    }

    id mappingResult = [self processByResponsePath:result];

    NSError *error = nil;
    [[self.mappingRule entityMOC] saveToPersistentStore:&error];

    return mappingResult;
}

- (id)processByResponsePath:(id)data
{
    if (!data) {
        return data;
    }

    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray *mappingResult = [NSMutableArray array];

        for (id perData in data) {
            id object = [self processByResponsePath:perData];

            if (object) {
                [mappingResult addObject:object];
            }
        }

        return mappingResult;
    } else if ([data isKindOfClass:[NSDictionary class]]) {

        if ([self.mappingRule respondsToSelector:@selector(correctionNetworkResult:)]) {
            data = [self.mappingRule correctionNetworkResult:data];
        }

        id object = [self processDictionary:data];

        if ([self.mappingRule respondsToSelector:@selector(correctionMappingResult:)]) {
            object = [self.mappingRule correctionMappingResult:object];
        }

        return object;
    } else {
        NSAssert(NO, @"ZLObjectMapping processNetworkResult: Unsupported networkResult type!");
    }

    return data;
}

- (id)processDictionary:(NSDictionary *)result
{
    NSManagedObject *object = [self filterPrimaryKeys:result];

    return object;
}

- (NSManagedObject *)filterPrimaryKeys:(NSDictionary *)dict
{
    if (!dict ||
        ![self.mappingRule respondsToSelector:@selector(filterKeys)] ||
        (0 >= self.mappingRule.filterKeys.count)) {
        NSManagedObject *object = [[self.mappingRule entityMOC] insertNewObjectForEntityForName:[self.mappingRule reponseClassName]];
        object = [self setObject:object withDict:dict];
        return object;
    }

    NSPredicate    *predicate = nil;
    NSArray        *localObjects = nil;
    NSError        *error = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self.mappingRule reponseClassName]];

    if ([self.mappingRule respondsToSelector:@selector(isValueEqualWithKey:value1:value2:)]) {
        localObjects = [[self.mappingRule entityMOC] executeFetchRequest:request error:&error];
        predicate = [NSPredicate predicateWithBlock:^BOOL (id evaluatedObject, NSDictionary *bindings) {
                for (NSString *primaryKey in self.mappingRule.filterKeys) {
                    NSArray *dictKeys = [[self.mappingRule reponseMapping] allKeysForObject:primaryKey];

                    if (0 >= dictKeys.count) {
                        return NO;
                    }

                    BOOL isEqual = [self.mappingRule isValueEqualWithKey:primaryKey
                                                                  value1:[evaluatedObject valueForKey:primaryKey]
                                                                  value2:[dict valueForKey:dictKeys[0]]];

                    if (!isEqual) {
                        return NO;
                    }
                }

                return YES;
            }];
        localObjects = [localObjects filteredArrayUsingPredicate:predicate];
    } else {
        NSMutableArray *filterPredicateStatement = [NSMutableArray array];

        for (NSString *key in self.mappingRule.filterKeys) {
            NSArray *networkKeys = [[self.mappingRule reponseMapping] allKeysForObject:key];

            for (NSString *networkKey in networkKeys) {
                if ([dict objectForKey:networkKey]) {
                    NSString *statement = [NSString stringWithFormat:@"(%@ == %@)", key, [dict objectForKey:networkKey]];
                    [filterPredicateStatement addObject:statement];
                    break;
                }
            }
        }

        NSString *predicateString = [filterPredicateStatement componentsJoinedByString:@" AND "];
        if (0 < predicateString.length) {
            predicate = [NSPredicate predicateWithFormat:predicateString];
        }
        [request setPredicate:predicate];
        localObjects = [[self.mappingRule entityMOC] executeFetchRequest:request error:&error];
    }

    if (0 < [localObjects count]) {
        NSManagedObject                 *localObject = localObjects[0];
        ZLMappingConflictResolutionEnum conflictResolution = ZLMappingConflictCover;

        if ([self.mappingRule respondsToSelector:@selector(objectConflictResolution)]) {
            conflictResolution = [self.mappingRule objectConflictResolution];
        }

        NSManagedObject *object = [self conflictObject:localObject
                                          keyValueDict:dict
                                withConflictResolution:conflictResolution];
        return object;
    } else {
        NSManagedObject *object = [[self.mappingRule entityMOC] insertNewObjectForEntityForName:[self.mappingRule reponseClassName]];
        object = [self setObject:object withDict:dict];
        return object;
    }
}

- (NSManagedObject *)conflictObject:(NSManagedObject *)object
                       keyValueDict:(NSDictionary *)keyValueDict
             withConflictResolution:(ZLMappingConflictResolutionEnum)conflictResolution
{
    switch (conflictResolution) {
    case ZLMappingConflictCoexist:
        {
            NSManagedObject *newObject = [[self.mappingRule entityMOC] insertNewObjectForEntityForName:[self.mappingRule reponseClassName]];
            newObject = [self setObject:newObject withDict:keyValueDict];
            return newObject;

            break;
        }

    case ZLMappingConflictAbandon:
        {
            return object;

            break;
        }

    case ZLMappingConflictCover:
        {
            object = [self setObject:object withDict:keyValueDict];
            return object;

            break;
        }

    case ZLMappingConflictMerge:
        {
            if ([self.mappingRule respondsToSelector:@selector(mergeObject:tempObject:)]) {
                NSManagedObject *compareObject = [[self.mappingRule entityMOC] insertNewObjectForEntityForName:[self.mappingRule reponseClassName]];
                compareObject = [self setObject:compareObject withDict:keyValueDict];
                object = [self.mappingRule mergeObject:object tempObject:compareObject];
                [[self.mappingRule entityMOC] deleteObject:compareObject];
            }

            return object;

            break;
        }

    default:
        {
            return object;

            break;
        }
    }
}

- (NSManagedObject *)setObject:(NSManagedObject *)object withDict:(NSDictionary *)result
{
    if (!object) {
        return object;
    }

    for (NSString *key in [[self.mappingRule reponseMapping] allKeys]) {
        NSString *propertyKey = [[self.mappingRule reponseMapping] objectForKey:key];
        id propertyValue = [result objectForKey:key];
        if (!propertyValue) {
            propertyValue = [ZLRunTimeUtility defaultValueForObject:object withPropertyName:propertyKey];
        }
        [object setValue:propertyValue forKey:propertyKey];
    }

    if ([self.mappingRule respondsToSelector:@selector(propertyMappings)]) {
        for (ZLPropertyMapping *propertyMapping in self.mappingRule.propertyMappings) {
            id <ZLMappingOperationProtocol> mapping = [ZLMappingOperationFactory mappingWithRule:propertyMapping.mappingRule];
            id                              propertyValue = [mapping processNetworkResult:[result objectForKey:propertyMapping.responseKey]];

            id value = [object valueForKey:propertyMapping.propertyKey];

            if ([value isKindOfClass:[NSSet class]]) {
                NSMutableSet *set = [NSMutableSet set];

                if ([propertyValue isKindOfClass:[NSArray class]]) {
                    [set addObjectsFromArray:propertyValue];
                } else if (propertyValue) {
                    [set addObject:propertyValue];
                }

                [object setValue:set forKey:propertyMapping.propertyKey];
            } else if ([value isKindOfClass:[NSOrderedSet class]]) {
                NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSet];

                if ([propertyValue isKindOfClass:[NSArray class]]) {
                    [orderedSet addObjectsFromArray:propertyValue];
                } else if (propertyValue) {
                    [orderedSet addObject:propertyValue];
                }

                [object setValue:orderedSet forKey:propertyMapping.propertyKey];
            } else {
                if (!propertyValue) {
                    propertyValue = [ZLRunTimeUtility defaultValueForObject:object withPropertyName:propertyMapping.propertyKey];
                }
                [object setValue:propertyValue forKey:propertyMapping.propertyKey];
            }
        }
    }

    return object;
}

@end