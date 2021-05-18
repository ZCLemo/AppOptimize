//
//  NSMutableAttributedString+Safe.m
//  HBKit
//
//  Created by yushu on 2019/6/25.
//  Copyright © 2019 aiyong.gu. All rights reserved.
//

#import "NSMutableAttributedString+Safe.h"
#import "NSObject+Swizzling.h"

@implementation NSMutableAttributedString (Safe)

+ (void)load {
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // 替换 attributedSubstringFromRange:
        NSString *tmpOriFuncStr = @"attributedSubstringFromRange:";
        NSString *tmpSafeFuncStr = @"safe_attributedSubstringFromRange:";
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"NSConcreteMutableAttributedString")
                                     originalSelector:NSSelectorFromString(tmpOriFuncStr)
                                     swizzledSelector:NSSelectorFromString(tmpSafeFuncStr)];
        
        // 替换 addAttribute:value:range:
        tmpOriFuncStr = @"addAttribute:value:range:";
        tmpSafeFuncStr = @"safe_addAttribute:value:range:";
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"NSConcreteMutableAttributedString")
                                     originalSelector:NSSelectorFromString(tmpOriFuncStr)
                                     swizzledSelector:NSSelectorFromString(tmpSafeFuncStr)];
        
        // 替换 addAttributes:range:
        tmpOriFuncStr = @"addAttributes:range:";
        tmpSafeFuncStr = @"safe_addAttributes:range:";
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"NSConcreteMutableAttributedString")
                                     originalSelector:NSSelectorFromString(tmpOriFuncStr)
                                     swizzledSelector:NSSelectorFromString(tmpSafeFuncStr)];
        
        // 替换 setAttributes:range:
        tmpOriFuncStr = @"setAttributes:range:";
        tmpSafeFuncStr = @"safe_setAttributes:range:";
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"NSConcreteMutableAttributedString")
                                     originalSelector:NSSelectorFromString(tmpOriFuncStr)
                                     swizzledSelector:NSSelectorFromString(tmpSafeFuncStr)];
        
        // 替换 removeAttribute:range:
        tmpOriFuncStr = @"removeAttribute:range:";
        tmpSafeFuncStr = @"safe_removeAttribute:range:";
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"NSConcreteMutableAttributedString")
                                     originalSelector:NSSelectorFromString(tmpOriFuncStr)
                                     swizzledSelector:NSSelectorFromString(tmpSafeFuncStr)];
        
        // 替换 deleteCharactersInRange:
        tmpOriFuncStr = @"deleteCharactersInRange:";
        tmpSafeFuncStr = @"safe_deleteCharactersInRange:";
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"NSConcreteMutableAttributedString")
                                     originalSelector:NSSelectorFromString(tmpOriFuncStr)
                                     swizzledSelector:NSSelectorFromString(tmpSafeFuncStr)];
        
        // 替换 replaceCharactersInRange:withString:
        tmpOriFuncStr = @"replaceCharactersInRange:withString:";
        tmpSafeFuncStr = @"safe_replaceCharactersInRange:withString:";
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"NSConcreteMutableAttributedString")
                                     originalSelector:NSSelectorFromString(tmpOriFuncStr)
                                     swizzledSelector:NSSelectorFromString(tmpSafeFuncStr)];
        
        // 替换 replaceCharactersInRange:withAttributedString:
        tmpOriFuncStr = @"replaceCharactersInRange:withAttributedString:";
        tmpSafeFuncStr = @"safe_replaceCharactersInRange:withAttributedString:";
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"NSConcreteMutableAttributedString")
                                     originalSelector:NSSelectorFromString(tmpOriFuncStr)
                                     swizzledSelector:NSSelectorFromString(tmpSafeFuncStr)];
        
        // 替换 initWithString:
        tmpOriFuncStr = @"initWithString:";
        tmpSafeFuncStr = @"safe_initWithString:";
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"NSConcreteMutableAttributedString")
                                     originalSelector:NSSelectorFromString(tmpOriFuncStr)
                                     swizzledSelector:NSSelectorFromString(tmpSafeFuncStr)];
        
        // 替换 initWithString:attributes:
        tmpOriFuncStr = @"initWithString:attributes:";
        tmpSafeFuncStr = @"safe_initWithString:attributes:";
        
        [NSObject exchangeInstanceMethodWithSelfClass:NSClassFromString(@"NSConcreteMutableAttributedString")
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

- (void)safe_addAttribute:(NSAttributedStringKey)name value:(id)value range:(NSRange)range
{
    if (!value) {
        return;
    }
    
    if (range.location > self.length) {
        return;
    }
    
    if (range.length > self.length) {
        return;
    }
    
    if ((range.location + range.length) > self.length) {
        return;
    }
    
    [self safe_addAttribute:name value:value range:range];
}

- (void)safe_addAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs range:(NSRange)range
{
    if (!attrs) {
        return;
    }
    
    if (range.location > self.length) {
        return;
    }
    
    if (range.length > self.length) {
        return;
    }
    
    if ((range.location + range.length) > self.length) {
        return;
    }
    
    [self safe_addAttributes:attrs range:range];
}

- (void)safe_setAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs range:(NSRange)range
{
    if (range.location > self.length) {
        return;
    }
    
    if (range.length > self.length) {
        return;
    }
    
    if ((range.location + range.length) > self.length) {
        return;
    }
    
    [self safe_setAttributes:attrs range:range];
}

- (void)safe_removeAttribute:(NSAttributedStringKey)name range:(NSRange)range
{
    if (range.location > self.length) {
        return;
    }
    
    if (range.length > self.length) {
        return;
    }
    
    if ((range.location + range.length) > self.length) {
        return;
    }
    
    [self safe_removeAttribute:name range:range];
}

- (void)safe_deleteCharactersInRange:(NSRange)range
{
    if (range.location > self.length) {
        return;
    }
    
    if (range.length > self.length) {
        return;
    }
    
    if ((range.location + range.length) > self.length) {
        return;
    }
    
    [self safe_deleteCharactersInRange:range];
}

- (void)safe_replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    if (!str) {
        return;
    }
    
    if (range.location > self.length) {
        return;
    }
    
    if (range.length > self.length) {
        return;
    }
    
    if ((range.location + range.length) > self.length) {
        return;
    }
    
    [self safe_replaceCharactersInRange:range withString:str];
}

- (void)safe_replaceCharactersInRange:(NSRange)range withAttributedString:(NSAttributedString *)attrString
{
    if (!attrString) {
        return;
    }
    
    if (range.location > self.length) {
        return;
    }
    
    if (range.length > self.length) {
        return;
    }
    
    if ((range.location + range.length) > self.length) {
        return;
    }
    
    [self safe_replaceCharactersInRange:range withAttributedString:attrString];
}

- (instancetype)safe_initWithString:(NSString *)str
{
    if (!str) {
        return [self safe_initWithString:@""];
    }
    
    return [self safe_initWithString:str];
}

- (instancetype)safe_initWithString:(NSString *)str attributes:(NSDictionary<NSAttributedStringKey,id> *)attrs
{
    if (!str) {
        return [self safe_initWithString:@"" attributes:attrs];
    }
    
    return [self safe_initWithString:str attributes:attrs];
}

@end
