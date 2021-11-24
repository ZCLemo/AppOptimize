//
//  UnrecognizedSelectorForbidProxy.m
//  AppOptimize
//
//  Created by howbuy on 2021/11/19.
//

#import "UnrecognizedSelectorForbidProxy.h"
#import <objc/runtime.h>

@implementation UnrecognizedSelectorForbidProxy

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    //添加方法防止崩溃
    class_addMethod([self class], sel, imp_implementationWithBlock(^{
        // 收集堆栈，上报 Crash
        NSLog(@"%@", [NSThread callStackSymbols]);

        return nil;
    }), "@@:");
    return YES;
}

@end
