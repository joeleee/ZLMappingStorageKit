//
//  NSDate+ZLAdditions.h
//  ZLMappingStorageKit
//
//  Created by Lee on 13-12-4.
//  Copyright (c) 2013年 ZhuochengLee. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSTimeInterval const oneDaySeconds;

@interface NSDate (ZLAdditions)

- (NSString *)dateToString:(NSString *)format;

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

- (NSDateComponents *)dateComponents;

@end