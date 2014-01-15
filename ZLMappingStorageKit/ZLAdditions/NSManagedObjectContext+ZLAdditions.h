//
//  NSManagedObjectContext+ZLAdditions.h
//  ZLMappingStorageKit
//
//  Created by Lee on 13-11-26.
//  Copyright (c) 2013年 ZhuochengLee. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (ZLAdditions)

// Inserts a new managed object for the entity for the given name.
- (id)insertNewObjectForEntityForName:(NSString *)entityName;

// Convenience method for performing a count of the number of instances of an entity with the given name.
- (NSUInteger)countForEntityForName:(NSString *)entityName predicate:(NSPredicate *)predicate error:(NSError **)error;

// Saves the receiver and then traverses up the parent context chain until a parent managed object context with a nil parent is found. If the final ancestor context does not have a reference to the persistent store coordinator, then a warning is generated and the method returns NO.
- (BOOL)saveToPersistentStore:(NSError **)error;

@end