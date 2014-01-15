//
//  ZLStoragesManager.h
//
//  Created by Lee on 13-11-15.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLStoragesManager : NSObject

+ (ZLStoragesManager *)sharedManager;

- (NSManagedObjectContext *)managedObjectContextForFullPath:(NSString *)path modelName:(NSString *)model;
- (BOOL)saveContextForFullPath:(NSString *)path;

@end