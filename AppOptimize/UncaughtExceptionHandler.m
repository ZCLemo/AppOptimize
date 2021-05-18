//
//  UncaughtExceptionHandler.m
//  AppOptimize
//
//  Created by chen on 2021/5/7.
//

#import "UncaughtExceptionHandler.h"
#import <UIKit/UIKit.h>

#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import <CommonCrypto/CommonDigest.h>

//NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";
//NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";
//NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";
//NSString * const UncaughtExceptionHandlerFileKey = @"UncaughtExceptionHandlerFileKey";
//
//volatile int32_t UncaughtExceptionCount = 0;
//const int32_t UncaughtExceptionMaximum = 10;
//const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
//const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;
//
//static UncaughtExceptionHandler *handler = nil;

@interface UncaughtExceptionHandler ()

@property (nonatomic, assign) BOOL needException;

@end

@implementation UncaughtExceptionHandler

+ (void)installUncaughtExceptionHandler
{
    handler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    struct sigaction mySigAction;
    mySigAction.sa_sigaction = uncaughtSignExceptionHandler;
    mySigAction.sa_flags = SA_SIGINFO;
    sigemptyset(&mySigAction.sa_mask);
    sigaction(SIGABRT, &mySigAction, NULL);
    sigaction(SIGILL , &mySigAction, NULL);
    sigaction(SIGFPE , &mySigAction, NULL);
    sigaction(SIGBUS , &mySigAction, NULL);
    sigaction(SIGSEGV, &mySigAction, NULL);
    sigaction(SIGSYS , &mySigAction, NULL);
    sigaction(SIGPIPE, &mySigAction, NULL);
}

static NSUncaughtExceptionHandler *handler = NULL;
static void uncaughtExceptionHandler(NSException *exception) {
    // 摘要，用来合并相同的crash
    NSString *summary = nil;
    NSString *crashContent = nil;
    // 生成摘要/crash内容
    [UncaughtExceptionHandler generateCrashInfoWithName:exception.name reason:exception.reason userInfo:exception.userInfo stacks:[exception callStackSymbols] outputSummary:&summary crashContent:&crashContent];
    
    if(handler) {
        handler(exception);
    }
    [[[UncaughtExceptionHandler alloc] init] handleExceptionWithSummary:summary crashContent:crashContent];
}

void uncaughtSignExceptionHandler(int sig, siginfo_t *info, void *context) {
    
    NSArray *stacks = [UncaughtExceptionHandler backtrace];
    NSString *name = nil;
    switch (sig) {
        case SIGABRT:   name = @"SIGABRT"; break;
        case SIGILL:    name = @"SIGILL"; break;
        case SIGFPE:    name = @"SIGFPE"; break;
        case SIGBUS:    name = @"SIGBUS"; break;
        case SIGSEGV:   name = @"SIGSEGV"; break;
        case SIGSYS:    name = @"SIGSYS"; break;
        case SIGPIPE:   name = @"SIGPIPE"; break;
        default: break;
    }
    
    // 摘要，用来合并相同的crash
    NSString *summary = nil;
    NSString *crashContent = nil;
    if (name) {
        // 生成摘要/crash内容
        [UncaughtExceptionHandler generateCrashInfoWithName:name reason:nil userInfo:nil stacks:stacks outputSummary:&summary crashContent:&crashContent];
    }
    [[[UncaughtExceptionHandler alloc] init] handleExceptionWithSummary:summary crashContent:crashContent];
}

//获取函数堆栈信息
+ (NSArray *)backtrace {
    //指针列表
    void* callstack[128];
    //backtrace用来获取当前线程的调用堆栈，获取的信息存放在这里的callstack中
    //128用来指定当前的buffer中可以保存多少个void*元素
    //返回值是实际获取的指针个数
    int frames = backtrace(callstack, 128);
    //backtrace_symbols将从backtrace函数获取的信息转化为一个字符串数组
    //返回一个指向字符串数组的指针
    //每个字符串包含了一个相对于callstack中对应元素的可打印信息，包括函数名、偏移地址、实际返回地址
    char **strs = backtrace_symbols(callstack, frames);

    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = 0; i < frames; i++) {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);

    return backtrace;
}

- (void)handleExceptionWithSummary:(NSString *)summary crashContent:(NSString *)crashContent
{
    NSLog(@"crash:%@,%@",summary,crashContent);
    //本地存储
    [UncaughtExceptionHandler writeToFileWithSummary:summary crashContent:crashContent];
    
    //runloop保活
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);

    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"程序崩溃啦" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.needException = YES;
    }];
    [controller addAction:action];

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:YES completion:nil];

    //当接收到异常处理消息时，让程序开始runloop，防止程序死亡
    while (!self.needException) {
        for (NSString *mode in (__bridge NSArray *)allModes)
        {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    //当点击弹出视图的Cancel按钮哦,needException ＝ YES,上边的循环跳出
    CFRelease(allModes);
}

+ (void)writeToFileWithSummary:(NSString *)summary crashContent:(NSString *)crashContent {
    NSString *directoryPath = [self directoryPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = [directoryPath stringByAppendingPathComponent:[self md5:summary]];
    [crashContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+ (NSString *)directoryPath {
    NSString *basePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [basePath stringByAppendingPathComponent:@"crash"];
}

+ (NSString *)md5:(NSString *)string {
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH] = {0};
    
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

+ (void)generateCrashInfoWithName:(NSString *)name reason:(NSString *)reason userInfo:(id)userInfo stacks:(NSArray *)stacks outputSummary:(NSString **)summary crashContent:(NSString **)crashContent {
    NSMutableString *crashContentM = @"".mutableCopy;
    
    /** 异常名字 */
    if (name.length > 0) {
        [crashContentM appendFormat:@"%@\n", name];
    }
    
    /** 原因 */
    // 用来生成摘要的原因（会对原有的原因进行处理）
    NSString *reasonForSummary = nil;
    if (reason.length > 0) {
        [crashContentM appendFormat:@"%@\n", reason];
        
        NSMutableString *tempReason = reason.mutableCopy;
        
        /** 对reason进行处理，让多个相同地方的crash可以合并 */
        // 匹配文案中的0x0000001234,地址，转成统一的
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"0x[0-9a-zA-Z]+[^0-9a-zA-Z]" options:0 error:nil];
        NSArray *arr = [regular matchesInString:tempReason options:NSMatchingReportProgress range:NSMakeRange(0, tempReason.length)];
        // 匹配文案末尾的0x0000001234,地址，转成统一的
        NSRegularExpression *regular1 = [NSRegularExpression regularExpressionWithPattern:@"0x[0-9a-zA-Z]+$" options:0 error:nil];
        NSArray *arr1 = [regular1 matchesInString:tempReason options:NSMatchingReportProgress range:NSMakeRange(0, tempReason.length)];
        // 匹配数组范围
        NSRegularExpression *regular2 = [NSRegularExpression regularExpressionWithPattern:@"\\[[0-9]+ .. [0-9]+\\]" options:0 error:nil];
        NSArray *arr2 = [regular2 matchesInString:tempReason options:NSMatchingReportProgress range:NSMakeRange(0, tempReason.length)];
        // 匹配下标
        NSRegularExpression *regular3 = [NSRegularExpression regularExpressionWithPattern:@"index [0-9]+[^0-9]" options:0 error:nil];
        NSArray *arr3 = [regular3 matchesInString:tempReason options:NSMatchingReportProgress range:NSMakeRange(0, tempReason.length)];
        
        NSMutableArray *array = @[].mutableCopy;
        if (arr.count > 0) {
            [array addObjectsFromArray:arr];
        }
        if (arr1.count > 0) {
            [array addObjectsFromArray:arr1];
        }
        if (arr2.count > 0) {
            [array addObjectsFromArray:arr2];
        }
        if (arr3.count > 0) {
            [array addObjectsFromArray:arr3];
        }
        // 替换为固定字符串
        for (NSTextCheckingResult *result in array) {
            NSString *replaceStr = [@(result.range.length) stringValue];
            replaceStr = [@"%" stringByAppendingFormat:@"0%@d",replaceStr];
            replaceStr = [NSString stringWithFormat:replaceStr, 0];
            [tempReason replaceCharactersInRange:result.range withString:replaceStr];
        }
    }
    
    /** 其他信息 */
    if (userInfo) {
        [crashContentM appendFormat:@"userInfo: %@\n", userInfo];
    }
    
    /** crash摘要，下面还会拼接部分堆栈信息，用来合并相同的crash */
    NSMutableString *summaryM = nil; // 摘要
    if (name.length > 0 || reasonForSummary.length > 0) {
        summaryM = [NSMutableString stringWithFormat:@"%@;%@", name, reasonForSummary];
    }
    else {
        summaryM = @"other".mutableCopy;
    }
    
    /** crash线程 */
    [crashContentM appendFormat:@"crash在 %@\n", [NSThread isMainThread] ? @"主线程" : @"子线程"];
    
    /** crash线程的堆栈信息 */
    NSString *appName = [[NSBundle mainBundle] infoDictionary][(NSString *)kCFBundleNameKey];
    [crashContentM appendString:@"stacks:\n"];
    for (NSString *stackStr in stacks) {
        // 保持堆栈信息
        [crashContentM appendFormat:@"%@\n", stackStr];
        
        // 去除首尾的空格
        NSString *tempStackStr = [stackStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        // 分割成数组，并去除中间的重复空格
        NSMutableArray *array = [tempStackStr componentsSeparatedByString:@" "].mutableCopy;
        [array removeObject:@""];
        
        if (array.count > 1) {
            // 当前调用的lib名
            NSString *stackName = array[1];
            
            [summaryM appendFormat:@";%@", array[1]];
            
            // 如果是非系统的库调用，将函数调用信息添加上
            if ([stackName isEqualToString:appName] && array.count > 3) {
                [summaryM appendFormat:@";%@", array[3]];
            }
        }
    }
    
    // 拼接摘要信息
    *summary = summaryM.copy;
    // 赋值crash内容
    *crashContent = crashContentM.copy;
}

@end
