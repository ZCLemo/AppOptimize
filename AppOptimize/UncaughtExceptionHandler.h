//
//  UncaughtExceptionHandler.h
//  AppOptimize
//
//  Created by chen on 2021/5/7.
//  崩溃监控

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UncaughtExceptionHandler : NSObject

+ (void)installUncaughtExceptionHandler;

@end

NS_ASSUME_NONNULL_END
