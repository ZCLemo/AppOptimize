//
//  NSAttributedString+Safe.m
//  HBKit
//
//  Created by yushu on 2019/6/25.
//  Copyright © 2019 aiyong.gu. All rights reserved.
//

#import "NSAttributedString+Safe.h"
#import "NSObject+Swizzling.h"

@implementation NSAttributedString (Safe)

+ (void)load {
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 替换 attributedSubstringFromRange:
        NSString *tmpOriFuncStr = @"attributedSubstringFromRange:";
        NSString *tmpSafeFuncStr = @"safe_attributedSubstringFromRange:";
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"NSConcreteAttributedString")
                                     originalSelector:NSSelectorFromString(tmpOriFuncStr)
                                     swizzledSelector:NSSelectorFromString(tmpSafeFuncStr)];
        
        // 替换 initWithString:
        tmpOriFuncStr = @"initWithString:";
        tmpSafeFuncStr = @"safe_initWithString:";
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"NSConcreteAttributedString")
                                     originalSelector:NSSelectorFromString(tmpOriFuncStr)
                                     swizzledSelector:NSSelectorFromString(tmpSafeFuncStr)];
    });
}

- (NSAttributedString *)safe_attributedSubstringFromRange:(NSRange)range
{
    if (range.location > self.length) {
        return nil;
    }
    
    if (range.length > self.length) {
        return nil;
    }
    
    if ((range.location + range.length) > self.length) {
        return nil;
    }

    return [self safe_attributedSubstringFromRange:range];
}

- (instancetype)safe_initWithString:(NSString *)str
{
    if (!str) {
        return [self safe_initWithString:@""];
    }
    
    return [self safe_initWithString:str];
}

@end
