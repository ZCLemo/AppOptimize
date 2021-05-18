
//
//  NSMutableArray+Extension.m
//  fjTestProject
//
//  Created by fjf on 2017/1/3.
//  Copyright © 2017年 fjf. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+Swizzling.h"
#import "NSMutableArray+Safe.h"


@implementation NSMutableArray (Safe)

#pragma mark --- init method

+ (void)load {
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //替换 objectAtIndex:
        NSString *tmpGetStr = @"objectAtIndex:";
        NSString *tmpSafeGetStr = @"safeMutable_objectAtIndex:";
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpGetStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeGetStr)];
        
        //替换 removeObjectsInRange:
        NSString *tmpRemoveStr = @"removeObjectsInRange:";
        NSString *tmpSafeRemoveStr = @"safeMutable_removeObjectsInRange:";
        

        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpRemoveStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeRemoveStr)];
        
        
        //替换 insertObject:atIndex:
        NSString *tmpInsertStr = @"insertObject:atIndex:";
        NSString *tmpSafeInsertStr = @"safeMutable_insertObject:atIndex:";
        
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpInsertStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeInsertStr)];
        
        //替换 removeObject:inRange:
        NSString *tmpRemoveRangeStr = @"removeObject:inRange:";
        NSString *tmpSafeRemoveRangeStr = @"safeMutable_removeObject:inRange:";
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpRemoveRangeStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeRemoveRangeStr)];
        
        
        // 替换 objectAtIndexedSubscript
        
        NSString *tmpSubscriptStr = @"objectAtIndexedSubscript:";
        NSString *tmpSecondSubscriptStr = @"safeMutable_objectAtIndexedSubscript:";
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpSubscriptStr)                                     swizzledSelector:NSSelectorFromString(tmpSecondSubscriptStr)];
        
        // 替换 subarrayWithRange:
        NSString *tmpSubarrayRangeStr = @"subarrayWithRange:";
        NSString *tmpSafeSubarrayRangeStr = @"safe_subarrayWithRange:";
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpSubarrayRangeStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeSubarrayRangeStr)];
        
        // 替换 replaceObjectAtIndex:withObject:
        NSString *tmpReplaceIndexStr = @"replaceObjectAtIndex:withObject:";
        NSString *tmpSafeReplaceIndexStr = @"safe_replaceObjectAtIndex:withObject:";
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpReplaceIndexStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeReplaceIndexStr)];
        
        // 替换 replaceObjectAtIndex:withObject:
        NSString *tmpRemoveIndexesStr = @"removeObjectsAtIndexes:";
        NSString *tmpSafeRemoveIndexesStr = @"safe_removeObjectsAtIndexes:";
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpRemoveIndexesStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeRemoveIndexesStr)];
    });
    
}

#pragma mark --- implement method

/**
 取出NSArray 第index个 值
 
 @param index 索引 index
 @return 返回值
 */
- (id)safeMutable_objectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safeMutable_objectAtIndex:index];
}

/**
 NSMutableArray 移除 索引 index 对应的 值
 
 @param range 移除 范围
 */
- (void)safeMutable_removeObjectsInRange:(NSRange)range {

    if (range.location > self.count) {
        return;
    }
    
    if (range.length > self.count) {
        return;
    }
    
    if ((range.location + range.length) > self.count) {
        return;
    }
    
     return [self safeMutable_removeObjectsInRange:range];
}


/**
 在range范围内， 移除掉anObject

 @param anObject 移除的anObject
 @param range 范围
 */
- (void)safeMutable_removeObject:(id)anObject inRange:(NSRange)range {
    if (range.location > self.count) {
        return;
    }
    
    if (range.length > self.count) {
        return;
    }
    
    if ((range.location + range.length) > self.count) {
        return;
    }
    
    if (!anObject){
        return;
    }

    
    return [self safeMutable_removeObject:anObject inRange:range];

}

/**
 NSMutableArray 插入 新值 到 索引index 指定位置
 
 @param anObject 新值
 @param index 索引 index
 */
- (void)safeMutable_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > self.count) {
            return;
    }
    
    if (!anObject){
        return;
    }
    
    [self safeMutable_insertObject:anObject atIndex:index];
}


/**
 取出NSArray 第index个 值 对应 __NSArrayI
 
 @param idx 索引 idx
 @return 返回值
 */
- (id)safeMutable_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count){
        return nil;
    }
    return [self safeMutable_objectAtIndexedSubscript:idx];
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

- (void)safe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (index >= self.count) {
        return;
    }
    
    if (!anObject){
        return;
    }
    
    [self safe_replaceObjectAtIndex:index withObject:anObject];
}

- (void)safe_removeObjectsAtIndexes:(NSIndexSet *)indexes
{
    if (!indexes) {
        return;
    }
    
    __block BOOL flag = NO;
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= self.count) {
            flag = YES;
            *stop = YES;
        }
    }];
    
    if (flag) {
        return;
    }
    
    return [self safe_removeObjectsAtIndexes:indexes];
}

@end
