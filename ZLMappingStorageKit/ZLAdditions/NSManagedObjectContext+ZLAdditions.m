//
//  NSManagedObjectContext+ZLAdditions.m
//  ZLMappingStorageKit
//
//  Created by Lee on 13-11-26.
//  Copyright (c) 2013年 ZhuochengLee. All rights reserved.
//

#import "NSManagedObjectContext+ZLAdditions.h"

@implementation NSManagedObjectContext (ZLAdditions)

- (id)insertNewObjectForEntityForName:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
}

- (NSUInteger)countForEntityForName:(NSString *)entityName predicate:(NSPredicate *)predicate error:(NSError **)error
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];

    fetchRequest.predicate = predicate;
    return [self countForFetchRequest:fetchRequest error:error];
}

- (BOOL)saveToPersistentStore:(NSError **)error
{
    __block NSError        *localError = nil;
    NSManagedObjectContext *contextToSave = self;

    while (contextToSave) {
        __block BOOL success;

        /**
         *   To work around issues in ios 5 first obtain permanent object ids for any inserted objects.  If we don't do this then its easy to get an `NSObjectInaccessibleException`.  This happens when:
         *
         *   1. Create new object on main context and save it.
         *   2. At this point you may or may not call obtainPermanentIDsForObjects for the object, it doesn't matter
         *   3. Update the object in a private child context.
         *   4. Save the child context to the parent context (the main one) which will work,
         *   5. Save the main context - a NSObjectInaccessibleException will occur and Core Data will either crash your app or lock it up (a semaphore is not correctly released on the first error so the next fetch request will block forever.
         */
        [contextToSave obtainPermanentIDsForObjects:[[contextToSave insertedObjects] allObjects] error:&localError];

        if (localError) {
            if (error) {
                *error = localError;
            }

            return NO;
        }

        [contextToSave performBlockAndWait:^{
            success = [contextToSave save:&localError];
            // NSLog(@"If saving of managed object context failed, but a `nil` value for the `error` argument was returned. This typically indicates an invalid implementation of a key-value validation method exists within your model. This violation of the API contract may result in the save operation being mis-interpretted by callers that rely on the availability of the error.");
        }];

        if (!success) {
            if (error) {
                *error = localError;
            }

            return NO;
        }

        if (!contextToSave.parentContext && (contextToSave.persistentStoreCoordinator == nil)) {
            // NSLog(@"Reached the end of the chain of nested managed object contexts without encountering a persistent store coordinator. Objects are not fully persisted.");
            return NO;
        }

        contextToSave = contextToSave.parentContext;
    }

    return YES;
}

@end