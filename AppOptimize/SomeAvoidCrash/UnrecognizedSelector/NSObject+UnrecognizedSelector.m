//
//  NSObject+UnrecognizedSelector.m
//  AppOptimize
//
//  Created by howbuy on 2021/11/19.
//

#import "NSObject+UnrecognizedSelector.h"
#import "UnrecognizedSelectorForbidProxy.h"
#import <objc/runtime.h>

@implementation NSObject (UnrecognizedSelector)

+ (void)load {
    [self exchangeInstanceMethodWithSelfClass:self originalSelector:@selector(forwardingTargetForSelector:) swizzledSelector:@selector(forbid_forwardingTargetForSelector:)];
    
    [self exchangeClassMethodWithSelfClass:self originalSelector:@selector(forwardingTargetForSelector:) swizzledSelector:@selector(forbid_forwardingTargetForSelector:)];
    
}

- (id)forbid_forwardingTargetForSelector:(SEL)aSelector {
    return [self handleObject:self forwardingTargetForSelector:aSelector];
}

+ (id)forbid_forwardingTargetForSelector:(SEL)aSelector {
    // 如果重写了 forwardInvocation，说明自己要处理，这里直接返回
    if ([self classMethodHasOverwrited:@selector(forwardInvocation:) cls:self]) {
        return nil;
    }
    return [UnrecognizedSelectorForbidProxy new];
}

- (id)handleObject:(__unsafe_unretained id)object forwardingTargetForSelector:(SEL)aSelector {
    
    if (![self needGuard:[object class]]) {
        return nil;
    }
    
    return [UnrecognizedSelectorForbidProxy new];
}

- (BOOL)needGuard:(Class)cls {
    
    // 如果重写了 forwardInvocation，说明自己要处理，这里直接返回
    if ([[self class] methodHasOverwrited:@selector(forwardInvocation:) cls:cls]) {
        return NO;
    }
    return YES;
}

// 判断 cls 是否重写了 sel 方法，递归调用判断但不包括 NSObject
+ (BOOL)methodHasOverwrited:(SEL)sel cls:(Class)cls {
    
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(cls, &methodCount);
    for (int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        if (method_getName(method) == sel) {
            free(methods);
            return YES;
        }
    }
    free(methods);
    
    // 可能父类实现了这个 sel，一直遍历到基类 NSObject 为止
    if ([cls superclass] != [NSObject class]) {
        return [self methodHasOverwrited:sel cls:[cls superclass]];
    }
    return NO;
}

// 判断 cls 是否重写了 sel 方法，递归调用判断但不包括 NSObject
+ (BOOL)classMethodHasOverwrited:(SEL)sel cls:(Class)cls {
    
    unsigned int methodCount = 0;
    //获取元类
    Class metaClass = object_getClass(cls);
    Method *methods = class_copyMethodList(metaClass, &methodCount);
    for (int i = 0; i < methodCount; i++) {
        Method method = methods[i];
        //NSLog(@"------%@,%@",NSStringFromSelector(method_getName(method)),NSStringFromClass(cls));
        if (method_getName(method) == sel) {
            free(methods);
            return YES;
        }
    }
    free(methods);
    
    // 可能父类实现了这个 sel，一直遍历到基类 NSObject 为止
    if ([cls superclass] != [NSObject class]) {
        return [self classMethodHasOverwrited:sel cls:[cls superclass]];
    }
    return NO;
}


@end
