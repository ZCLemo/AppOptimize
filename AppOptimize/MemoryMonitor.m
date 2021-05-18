//
//  MemoryMonitor.m
//  AppOptimize
//
//  Created by chen on 2021/5/8.
//

#import "MemoryMonitor.h"
#include <mach/task.h>
#include <mach/mach_init.h>

@interface MemoryMonitor ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MemoryMonitor

+ (MemoryMonitor *)shareInstance
{
    static MemoryMonitor *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MemoryMonitor alloc] init];
    });
    return instance;
}

- (void)beginMonitor
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(monitorMemory) userInfo:nil repeats:YES];
}

- (void)endMonitor
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)monitorMemory
{
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if (kernelReturn == KERN_SUCCESS) {
        int64_t memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
        int64_t usage = memoryUsageInByte / 1024 / 1024;
        NSLog(@"内存占用情况:%lld",usage);
    }
}

@end
