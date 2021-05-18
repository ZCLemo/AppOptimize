//
//  KartunMonitor.h
//  AppOptimize
//
//  Created by chen on 2021/5/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KartunMonitor : NSObject

+ (KartunMonitor *)shareInstance;
//开始监控卡顿
- (void)beginMintor;
//停止监控卡顿
- (void)endMonitor;

@end

NS_ASSUME_NONNULL_END
