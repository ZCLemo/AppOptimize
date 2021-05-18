//
//  CPUMonitor.h
//  AppOptimize
//
//  Created by chen on 2021/5/8.
//  CPU使用率监控

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CPUMonitor : NSObject

+ (CPUMonitor *)sharedIntance;

- (void)beginMonitor;

- (void)endMonitor;

@end

NS_ASSUME_NONNULL_END
