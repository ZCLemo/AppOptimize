//
//  KartunMonitor.m
//  AppOptimize
//
//  Created by chen on 2021/5/8.
//  卡顿监控

#import "KartunMonitor.h"
#import <CrashReporter/CrashReporter.h>
#import "SMCallStack.h"

@interface KartunMonitor (){
    int timeoutCount;
    CFRunLoopObserverRef runLoopObserver;
    dispatch_semaphore_t dispatchSemaphore;
    CFRunLoopActivity runLoopActivity;
}

@end

@implementation KartunMonitor


+ (KartunMonitor *)shareInstance
{
    static KartunMonitor *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[KartunMonitor alloc] init];
    });
    return instance;
}

- (void)beginMintor
{
    if (runLoopObserver) {
        return;
    }
    dispatchSemaphore = dispatch_semaphore_create(0);
    //创建一个观察者
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserverCallBack, &context);
    //将观察者添加到主线程runloop的common模式下的观察中
    CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    //创建子线程监控
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //子线程开启一个持续的loop用来进行监控
        while (YES) {
            //连续5次50ms的耗时操作认为是卡顿
            long semaphoreWait = dispatch_semaphore_wait(self->dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, 50*NSEC_PER_MSEC));
            if (semaphoreWait != 0) {
                if (!self->runLoopObserver) {
                    self->timeoutCount = 0;
                    self->dispatchSemaphore = 0;
                    self->runLoopActivity = 0;
                    return;
                }
                if (self->runLoopActivity == kCFRunLoopBeforeSources || self->runLoopActivity == kCFRunLoopAfterWaiting) {
                    self->timeoutCount ++ ;
                    if (self->timeoutCount < 5) {
                        continue;
                    }
                    //卡爆了，记录堆栈信息
                    NSString *reportString = [SMCallStack callStackWithType:SMCallStackTypeAll];
                    NSLog(@"zhaochen:%@",reportString);
                    
                }//end activity
            }// end semaphore wait
            self->timeoutCount = 0;
        }// end while
    });
}

- (void)endMonitor
{
    if (!runLoopObserver) {
        return;
    }
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    CFRelease(runLoopObserver);
    runLoopObserver = NULL;
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    KartunMonitor *minitor = (__bridge  KartunMonitor*)info;
    minitor->runLoopActivity = activity;
    dispatch_semaphore_t semaphore = minitor->dispatchSemaphore;
    dispatch_semaphore_signal(semaphore);
}

@end
