//
//  NSArray+Extension.m
//  fjTestProject
//
//  Created by fjf on 2017/1/3.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import <objc/runtime.h>
#import "NSArray+Safe.h"
#import "NSObject+Swizzling.h"

@implementation NSArray (Safe)

#pragma mark --- init method

+ (void)load {
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //替换 objectAtIndex
        NSString *tmpStr = @"objectAtIndex:";
        NSString *tmpFirstStr = @"safe_ZeroObjectAtIndex:";
        NSString *tmpThreeStr = @"safe_objectAtIndex:";
        NSString *tmpSecondStr = @"safe_singleObjectAtIndex:";
        NSString *tmpFourStr = @"safe_frozenObjectAtIndex:";
        
        // 替换 objectAtIndexedSubscript
        
        NSString *tmpSubscriptStr = @"objectAtIndexedSubscript:";
        NSString *tmpSecondSubscriptStr = @"safe_objectAtIndexedSubscript:";
        NSString *tmpFourSubscriptStr = @"safe_frozenObjectAtIndexedSubscript:";
        
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArray0")
                                     originalSelector:NSSelectorFromString(tmpStr)                                     swizzledSelector:NSSelectorFromString(tmpFirstStr)];
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSSingleObjectArrayI")
                                     originalSelector:NSSelectorFromString(tmpStr)                                     swizzledSelector:NSSelectorFromString(tmpSecondStr)];
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayI")
                                     originalSelector:NSSelectorFromString(tmpStr)                                     swizzledSelector:NSSelectorFromString(tmpThreeStr)];
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSFrozenArrayM")
                                     originalSelector:NSSelectorFromString(tmpStr)                                     swizzledSelector:NSSelectorFromString(tmpFourStr)];
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayI")
                                     originalSelector:NSSelectorFromString(tmpSubscriptStr)                                     swizzledSelector:NSSelectorFromString(tmpSecondSubscriptStr)];
        
        // NSMutableArray copy得到的数组为__NSFrozenArrayM
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSFrozenArrayM")
                                     originalSelector:NSSelectorFromString(tmpSubscriptStr)                                     swizzledSelector:NSSelectorFromString(tmpFourSubscriptStr)];
        
        //替换 subarrayWithRange:
        NSString *tmpRangeStr = @"subarrayWithRange:";
        NSString *tmpRangeFirstStr = @"safe_ZeroSubarrayWithRange:";
        NSString *tmpRangeThreeStr = @"safe_subarrayWithRange:";
        NSString *tmpRangeSecondStr = @"safe_singleSubarrayWithRange:";
        NSString *tmpRangeFourStr = @"safe_frozenSubarrayWithRange:";
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArray0")
                                     originalSelector:NSSelectorFromString(tmpRangeStr)                                     swizzledSelector:NSSelectorFromString(tmpRangeFirstStr)];
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSSingleObjectArrayI")
                                     originalSelector:NSSelectorFromString(tmpRangeStr)                                     swizzledSelector:NSSelectorFromString(tmpRangeSecondStr)];
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayI")
                                     originalSelector:NSSelectorFromString(tmpRangeStr)                                     swizzledSelector:NSSelectorFromString(tmpRangeThreeStr)];
        
        // NSMutableArray copy得到的数组为__NSFrozenArrayM 使用subarrayWithRange又变成了NSArray
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"NSArray")
                                     originalSelector:NSSelectorFromString(tmpRangeStr)                                     swizzledSelector:NSSelectorFromString(tmpRangeFourStr)];
        
    });

}


#pragma mark --- implement method

/**
 取出NSArray 第index个 值 对应 __NSArrayI
 
 @param index 索引 index
 @return 返回值
 */
- (id)safe_objectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safe_objectAtIndex:index];
}


/**
 取出NSArray 第index个 值 对应 __NSSingleObjectArrayI
 
 @param index 索引 index
 @return 返回值
 */
- (id)safe_singleObjectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safe_singleObjectAtIndex:index];
}

/**
 取出NSArray 第index个 值 对应 __NSArray0
 
 @param index 索引 index
 @return 返回值
 */
- (id)safe_ZeroObjectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safe_ZeroObjectAtIndex:index];
}

- (id)safe_frozenObjectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safe_frozenObjectAtIndex:index];
}

/**
 取出NSArray 第index个 值 对应 __NSArrayI
 
 @param idx 索引 idx
 @return 返回值
 */
- (id)safe_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count){
        return nil;
    }
    return [self safe_objectAtIndexedSubscript:idx];
}

- (id)safe_frozenObjectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count){
        return nil;
    }
    return [self safe_frozenObjectAtIndexedSubscript:idx];
}

- (NSArray *)safe_ZeroSubarrayWithRange:(NSRange)range
{
    if (range.location > self.count) {
        range = NSMakeRange(0, self.count);
    }
    
    if (range.length > self.count) {
        range = NSMakeRange(0, self.count);
    }
    
    if ((range.location + range.length) > self.count) {
        range = NSMakeRange(0, self.count);
    }
    
    return [self safe_ZeroSubarrayWithRange:range];
}

- (NSArray *)safe_subarrayWithRange:(NSRange)range
{
    if (range.location > self.count) {
        range = NSMakeRange(0, self.count);
    }
    
    if (range.length > self.count) {
        range = NSMakeRange(0, self.count);
    }
    
    if ((range.location + range.length) > self.count) {
        range = NSMakeRange(0, self.count);
    }
    
    return [self safe_subarrayWithRange:range];
}

- (NSArray *)safe_singleSubarrayWithRange:(NSRange)range
{
    if (range.location > self.count) {
        range = NSMakeRange(0, self.count);
    }
    
    if (range.length > self.count) {
        range = NSMakeRange(0, self.count);
    }
    
    if ((range.location + range.length) > self.count) {
        range = NSMakeRange(0, self.count);
    }
    
    return [self safe_singleSubarrayWithRange:range];
}

- (NSArray *)safe_frozenSubarrayWithRange:(NSRange)range
{
    if (range.location > self.count) {
        range = NSMakeRange(0, self.count);
    }
    
    if (range.length > self.count) {
        range = NSMakeRange(0, self.count);
    }
    
    if ((range.location + range.length) > self.count) {
        range = NSMakeRange(0, self.count);
    }
    
    return [self safe_frozenSubarrayWithRange:range];
}

@end
