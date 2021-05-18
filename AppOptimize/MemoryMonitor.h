//
//  MemoryMonitor.h
//  AppOptimize
//
//  Created by chen on 2021/5/8.
//  内存使用监控

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemoryMonitor : NSObject

+ (MemoryMonitor *)shareInstance;

- (void)beginMonitor;

- (void)endMonitor;

@end

NS_ASSUME_NONNULL_END
