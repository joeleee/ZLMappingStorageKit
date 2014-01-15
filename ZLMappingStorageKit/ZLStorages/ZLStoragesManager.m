//
//  ZLStoragesManager.m
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import "ZLStoragesManager.h"

#import "NSManagedObjectContext+ZLAdditions.h"

@interface ZLStoragesManager ()

@property (nonatomic, strong) NSMutableDictionary *managedObjectContexts;

@end

@implementation ZLStoragesManager

+ (ZLStoragesManager *)sharedManager
{
    static ZLStoragesManager *sharedInstance;
    static dispatch_once_t      onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.managedObjectContexts = [NSMutableDictionary dictionary];
    });
    return sharedInstance;
}

- (NSManagedObjectContext *)managedObjectContextForFullPath:(NSString *)path modelName:(NSString *)model
{
    NSManagedObjectContext *managedObjectContext = [self.managedObjectContexts objectForKey:path];

    if (!managedObjectContext) {
        managedObjectContext = [self createManagedObjectContextWithFullPath:path modelName:model];
        [self.managedObjectContexts setObject:managedObjectContext forKey:path];
    }

    return managedObjectContext;
}

- (BOOL)saveContextForFullPath:(NSString *)path
{
    BOOL isSucceed = NO;

    NSError                *error = nil;
    NSManagedObjectContext *managedObjectContext = [self.managedObjectContexts objectForKey:path];

    if (!managedObjectContext) {
        isSucceed = NO;
    } else if (![managedObjectContext hasChanges]) {
        isSucceed = YES;
    } else {
        isSucceed = [managedObjectContext saveToPersistentStore:&error];

        if (!isSucceed) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }

    }

    return isSucceed;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)createManagedObjectContextWithFullPath:(NSString *)path modelName:(NSString *)model
{
    NSManagedObjectContext *managedObjectContext = nil;
    NSPersistentStoreCoordinator *coordinator = [self createPersistentStoreCoordinatorWithFullPath:path modelName:model];

    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }

    return managedObjectContext;
}

- (NSManagedObjectModel *)createManagedObjectModelWithModelName:(NSString *)model
{
    NSManagedObjectModel *managedObjectModel = nil;
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:model withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)createPersistentStoreCoordinatorWithFullPath:(NSString *)path modelName:(NSString *)model
{
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    [self createPathToStoreFileIfNeccessary:storeURL];

    NSPersistentStoreCoordinator *persistentStoreCoordinator = nil;
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self createManagedObjectModelWithModelName:model]];

    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return persistentStoreCoordinator;
}

- (void)createPathToStoreFileIfNeccessary:(NSURL *)urlForStore
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *pathToStore = [urlForStore URLByDeletingLastPathComponent];

    NSError *error = nil;
    BOOL pathWasCreated = [fileManager createDirectoryAtPath:[pathToStore path] withIntermediateDirectories:YES attributes:nil error:&error];

    if (!pathWasCreated) {
        NSLog(@"%@", error);
    }
}

@end