//
//  CPUMonitor.m
//  AppOptimize
//
//  Created by chen on 2021/5/8.
//

#import "CPUMonitor.h"
#import "SMCallStack.h"

@interface CPUMonitor ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CPUMonitor

+ (CPUMonitor *)sharedIntance
{
    static CPUMonitor *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CPUMonitor alloc] init];
    });
    return instance;
}

- (void)beginMonitor
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(monitorCPU) userInfo:nil repeats:YES];
}

- (void)endMonitor
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)monitorCPU
{
    thread_act_array_t threads;
    mach_msg_type_number_t threadCount = 0;
    const task_t thisTask = mach_task_self();
    kern_return_t kr = task_threads(thisTask, &threads, &threadCount);
    if (kr != KERN_SUCCESS) {
        return;
    }
    for (int i = 0; i < threadCount; i++) {
        thread_info_data_t threadInfo;
        thread_basic_info_t threadBaseInfo;
        mach_msg_type_number_t threadInfoCount = THREAD_INFO_MAX;
        if (thread_info((thread_act_t)threads[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount) == KERN_SUCCESS) {
            threadBaseInfo = (thread_basic_info_t)threadInfo;
            if (!(threadBaseInfo->flags & TH_FLAGS_IDLE)) {
                integer_t cpuUsage = threadBaseInfo->cpu_usage / 10;
                if (cpuUsage > 70) {
                    //cup 消耗大于 70 时打印和记录堆栈
                    NSString *reStr = smStackOfThread(threads[i]);
                    NSLog(@"CPU useage overload thread stack：\n%@",reStr);
                }
            }
        }
    }
}

@end
